import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const windowsSettings = WindowsInitializationSettings(
      appName: 'Mistral2laude P2P',
      appUserModelId: 'com.mistral2laude.p2p',
      guid: 'd8b4e0a2-3f1c-4e9b-b7a5-6c2d1e8f0a4b',
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      windows: windowsSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotifTap,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    _isInitialized = true;
    debugPrint('[Notif] Service initialisé');
  }

  Future<void> showMessageNotification({
    required String senderPseudo,
    required String messagePreview,
    String? conversationId,
  }) async {
    if (!_isInitialized) return;

    final notifId = conversationId.hashCode.abs() % 100000;

    const androidDetails = AndroidNotificationDetails(
      'ch_messages',
      'Messages',
      channelDescription: 'Notifications de nouveaux messages',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      groupKey: 'mistral_messages',
    );

    const windowsDetails = WindowsNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      windows: windowsDetails,
    );

    await _plugin.show(
      id: notifId,
      title: senderPseudo,
      body: messagePreview.length > 60
          ? '${messagePreview.substring(0, 57)}...'
          : messagePreview,
      notificationDetails: details,
      payload: conversationId,
    );
  }

  Future<void> cancelAll() async => _plugin.cancelAll();

  void _onNotifTap(NotificationResponse response) {
    debugPrint('[Notif] Tap sur conversation: ${response.payload}');
  }
}
