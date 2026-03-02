import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../data/sources/firebase_messenger_service.dart';
import '../../data/sources/supabase_service.dart';

/// Screen "Messenger Sigma" : Affiche tous les utilisateurs (cibles) 
/// et permet d'échanger avec eux en temps réel via Firebase.
class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final SupabaseService _supabase = SupabaseService();
  final FirebaseMessengerService _messenger = FirebaseMessengerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Messenger'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _supabase.fetchUniqueUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun utilisateur trouvé."));
          }

          final users = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              final String userId = "User_${user['id']}";
              
              return _UserChatTile(
                userId: userId,
                messenger: _messenger,
                onTap: () => _openChat(userId),
              );
            },
          );
        },
      ),
    );
  }

  void _openChat(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedChatScreen(userId: userId),
      ),
    );
  }
}

class _UserChatTile extends StatelessWidget {
  final String userId;
  final FirebaseMessengerService messenger;
  final VoidCallback onTap;

  const _UserChatTile({
    required this.userId, 
    required this.messenger, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: messenger.getUnreadCountStream(userId, isAdmin: false),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data ?? 0;
        
        return ListTile(
          onTap: onTap,
          leading: const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(userId, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("Appuyez pour discuter..."),
          trailing: unreadCount > 0
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text(unreadCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                )
              : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        );
      },
    );
  }
}

/// Écran de chat détaillé pour un utilisateur spécifique
class DetailedChatScreen extends StatefulWidget {
  final String userId;
  const DetailedChatScreen({super.key, required this.userId});

  @override
  State<DetailedChatScreen> createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseMessengerService _messenger = FirebaseMessengerService();

  @override
  void initState() {
    super.initState();
    // On marque comme lu en entrant dans le chat
    _messenger.markAsRead(widget.userId, isAdmin: false);
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    _messenger.sendMessage(widget.userId, _controller.text.trim(), isAdmin: false);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userId),
        backgroundColor: Colors.orange[100],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messenger.getMessagesStream(widget.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final docs = snapshot.data!.docs;
                // Marquer comme lu à chaque réception de nouveau message pendant qu'on est sur l'écran
                _messenger.markAsRead(widget.userId, isAdmin: false);

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index].data() as Map<String, dynamic>;
                    final bool isAdmin = msg['is_admin'] ?? false;
                    final bool isRead = msg['is_read'] ?? false;
                    final timestamp = msg['timestamp'] as Timestamp?;

                    return Align(
                      alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isAdmin ? Colors.orange[200] : Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: Radius.circular(isAdmin ? 15 : 0),
                            bottomRight: Radius.circular(isAdmin ? 0 : 15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(msg['content'] ?? "", style: const TextStyle(fontSize: 16)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (timestamp != null)
                                  Text(
                                    DateFormat('HH:mm').format(timestamp.toDate()),
                                    style: const TextStyle(fontSize: 10, color: Colors.black45),
                                  ),
                                if (isAdmin) ...[
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.done_all, 
                                    size: 14, 
                                    color: isRead ? Colors.blue : Colors.grey
                                  ), // Notification de reçu/lu
                                ],
                              ],
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
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom > 0 
              ? 10 
              : 8,
          left: 16,
          right: 16,
          top: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Message Sigma...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, 
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              onPressed: _send,
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
