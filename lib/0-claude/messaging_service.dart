import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'message.dart';
import 'crypto_service.dart';
import 'webrtc_service.dart';
import 'database_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum MessageProtocol {
  text,
  audio,
  deliveryReceipt,
  readReceipt,
  typing,
}

/// Service principal de messagerie orchestrant WebRTC, crypto et stockage
class MessagingService {
  final WebRTCService _webrtc;
  final CryptoService _crypto;
  final DatabaseService _database;
  
  final _uuid = const Uuid();
  final _messageController = StreamController<Message>.broadcast();
  final _typingController = StreamController<Map<String, bool>>.broadcast();
  
  final Map<String, Timer?> _typingTimers = {};

  Stream<Message> get onMessage => _messageController.stream;
  Stream<Map<String, bool>> get onTyping => _typingController.stream;

  MessagingService(this._webrtc, this._crypto, this._database) {
    _initializeMessageListeners();
  }

  /// Envoie un message texte
  Future<Message> sendTextMessage(String contactDeviceId, String text) async {
    final contact = await _database.getContact(contactDeviceId);
    if (contact == null) {
      throw Exception('Contact non trouvé');
    }

    // Chiffrer le message
    final encrypted = await _crypto.encryptMessage(text, contact.publicKey);
    
    // Créer le message
    final message = Message(
      messageId: _uuid.v4(),
      conversationId: contactDeviceId,
      encryptedContent: jsonEncode(encrypted),
      typeIndex: MessageType.text.index,
      statusIndex: MessageStatus.sending.index,
      isSentByMe: true,
    );

    // Sauvegarder localement
    await _database.saveMessage(message);
    
    // Envoyer via WebRTC
    await _sendViaWebRTC(contactDeviceId, {
      'protocol': MessageProtocol.text.name,
      'messageId': message.messageId,
      'encrypted': encrypted,
      'timestamp': message.timestamp.toIso8601String(),
    });

    // Mettre à jour le statut
    message.status = MessageStatus.sent;
    await _database.updateMessage(message);
    
    return message;
  }

  /// Envoie un message audio
  Future<Message> sendAudioMessage(
    String contactDeviceId,
    String audioPath,
    int duration,
  ) async {
    final contact = await _database.getContact(contactDeviceId);
    if (contact == null) {
      throw Exception('Contact non trouvé');
    }

    // Lire le fichier audio et le chiffrer
    final audioBytes = await File(audioPath).readAsBytes();
    final audioBase64 = base64.encode(audioBytes);
    final encrypted = await _crypto.encryptMessage(audioBase64, contact.publicKey);

    final message = Message(
      messageId: _uuid.v4(),
      conversationId: contactDeviceId,
      encryptedContent: jsonEncode(encrypted),
      typeIndex: MessageType.audio.index,
      statusIndex: MessageStatus.sending.index,
      isSentByMe: true,
      localMediaPath: audioPath,
      audioDuration: duration,
      fileSize: audioBytes.length,
    );

    await _database.saveMessage(message);

    await _sendViaWebRTC(contactDeviceId, {
      'protocol': MessageProtocol.audio.name,
      'messageId': message.messageId,
      'encrypted': encrypted,
      'duration': duration,
      'timestamp': message.timestamp.toIso8601String(),
    });

    message.status = MessageStatus.sent;
    await _database.updateMessage(message);

    return message;
  }

  /// Envoie un indicateur "en train d'écrire"
  Future<void> sendTypingIndicator(String contactDeviceId, bool isTyping) async {
    try {
      if (_webrtc.isPeerConnected(contactDeviceId)) {
        await _webrtc.sendMessage(contactDeviceId, {
          'protocol': MessageProtocol.typing.name,
          'typing': isTyping,
        });
      }
    } catch (e) {
      // Ignorer les erreurs de typing
    }
  }

  /// Marque un message comme lu
  Future<void> markMessageAsRead(Message message) async {
    if (message.isSentByMe || message.isRead) return;

    message.isRead = true;
    await _database.updateMessage(message);

    // Envoyer un reçu de lecture
    try {
      await _webrtc.sendMessage(message.conversationId, {
        'protocol': MessageProtocol.readReceipt.name,
        'messageId': message.messageId,
      });
    } catch (e) {
      // Ignorer si non connecté
    }
  }

  /// Réessaie l'envoi des messages échoués
  Future<void> retryFailedMessages(String contactDeviceId) async {
    final failedMessages = await _database.getFailedMessages(contactDeviceId);
    
    for (final message in failedMessages) {
      if (message.sendAttempts >= 3) continue;

      message.sendAttempts++;
      message.status = MessageStatus.sending;
      await _database.updateMessage(message);

      try {
        final encrypted = jsonDecode(message.encryptedContent);
        await _sendViaWebRTC(contactDeviceId, {
          'protocol': message.type == MessageType.text 
              ? MessageProtocol.text.name 
              : MessageProtocol.audio.name,
          'messageId': message.messageId,
          'encrypted': encrypted,
          'timestamp': message.timestamp.toIso8601String(),
          if (message.type == MessageType.audio) 'duration': message.audioDuration,
        });

        message.status = MessageStatus.sent;
      } catch (e) {
        message.status = MessageStatus.failed;
      }

      await _database.updateMessage(message);
    }
  }

