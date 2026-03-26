import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'p2p_transfer_service.dart';

/// Service Expert de Gestion des Messages (Local & P2P).
/// Gère la sauvegarde SQLite et les notifications système.
class MessageService {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<Map<String, dynamic>> _localMessages = [];
  final _localMessageController = StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get localMessageStream => _localMessageController.stream;
  List<Map<String, dynamic>> get allMessages => List.unmodifiable(_localMessages);
  
  StreamSubscription<Map<String, dynamic>>? _p2pSub;
  final Set<String> _seenInbound = {}; // Anti-doublons

  MessageService() {
  }

  Future<void> initializeNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) => debugPrint("🔔 Notification: ${details.payload}"),
    );
  }

  /// Envoie un message via WebRTC P2P
  Future<void> sendP2PMessage(
    String targetUserId, 
    String myUserId,
    String content, 
    P2PTransferService p2pService, {
    String type = 'text',
    String? fileUrl,
    int? durationInSeconds,
  }) async {
    final messageData = {
      'user_id': myUserId,
      'target_id': targetUserId,
      'peer_id': targetUserId, // L'autre est la cible
      'content': content,
      'type': type,
      'file_url': fileUrl,
      'duration': durationInSeconds,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'status': 'pending',
      'is_admin': true,
      'is_read': 1, 
    };

    _localMessages.add(messageData);
    _localMessageController.add(_localMessages);

    try {
      await p2pService.sendJson(targetUserId, messageData);
      messageData['status'] = 'sent';
      _localMessageController.add(_localMessages);
    } catch (e) {
      debugPrint("⚠️ P2P Fail: $e");
    }
  }

  /// Réception d'un message depuis le tunnel WebRTC
  void receiveP2PMessage(Map<String, dynamic> message) {
    // Générer une clé unique pour éviter les doublons (signalisation répétée)
    final msgKey = '${message['user_id']}|${message['timestamp']}|${message['content'].hashCode}';
    if (!_seenInbound.add(msgKey)) return;

    message['peer_id'] = message['user_id']; // L'autre est l'expéditeur
    message['is_admin'] = false;
    message['is_read'] = 0; 
    
    _localMessages.add(message);
    _localMessageController.add(_localMessages);
    
    _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(Map<String, dynamic> message) async {
    await _localNotifications.show(
      id: message.hashCode,
      title: "Sigma: Message de ${message['user_id'].toString().substring(0,8)}",
      body: message['content']?.toString() ?? "Message reçu",
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('sigma_p2p', 'Messages P2P', importance: Importance.max),
      ),
    );
  }

  void bindP2PService(P2PTransferService p2pService) {
    _p2pSub?.cancel();
    _p2pSub = p2pService.messageStream.listen(receiveP2PMessage);
  }

  Stream<int> getUnreadCountStream(String peerId) async* {
    yield _localMessages.where((m) => 
      m['peer_id'] == peerId && (m['is_read'] == 0 || m['is_read'] == false)
    ).length;
    yield* localMessageStream.map((messages) => messages.where((m) => 
      m['peer_id'] == peerId && (m['is_read'] == 0 || m['is_read'] == false)
    ).length);
  }

  Future<void> markAsReadLocal(String peerId) async {
    bool changed = false;
    for (var m in _localMessages) {
      if (m['peer_id'] == peerId && (m['is_read'] == 0 || m['is_read'] == false)) {
        m['is_read'] = 1;
        changed = true;
      }
    }
    if (changed) _localMessageController.add(_localMessages);
  }

  Future<void> clearConversationWith(String peerId) async {
    _localMessages.removeWhere((m) => m['peer_id'] == peerId);
    _localMessageController.add(_localMessages);
  }

  Future<String?> uploadAudio(String userId, String filePath) async {
    try {
      final ref = _storage.ref().child('p2p_audio/$userId/${DateTime.now().millisecondsSinceEpoch}.m4a');
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) { return null; }
  }
}
