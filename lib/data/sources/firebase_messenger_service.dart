import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service de messagerie Sigma expert. 
/// Gère les alertes FCM avec haute priorité (Son, Vibration, Popup).
class FirebaseMessengerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  CollectionReference<Map<String, dynamic>> get _messages =>
      _firestore.collection('sigma_messages');
  
  CollectionReference get _userTokens => _firestore.collection('user_fcm_tokens');

  Future<void> initializeNotifications(String userId) async {
    try {
      // 1. Demander les permissions système (Crucial pour Android 13+)
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await _fcm.getToken();
        if (token != null) await _saveTokenToDatabase(userId, token);
      }

      // 2. Initialisation des notifications locales
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');
      
      const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        settings: initializationSettings, // Paramètre nommé requis
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint("🚀 Notification cliquée : ${details.payload}");
        },
      );

      // Création du canal Android pour les alertes
      if (Platform.isAndroid) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'sigma_alerts_channel',
          'Alertes Sigma',
          description: 'Notifications prioritaires pour les messages Sigma',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );

        await _localNotifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }

      // 3. Écouter les messages au premier plan
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(message);
      });

      // 4. Background & Cold Start
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("📱 App ouverte depuis le background !");
      });

      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        debugPrint("❄️ Cold Start détecté.");
      }

    } catch (e) {
      debugPrint("❌ FCM Initialization Error: $e");
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'sigma_alerts_channel',
      'Alertes Sigma',
      channelDescription: 'Notifications prioritaires pour les messages Sigma',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
      styleInformation: BigTextStyleInformation(message.notification?.body ?? ""),
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      id: message.hashCode, // Paramètre nommé requis
      title: message.notification?.title ?? "Nouveau message Sigma",
      body: message.notification?.body ?? "Une nouvelle instruction est disponible.",
      notificationDetails: platformChannelSpecifics,
      payload: message.data['user_id']?.toString(),
    );
  }

  Future<void> _saveTokenToDatabase(String userId, String token) async {
    try {
      await _userTokens.doc(userId).set({
        'fcm_token': token,
        'last_updated': FieldValue.serverTimestamp(),
        'platform': Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'other'),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ Error saving FCM token: $e");
    }
  }

  Future<bool> sendMessage(String userId, String content, {
    bool isAdmin = true,
    String? type = 'text',
    String? fileUrl,
    int? durationInSeconds,
  }) async {
    try {
      await _messages.add({
        'user_id': userId,
        'content': content,
        'is_admin': isAdmin,
        'type': type,
        'file_url': fileUrl,
        'duration': durationInSeconds,
        'timestamp': FieldValue.serverTimestamp(),
        'is_read': false,
      });
      return true;
    } catch (e) {
      debugPrint("❌ Error sending message: $e");
      return false;
    }
  }

  Future<String?> uploadAudio(String userId, String filePath) async {
    try {
      final fileName = "vocal_${DateTime.now().millisecondsSinceEpoch}.m4a";
      final ref = _storage.ref().child('sigma_messenger/audio/$userId/$fileName');
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("❌ Audio Upload Error: $e");
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String userId) {
    return _messages
        .where('user_id', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> markAsRead(String userId, {required bool isAdmin}) async {
    try {
      final snapshot = await _messages
          .where('user_id', isEqualTo: userId)
          .where('is_read', isEqualTo: false)
          .where('is_admin', isEqualTo: !isAdmin)
          .get();

      if (snapshot.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'is_read': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint("⚠️ Messenger: Erreur markAsRead: $e");
    }
  }

  Stream<int> getUnreadCountStream(String userId, {required bool isAdmin}) {
    return _messages
        .where('user_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .where('is_admin', isEqualTo: !isAdmin)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
