import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'p2p_transfer_service.dart';

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
        
        // S'abonner au canal global pour recevoir les notifications de groupe
        await _fcm.subscribeToTopic('all_users');
        debugPrint("📢 Abonné au canal global 'all_users'");
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

  // Simulation de persistance locale (à remplacer par SQLite/Hive)
  final List<Map<String, dynamic>> _localMessages = [];
  
  // Stream local pour l'UI
  final _localMessageController = StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get localMessageStream => _localMessageController.stream;

  /// Envoie un message en mode P2P strict avec persistance locale et signalisation de réveil.
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
      'user_id': myUserId, // Expéditeur (Moi)
      'target_id': targetUserId,
      'content': content,
      'type': type,
      'file_url': fileUrl,
      'duration': durationInSeconds,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'status': 'pending', // pending, sent, delivered
      'is_admin': true, // Pour compatibilité UI existante
    };

    // 1. Sauvegarde Locale (Outbox)
    _localMessages.add(messageData);
    _localMessageController.add(_localMessages); // Update UI

    try {
      // 2. Tentative d'envoi P2P
      await p2pService.sendJson(targetUserId, messageData);
      
      // Si on arrive ici sans erreur, on considère envoyé (optimiste, le vrai ACK viendrait du P2P)
      messageData['status'] = 'sent';
      _localMessageController.add(_localMessages);
      
    } catch (e) {
      debugPrint("⚠️ P2P Fail (Normal si hors ligne): $e");
    }

    // 3. Signal de Réveil (Notification via Firestore sans contenu)
    // On écrit juste un "ping" dans une collection spéciale que l'autre écoute
    try {
      await _firestore.collection('p2p_signals').add({
        'to': targetUserId,
        'from': myUserId,
        'type': 'wake_up',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("❌ Signal Error: $e");
    }
  }

  /// Méthode pour recevoir un message P2P (appelée depuis l'écouteur du P2PService)
  void receiveP2PMessage(Map<String, dynamic> message) {
    message['is_admin'] = false; // C'est un message reçu
    _localMessages.add(message);
    _localMessageController.add(_localMessages);
  }

  // L'ancienne méthode reste pour compatibilité si besoin, mais on l'ignore pour le nouveau flux
  Future<bool> sendMessage(String userId, String content, {
    bool isAdmin = true,
    String? type = 'text',
    String? fileUrl,
    int? durationInSeconds,
  }) async {
    // OBSOLÈTE : Ne plus utiliser Firestore pour le stockage
    return false; 
  }

  Future<String?> uploadAudio(String userId, String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint("❌ Audio Upload Error: Le fichier n'existe pas au chemin $filePath");
        return null;
      }

      // Lecture en bytes pour éviter les conflits d'accès au fichier
      final Uint8List bytes = await file.readAsBytes();
      
      final fileName = "vocal_${DateTime.now().millisecondsSinceEpoch}.m4a";
      final ref = _storage.ref().child('sigma_messenger/audio/$userId/$fileName');
      
      // Utilisation de putData au lieu de putFile
      final uploadTask = await ref.putData(
        bytes,
        SettableMetadata(contentType: 'audio/m4a'),
      );
      
      final url = await uploadTask.ref.getDownloadURL();
      debugPrint("✅ Vocal uploadé avec succès: $url");
      
      // Nettoyage du fichier temporaire après upload réussi
      try { await file.delete(); } catch (_) {}
      
      return url;
    } catch (e) {
      debugPrint("❌ Audio Upload Error Details: $e");
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String userId) {
    // On retire le orderBy serveur pour éviter l'obligation d'index composite.
    // Le tri est géré de manière plus flexible dans l'UI via _sortedDocs.
    return _messages
        .where('user_id', isEqualTo: userId)
        .limit(500)
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

      // Firestore batch: 500 opérations max.
      for (int i = 0; i < snapshot.docs.length; i += 450) {
        final batch = _firestore.batch();
        final chunk = snapshot.docs.skip(i).take(450);
        for (final doc in chunk) {
          batch.update(doc.reference, {'is_read': true});
        }
        await batch.commit();
      }
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