  // === Gestion des messages entrants ===

  void _initializeMessageListeners() {
    // Écouter les changements de connexion
    _webrtc.onConnectionStateChange.listen((state) {
      final contactDeviceId = state.keys.first;
      final isConnected = state.values.first;

      if (isConnected) {
        // Réessayer les messages échoués
        retryFailedMessages(contactDeviceId);
      }
    });
  }

  /// Abonne aux messages d'un contact
  StreamSubscription<Map<String, dynamic>>? listenToContact(String contactDeviceId) {
    final stream = _webrtc.getMessageStream(contactDeviceId);
    if (stream == null) return null;

    return stream.listen((data) => _handleIncomingMessage(contactDeviceId, data));
  }

  Future<void> _handleIncomingMessage(
    String contactDeviceId,
    Map<String, dynamic> data,
  ) async {
    final protocol = MessageProtocol.values.firstWhere(
      (p) => p.name == data['protocol'],
    );

    switch (protocol) {
      case MessageProtocol.text:
      case MessageProtocol.audio:
        await _handleDataMessage(contactDeviceId, data, protocol);
        break;
      case MessageProtocol.deliveryReceipt:
        await _handleDeliveryReceipt(data['messageId']);
        break;
      case MessageProtocol.readReceipt:
        await _handleReadReceipt(data['messageId']);
        break;
      case MessageProtocol.typing:
        _handleTypingIndicator(contactDeviceId, data['typing']);
        break;
    }
  }

  Future<void> _handleDataMessage(
    String contactDeviceId,
    Map<String, dynamic> data,
    MessageProtocol protocol,
  ) async {
    try {
      // Déchiffrer le message
      final decrypted = await _crypto.decryptMessage(data['encrypted']);
      
      String? localPath;
      int? duration;
      int? fileSize;

      if (protocol == MessageProtocol.audio) {
        // Sauvegarder l'audio déchiffré
        final audioBytes = base64.decode(decrypted);
        final dir = await getApplicationDocumentsDirectory();
        localPath = '${dir.path}/audio/${data['messageId']}.m4a';
        await File(localPath).create(recursive: true);
        await File(localPath).writeAsBytes(audioBytes);
        duration = data['duration'];
        fileSize = audioBytes.length;
      }

      final message = Message(
        messageId: data['messageId'],
        conversationId: contactDeviceId,
        encryptedContent: protocol == MessageProtocol.text ? decrypted : '',
        typeIndex: protocol == MessageProtocol.text 
            ? MessageType.text.index 
            : MessageType.audio.index,
        statusIndex: MessageStatus.delivered.index,
        isSentByMe: false,
        timestamp: DateTime.parse(data['timestamp']),
        localMediaPath: localPath,
        audioDuration: duration,
        fileSize: fileSize,
      );

      await _database.saveMessage(message);
      _messageController.add(message);

      // Envoyer un reçu de livraison
      await _webrtc.sendMessage(contactDeviceId, {
        'protocol': MessageProtocol.deliveryReceipt.name,
        'messageId': message.messageId,
      });
    } catch (e) {
      print('Erreur traitement message: $e');
    }
  }

  Future<void> _handleDeliveryReceipt(String messageId) async {
    final message = await _database.getMessageById(messageId);
    if (message != null && message.status.index < MessageStatus.delivered.index) {
      message.status = MessageStatus.delivered;
      await _database.updateMessage(message);
    }
  }

  Future<void> _handleReadReceipt(String messageId) async {
    final message = await _database.getMessageById(messageId);
    if (message != null) {
      message.status = MessageStatus.read;
      await _database.updateMessage(message);
    }
  }

  void _handleTypingIndicator(String contactDeviceId, bool isTyping) {
    _typingController.add({contactDeviceId: isTyping});

    // Auto-clear après 5 secondes
    _typingTimers[contactDeviceId]?.cancel();
    if (isTyping) {
      _typingTimers[contactDeviceId] = Timer(
        const Duration(seconds: 5),
        () => _typingController.add({contactDeviceId: false}),
      );
    }
  }

  // === Helpers ===

  Future<void> _sendViaWebRTC(String contactDeviceId, Map<String, dynamic> data) async {
    if (!_webrtc.isPeerConnected(contactDeviceId)) {
      // Tenter de se connecter
      await _webrtc.connectToPeer(contactDeviceId);
      
      // Attendre jusqu'à 5 secondes pour la connexion
      final completer = Completer<void>();
      Timer? timeout;
      StreamSubscription? subscription;

      subscription = _webrtc.onConnectionStateChange.listen((state) {
        if (state[contactDeviceId] == true && !completer.isCompleted) {
          timeout?.cancel();
          subscription?.cancel();
          completer.complete();
        }
      });

      timeout = Timer(const Duration(seconds: 5), () {
        if (!completer.isCompleted) {
          subscription?.cancel();
          completer.completeError('Timeout connexion WebRTC');
        }
      });

      await completer.future;
    }

    await _webrtc.sendMessage(contactDeviceId, data);
  }

  Future<void> dispose() async {
    await _messageController.close();
    await _typingController.close();
    for (final timer in _typingTimers.values) {
      timer?.cancel();
    }
  }
}


