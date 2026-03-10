import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'contact.dart';
import 'message.dart';
import 'conversation.dart';
import 'crypto_service.dart';
import 'database_service.dart';
import 'signaling_service.dart';
import 'webrtc_service.dart';
import 'messaging_service.dart';
import 'notification_service.dart';
import 'audio_recording_service.dart';
import 'qrcode_service.dart';

/// Provider principal de l'application
class AppProvider with ChangeNotifier {
  // Services
  late final CryptoService _crypto;
  late final DatabaseService _database;
  late SignalingService _signaling;
  late WebRTCService _webrtc;
  late MessagingService _messaging;
  late final NotificationService _notifications;
  late final AudioRecordingService _audioRecording;
  late QRCodeService _qrCode;

  // État
  String? _deviceId;
  String? _pseudo;
  bool _isInitialized = false;
  List<Contact> _contacts = [];
  List<Conversation> _conversations = [];
  final Map<String, bool> _onlineStatus = {};
  final Map<String, bool> _typingStatus = {};

  // Getters
  String? get deviceId => _deviceId;
  String? get pseudo => _pseudo;
  bool get isInitialized => _isInitialized;
  List<Contact> get contacts => _contacts;
  List<Conversation> get conversations => _conversations;

  bool isContactOnline(String deviceId) => _onlineStatus[deviceId] ?? false;
  bool isContactTyping(String deviceId) => _typingStatus[deviceId] ?? false;

  CryptoService get crypto => _crypto;
  DatabaseService get database => _database;
  MessagingService get messaging => _messaging;
  WebRTCService get webrtc => _webrtc;
  NotificationService get notifications => _notifications;
  AudioRecordingService get audioRecording => _audioRecording;
  QRCodeService get qrCode => _qrCode;

  AppProvider() {
    _crypto = CryptoService();
    _database = DatabaseService();
    _notifications = NotificationService();
    _audioRecording = AudioRecordingService();
  }

