import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class FirebaseChatService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch users from Firestore
  Stream<List<Map<String, dynamic>>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Get messages between two users from Realtime Database
  Stream<DatabaseEvent> getMessagesStream(String currentUserId, String peerId) {
    final chatId = _getChatId(currentUserId, peerId);
    return _db.ref().child('chats').child(chatId).child('messages').orderByChild('timestamp').onValue;
  }

  /// Send a message using Realtime Database
  Future<void> sendMessage({
    required String fromId,
    required String toId,
    required String content,
  }) async {
    final chatId = _getChatId(fromId, toId);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final messageData = {
      'fromId': fromId,
      'toId': toId,
      'content': content,
      'timestamp': timestamp,
    };

    final newMsgRef = _db.ref().child('chats').child(chatId).child('messages').push();
    await newMsgRef.set(messageData);

    // Update last message metadata
    await _db.ref().child('chats').child(chatId).child('metadata').set({
      'lastMessage': content,
      'lastTimestamp': timestamp,
    });
  }

  String _getChatId(String id1, String id2) {
    final list = [id1, id2];
    list.sort();
    return list.join('_');
  }
}
