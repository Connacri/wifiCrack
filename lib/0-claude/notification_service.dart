import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// FIX: 'hide Message' élimine le conflit entre notre message.dart
//      et flutter_local_notifications/src/platform_specifics/android/message.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:permission_handler/permission_handler.dart';
import 'message.dart';
import 'contact.dart';
import 'database_service.dart';

/// Handler pour les notifications en arrière-plan
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print('Message en arrière-plan: ${message.messageId}');
}

/// Service de notifications locales et push
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final DatabaseService _database = DatabaseService();

  String? _fcmToken;
  bool _isInitialized = false;

  final _notificationController =
  StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNotificationTap =>
      _notificationController.stream;

  /// Initialise les notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp();
    } catch (e) {
      // print('⚠️ NotificationService: Erreur Firebase.initializeApp: $e');
    }
    
    await _requestPermissions();
    await _initializeLocalNotifications();
    await _initializeFCM();

    _isInitialized = true;
  }

  Future<void> _requestPermissions() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final notificationStatus = await Permission.notification.request();
        if (!notificationStatus.isGranted) {
          // print('Permission notifications refusée');
        }

        final settings = await _fcm.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          // print('Permissions FCM accordées');
        }
      }
    } catch (e) {
      // print('⚠️ NotificationService: Erreur lors de la demande de permissions: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open',
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
      linux: linuxSettings,
    );

    try {
      // FIX: flutter_local_notifications ≥ 18 — initialize() utilise des
      //      named parameters obligatoires.
      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          _notificationController.add({
            'payload': details.payload,
            'actionId': details.actionId,
          });
        },
      );
    } catch (e) {
      // print('⚠️ NotificationService: Erreur lors de l\'initialisation locale: $e');
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // print('Notifications locales désactivées sur ce bureau pour éviter le crash.');
      } else {
        rethrow;
      }
    }

    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        'messages',
        'Messages',
        description: 'Notifications de messages',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  Future<void> _initializeFCM() async {
    try {
      if (Platform.isAndroid || Platform.isIOS || kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

        _fcmToken = await _fcm.getToken();

        // print('FCM Token: $_fcmToken');

        _fcm.onTokenRefresh.listen((token) {
          _fcmToken = token;
          // print('Nouveau FCM Token: $token');
        });

        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

        final initialMessage = await _fcm.getInitialMessage();
        if (initialMessage != null) {
          _handleMessageOpenedApp(initialMessage);
        }
      }
    } catch (e) {
      // print('⚠️ NotificationService: FCM non supporté ou erreur d\'initialisation: $e');
    }
  }

  /// Affiche une notification locale pour un nouveau message
  Future<void> showMessageNotification(
      Message message,
      Contact contact,
      ) async {
    final title = contact.pseudo;

    // FIX: variable initialisée avec une valeur par défaut pour satisfaire
    //      l'analyse de flux Dart (non-nullable definite assignment).
    String body = 'Nouveau message';
    switch (message.type) {
      case MessageType.text:
        body = 'Nouveau message';
        break;
      case MessageType.audio:
        body = '🎤 Message vocal';
        break;
      case MessageType.image:
        body = '🖼️ Image';
        break;
      case MessageType.file:
        body = '📎 Fichier';
        break;
    }

    const androidDetails = AndroidNotificationDetails(
      'messages',
      'Messages',
      channelDescription: 'Notifications de messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      styleInformation: BigTextStyleInformation(''),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'reply',
          'Répondre',
          showsUserInterface: true,
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(label: 'Réponse rapide'),
          ],
        ),
        AndroidNotificationAction('mark_read', 'Marquer comme lu'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // FIX: show() entièrement en named params dans flutter_local_notifications ≥ 18
    await _localNotifications.show(
      id: message.conversationId.hashCode,
      title: title,
      body: body,
      notificationDetails: details,
      payload: message.conversationId,
    );
  }

  /// Affiche une notification de typing
  Future<void> showTypingNotification(Contact contact) async {
    const androidDetails = AndroidNotificationDetails(
      'typing',
      'En train d\'écrire',
      channelDescription: 'Indicateur de frappe',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      onlyAlertOnce: true,
    );

    const details = NotificationDetails(android: androidDetails);

    // FIX: named params
    await _localNotifications.show(
      id: 'typing_${contact.deviceId}'.hashCode,
      title: contact.pseudo,
      body: 'est en train d\'écrire...',
      notificationDetails: details,
    );
  }

  /// Annule la notification de typing
  Future<void> cancelTypingNotification(String contactDeviceId) async {
    // FIX: cancel() en named param
    await _localNotifications.cancel(
      id: 'typing_$contactDeviceId'.hashCode,
    );
  }

  /// Annule toutes les notifications d'une conversation
  Future<void> cancelConversationNotifications(String conversationId) async {
    // FIX: cancel() en named param
    await _localNotifications.cancel(id: conversationId.hashCode);
  }

  Future<void> updateBadge(int count) async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.cancelAll();
  }

  // === Handlers FCM ===

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // print('Message FCM au premier plan: ${message.notification?.title}');

    final data = message.data;
    if (data['type'] == 'new_message') {
      final contactDeviceId = data['from'] as String?;
      if (contactDeviceId == null) return;

      final contact = await _database.getContact(contactDeviceId);

      if (contact != null) {
        // FIX: named params
        await _localNotifications.show(
          id: contactDeviceId.hashCode,
          title: contact.pseudo,
          body: 'Nouveau message',
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'messages',
              'Messages',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
          payload: contactDeviceId,
        );
      }
    }
  }

  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    // print('App ouverte depuis notification: ${message.messageId}');

    final data = message.data;
    if (data['type'] == 'new_message') {
      _notificationController.add({
        'action': 'open_conversation',
        'conversationId': data['from'],
      });
    }
  }

  Future<void> sendPushNotification(
      String toDeviceId,
      String title,
      String body,
      Map<String, dynamic> data,
      ) async {
    // print('Envoi notification push à $toDeviceId: $title');
    // TODO: Appeler la Supabase Edge Function
  }

  String? get fcmToken => _fcmToken;

  Future<void> dispose() async {
    await _notificationController.close();
  }
}