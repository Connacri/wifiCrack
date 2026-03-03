import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Service de messagerie Sigma (Style GAFAM : Robuste, scalable, notifications incluses).
class FirebaseMessengerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Collection principale des messages
  CollectionReference<Map<String, dynamic>> get _messages =>
      _firestore.collection('sigma_messages');
  
  // Collection des tokens pour les notifications
  CollectionReference get _userTokens => _firestore.collection('user_fcm_tokens');

  /// Initialiser les notifications pour l'utilisateur actuel
  Future<void> initializeNotifications(String userId) async {
    try {
      // 1. Demander la permission (iOS / Android 13+)
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // 2. Récupérer le token FCM
        String? token = await _fcm.getToken();
        if (token != null) {
          await _saveTokenToDatabase(userId, token);
        }
      }

      // 3. Écouter le rafraîchissement du token
      _fcm.onTokenRefresh.listen((newToken) {
        _saveTokenToDatabase(userId, newToken);
      });

      // 4. Gérer les messages en arrière-plan et quand l'app est ouverte
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint("🔔 Notification reçue en premier plan: ${message.notification?.title}");
      });
    } catch (e) {
      debugPrint("❌ FCM Error: $e");
    }
  }

  /// Sauvegarder le token dans Firestore pour permettre à l'admin d'envoyer des notifications
  Future<void> _saveTokenToDatabase(String userId, String token) async {
    await _userTokens.doc(userId).set({
      'fcm_token': token,
      'last_updated': FieldValue.serverTimestamp(),
      'platform': kIsWeb ? 'web' : 'mobile',
    }, SetOptions(merge: true));
  }

  /// Envoyer un message avec support Emojis.
  Future<bool> sendMessage(String userId, String content, {
    bool isAdmin = true,
    String? type = 'text',
  }) async {
    try {
      final now = Timestamp.now();
      await _messages.add({
        'user_id': userId,
        'content': content,
        'is_admin': isAdmin,
        'type': type,
        'timestamp': now,
        'server_timestamp': FieldValue.serverTimestamp(),
        'is_read': false,
      });
      return true;
    } catch (e) {
      debugPrint("❌ Messenger Error: $e");
      return false;
    }
  }

  /// Écouter les messages d'une Room (userId) en temps réel.
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String userId) {
    return _messages
        .where('user_id', isEqualTo: userId)
        .snapshots();
  }

  /// Marquer les messages comme lus.
  Future<void> markAsRead(String userId, {required bool isAdmin}) async {
    try {
      final snapshot = await _messages
          .where('user_id', isEqualTo: userId)
          .where('is_read', isEqualTo: false)
          .where('is_admin', isEqualTo: !isAdmin)
          .get();

      if (snapshot.docs.isEmpty) return;

      final WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'is_read': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint("⚠️ Messenger: Erreur markAsRead: $e");
    }
  }

  /// Stream du compteur de messages non lus.
  Stream<int> getUnreadCountStream(String userId, {required bool isAdmin}) {
    return _messages
        .where('user_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .where('is_admin', isEqualTo: !isAdmin)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
