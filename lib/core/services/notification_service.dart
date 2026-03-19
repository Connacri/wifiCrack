import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialise les notifications locales pour TOUTES les plateformes, y compris Windows.
  static Future<void> initialize() async {
    // 1. Paramètres Android
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // 2. Paramètres iOS / macOS (Darwin)
    const DarwinInitializationSettings initializationSettingsDarwin = 
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 3. Paramètres Linux
    const LinuxInitializationSettings initializationSettingsLinux = 
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    // 4. Paramètres Windows (OBLIGATOIRE sur Windows v21.x+)
    // Ces identifiants sont nécessaires pour que Windows affiche les notifications
    const WindowsInitializationSettings initializationSettingsWindows = 
        WindowsInitializationSettings(
      appName: 'WiFi Fiber Hack', // Nom de votre app
      appUserModelId: 'com.comwificrack.app', // ID unique
      guid: '77602667-6666-4666-8666-666666666666', // Un GUID unique au format string
    );

    // 5. Initialisation globale
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
      windows: initializationSettingsWindows, // AJOUT CRITIQUE ICI
    );

    // Initialisation
    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("🔔 Notification cliquée: ${response.payload}");
      },
    );

    // Configuration spécifique à Android (Channels)
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', 
        'Notifications Importantes',
        description: 'Ce canal est utilisé pour les notifications critiques.',
        importance: Importance.max,
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Écoute des messages FCM en premier plan
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          _notificationsPlugin.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id, 
                channel.name,
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
  }

  /// Demande les permissions (Uniquement sur Mobile)
  static Future<void> requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
}
