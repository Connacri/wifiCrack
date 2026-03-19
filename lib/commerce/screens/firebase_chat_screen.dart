import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/firebase_chat_service.dart';

class FirebaseChatScreen extends StatefulWidget {
  final String peerId;
  final String peerPseudo;

  const FirebaseChatScreen({
    super.key,
    required this.peerId,
    required this.peerPseudo,
  });

  @override
  State<FirebaseChatScreen> createState() => _FirebaseChatScreenState();
}

class _FirebaseChatScreenState extends State<FirebaseChatScreen> {
  final FirebaseChatService _chatService = FirebaseChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _currentUserId == null) return;

    _controller.clear();
    await _chatService.sendMessage(
      fromId: _currentUserId!,
      toId: widget.peerId,
      content: text,
    );
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return const Scaffold(body: Center(child: Text('Not authenticated')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peerPseudo),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _chatService.getMessagesStream(
                  _currentUserId!,
                  widget.peerId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  if (!snapshot.hasData ||
                      snapshot.data?.snapshot.value == null) {
                    return const Center(child: Text('Aucun message.'));
                  }

                  final data = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>,
                  );
                  final messages = data.values
                      .map((v) => Map<String, dynamic>.from(v as Map))
                      .toList();
                  messages.sort(
                    (a, b) => (a['timestamp'] as int).compareTo(
                      b['timestamp'] as int,
                    ),
                  );

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['fromId'] == _currentUserId;
                      final timestamp = DateTime.fromMillisecondsSinceEpoch(
                        msg['timestamp'] as int,
                      );

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.orange[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(msg['content'] ?? ''),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('HH:mm').format(timestamp),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.orange),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
