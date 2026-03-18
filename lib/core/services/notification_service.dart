import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialise les notifications locales et les channels Android.
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // 1. initialize utilise le paramètre NOMMÉ 'settings'
    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("🔔 Notification cliquée: ${response.payload}");
      },
    );

    // 2. AndroidNotificationChannel utilise des paramètres POSITIONNELS (id, name)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', 
      'Notifications Importantes',
      description: 'Ce canal est utilisé pour les notifications critiques.',
      importance: Importance.max,
    );

    // 3. createNotificationChannel utilise un paramètre POSITIONNEL (channel)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Configurer Firebase Messaging pour afficher les notifs quand l'app est ouverte
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // 4. show utilise TOUS les paramètres NOMMÉS (id, title, body, notificationDetails)
        _notificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, // 5. channelId POSITIONNEL
              channel.name, // 6. channelName POSITIONNEL
              channelDescription: channel.description,
              icon: android.smallIcon,
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }

  /// Demande les permissions (iOS/Android 13+)
  static Future<void> requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
