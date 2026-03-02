import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/sources/firebase_messenger_service.dart';
import '../../data/sources/user_data_service.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({super.key});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseMessengerService _messenger = FirebaseMessengerService();

  void _send(String userId) {
    if (_controller.text.trim().isEmpty) return;
    _messenger.sendMessage(userId, _controller.text.trim(), isAdmin: false);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserDataService>().deviceId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Sigma'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messenger.getMessagesStream(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text("Besoin d'aide ? Envoyez-nous un message."),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index].data() as Map<String, dynamic>;
                    final bool isAdmin = msg['is_admin'] ?? false;
                    final timestamp = msg['timestamp'] as Timestamp?;

                    return Align(
                      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isAdmin ? Colors.grey[200] : Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: Radius.circular(isAdmin ? 0 : 15),
                            bottomRight: Radius.circular(isAdmin ? 15 : 0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            Text(msg['content'] ?? "", style: const TextStyle(fontSize: 16)),
                            if (timestamp != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  DateFormat('HH:mm').format(timestamp.toDate()),
                                  style: const TextStyle(fontSize: 10, color: Colors.black45),
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
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 10,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Écrire au support...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: () => _send(userId),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
