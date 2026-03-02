import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessengerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection principale des messages
  CollectionReference get _messages => _firestore.collection('sigma_messages');

  /// Envoyer un message (Admin ou User)
  Future<void> sendMessage(String userId, String content, {bool isAdmin = true}) async {
    try {
      await _messages.add({
        'user_id': userId,
        'content': content,
        'is_admin': isAdmin,
        'timestamp': FieldValue.serverTimestamp(),
        'is_read': false, // Pour la notification de reçu
      });
    } catch (e) {
      debugPrint("⚠️ FirebaseMessenger: Erreur d'envoi: $e");
    }
  }

  /// Écouter les messages d'un utilisateur spécifique en temps réel
  Stream<QuerySnapshot> getMessagesStream(String userId) {
    return _messages
        .where('user_id', isEqualTo: userId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Marquer les messages comme lus
  Future<void> markAsRead(String userId, {required bool isAdmin}) async {
    final snapshot = await _messages
        .where('user_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .where('is_admin', isEqualTo: !isAdmin) // On marque comme lus les messages de l'AUTRE
        .get();

    final WriteBatch batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'is_read': true});
    }
    await batch.commit();
  }

  /// Écouter le nombre de messages non lus
  Stream<int> getUnreadCountStream(String userId, {required bool isAdmin}) {
    return _messages
        .where('user_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .where('is_admin', isEqualTo: !isAdmin)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Récupérer la liste des derniers messages pour le dashboard admin
  Stream<QuerySnapshot> getAllRecentChats() {
    return _messages
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }
}
