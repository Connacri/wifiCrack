import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firebase_chat_service.dart';
import 'firebase_chat_screen.dart';

class FirebaseUserListScreen extends StatelessWidget {
  final FirebaseChatService _chatService = FirebaseChatService();

  FirebaseUserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Messenger (Realtime)'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun utilisateur Firestore trouvé.'));
          }

          final users = snapshot.data!.where((u) => u['id'] != currentUser?.uid).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final pseudo = user['pseudo'] ?? user['email'] ?? 'Inconnu';
              final userId = user['id'];

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(pseudo),
                subtitle: Text(userId),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FirebaseChatScreen(
                        peerId: userId,
                        peerPseudo: pseudo,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
