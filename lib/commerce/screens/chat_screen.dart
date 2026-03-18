import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({super.key, required this.otherUserId, required this.otherUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous";
  late String _chatId;

  @override
  void initState() {
    super.initState();
    // Créer un ID unique pour la conversation entre les deux users
    List<String> ids = [_currentUserId, widget.otherUserId];
    ids.sort();
    _chatId = ids.join("_");
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    _dbRef.child('chats/$_chatId/messages').push().set({
      'senderId': _currentUserId,
      'text': text,
      'timestamp': ServerValue.timestamp,
    });

    _msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _dbRef.child('chats/$_chatId/messages').orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> messages = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<dynamic> sortedMessages = messages.values.toList()
                    ..sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));

                  return ListView.builder(
                    reverse: true,
                    itemCount: sortedMessages.length,
                    itemBuilder: (context, index) {
                      var msg = sortedMessages[index];
                      bool isMe = msg['senderId'] == _currentUserId;
                      return _buildMessageBubble(msg['text'], isMe);
                    },
                  );
                }
                return const Center(child: Text("Commencez la discussion"));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(
                      hintText: "Votre message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isMe ? Colors.deepPurple : Colors.grey[300],
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