  /// Initialise l'application
  Future<void> initialize(String supabaseUrl, String supabaseAnonKey) async {
    if (_isInitialized) return;

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      await _database.initialize();
      await _notifications.initialize();
      await _loadOrCreateIdentity();

      _signaling = SignalingService(Supabase.instance.client, _deviceId!);
      await _signaling.initialize();

      _webrtc = WebRTCService(_signaling);
      _messaging = MessagingService(_webrtc, _crypto, _database);
      _qrCode = QRCodeService(_crypto, _deviceId!, _pseudo!);

      await _loadContacts();
      await _loadConversations();

      _setupListeners();
      await _connectToOnlineContacts();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur initialisation: $e');
      rethrow;
    }
  }

  Future<void> _loadOrCreateIdentity() async {
    final prefs = await SharedPreferences.getInstance();

    _deviceId = prefs.getString('device_id');
    _pseudo = prefs.getString('pseudo');

    if (_deviceId == null) {
      _deviceId = const Uuid().v4();
      await prefs.setString('device_id', _deviceId!);
    }

    if (_pseudo == null) {
      _pseudo = 'User_${_deviceId!.substring(0, 8)}';
      await prefs.setString('pseudo', _pseudo!);
    }

    final publicKeyPem = prefs.getString('public_key');
    final privateKeyPem = prefs.getString('private_key');

    if (publicKeyPem == null || privateKeyPem == null) {
      await _crypto.generateKeyPair();
      await prefs.setString('public_key', _crypto.exportPublicKey());
      await prefs.setString('private_key', _crypto.exportPrivateKey());
    } else {
      _crypto.loadKeyPair(publicKeyPem, privateKeyPem);
    }

    await _registerInSupabase();
  }

  Future<void> _registerInSupabase() async {
    final deviceModel = await _getDeviceModel();

    await Supabase.instance.client.from('users').upsert({
      'device_id': _deviceId,
      'pseudo': _pseudo,
      'model': deviceModel,
      'last_seen': DateTime.now().toIso8601String(),
    });
  }

  Future<String?> _getDeviceModel() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        return '${info.manufacturer} ${info.model}';
      } else if (Platform.isWindows) {
        final info = await deviceInfo.windowsInfo;
        return info.computerName;
      }
    } catch (e) {
      debugPrint('Erreur device info: $e');
    }
    return null;
  }

  Future<void> _loadContacts() async {
    _contacts = await _database.getAllContacts();
    notifyListeners();
  }

  Future<void> _loadConversations() async {
    _conversations = await _database.getAllConversations();
    notifyListeners();
  }

  void _setupListeners() {
    _messaging.onMessage.listen((message) async {
      await _loadConversations();

      final contact = await _database.getContact(message.conversationId);
      if (contact != null && !message.isSentByMe) {
        await _notifications.showMessageNotification(message, contact);
      }

      notifyListeners();
    });

    _messaging.onTyping.listen((status) {
      _typingStatus.addAll(status);

      status.forEach((deviceId, isTyping) async {
        await _database.updateConversationTyping(deviceId, isTyping);
        await _loadConversations();

        if (isTyping) {
          final contact = await _database.getContact(deviceId);
          if (contact != null) {
            await _notifications.showTypingNotification(contact);
          }
        } else {
          await _notifications.cancelTypingNotification(deviceId);
        }
      });

      notifyListeners();
    });

    _webrtc.onConnectionStateChange.listen((state) async {
      _onlineStatus.addAll(state);

      for (final entry in state.entries) {
        await _database.updateContactOnlineStatus(entry.key, entry.value);
      }

      await _loadContacts();
      notifyListeners();
    });
  }

  Future<void> _connectToOnlineContacts() async {
    for (final contact in _contacts) {
      try {
        await _webrtc.connectToPeer(contact.deviceId);
        _messaging.listenToContact(contact.deviceId);
      } catch (e) {
        debugPrint('Erreur connexion à ${contact.deviceId}: $e');
      }
    }
  }

  // === Actions utilisateur ===

  /// Ajoute un contact via QR Code
  Future<void> addContact(String qrCodeData) async {
    final qrData = _qrCode.parseScannedQRCode(qrCodeData);

    final existing = await _database.getContact(qrData.deviceId);
    if (existing != null) {
      throw Exception('Contact déjà ajouté');
    }

    final contact = qrData.toContact();

    // FIX : saveContact crée désormais aussi la Conversation dans DatabaseService.
    // On recharge ensuite contacts ET conversations pour que ConversationsScreen
    // affiche immédiatement le nouveau contact sans attendre un message.
    await _database.saveContact(contact);

    await _loadContacts();
    await _loadConversations(); // ← était absent avant

    // Connexion WebRTC en parallèle (ne bloque pas l'UI)
    _webrtc.connectToPeer(contact.deviceId).then((_) {
      _messaging.listenToContact(contact.deviceId);
    }).catchError((e) {
      debugPrint('Connexion WebRTC différée pour ${contact.deviceId}: $e');
    });

    notifyListeners();
  }

  /// Supprime un contact
  Future<void> deleteContact(String deviceId) async {
    await _webrtc.disconnectPeer(deviceId);
    await _database.deleteContact(deviceId);
    await _loadContacts();
    await _loadConversations();
    notifyListeners();
  }

  /// Envoie un message texte
  Future<void> sendTextMessage(String contactDeviceId, String text) async {
    await _messaging.sendTextMessage(contactDeviceId, text);
    await _loadConversations();
    notifyListeners();
  }

  /// Envoie un message audio
  Future<void> sendAudioMessage(
      String contactDeviceId,
      String audioPath,
      int duration,
      ) async {
    await _messaging.sendAudioMessage(contactDeviceId, audioPath, duration);
    await _loadConversations();
    notifyListeners();
  }

  /// Envoie un indicateur "en train d'écrire"
  Future<void> sendTyping(String contactDeviceId, bool isTyping) async {
    await _messaging.sendTypingIndicator(contactDeviceId, isTyping);
  }

  /// Marque une conversation comme lue
  Future<void> markConversationAsRead(String conversationId) async {
    await _database.markConversationAsRead(conversationId);
    await _notifications.cancelConversationNotifications(conversationId);
    await _loadConversations();
    notifyListeners();
  }

  /// Met à jour le pseudo de l'utilisateur
  Future<void> updatePseudo(String newPseudo) async {
    _pseudo = newPseudo;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pseudo', newPseudo);
    await _registerInSupabase();
    notifyListeners();
  }

  /// Récupère les messages d'une conversation
  Future<List<Message>> getConversationMessages(
      String conversationId,
      ) async {
    return await _database.getMessages(conversationId);
  }

  @override
  void dispose() {
    _signaling.dispose();
    _webrtc.dispose();
    _messaging.dispose();
    _notifications.dispose();
    _audioRecording.dispose();
    _database.close();
    super.dispose();
  }
}