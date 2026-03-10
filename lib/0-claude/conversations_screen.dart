import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'conversation.dart';
import 'contact.dart';
import 'app_provider.dart';
import 'chat_screen.dart';
import 'add_contact_screen.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddContactScreen()),
            ),
          ),
        ],
      ),
      body: provider.conversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune conversation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez un contact pour commencer',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: provider.conversations.length,
              itemBuilder: (context, index) {
                final conversation = provider.conversations[index];
                return FutureBuilder<Contact?>(
                  future: provider.database.getContact(conversation.conversationId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final contact = snapshot.data!;
                    return _ConversationTile(conversation: conversation, contact: contact);
                  },
                );
              },
            ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final Contact contact;

  const _ConversationTile({required this.conversation, required this.contact});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isOnline = provider.isContactOnline(contact.deviceId);
    final isTyping = provider.isContactTyping(contact.deviceId);

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              contact.pseudo[0].toUpperCase(),
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              contact.pseudo,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (conversation.lastMessageTime != null)
            Text(
              _formatTime(conversation.lastMessageTime!),
              style: TextStyle(
                fontSize: 12,
                color: conversation.unreadCount > 0 ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
            ),
        ],
      ),
      subtitle: Text(
        isTyping
            ? 'en train d\'écrire...'
            : conversation.lastMessagePreview ?? '',
        style: TextStyle(
          color: isTyping ? Colors.green : Colors.grey,
          fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: conversation.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatScreen(contact: contact)),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', 'fr_FR').format(time);
    } else {
      return DateFormat('dd/MM/yy').format(time);
    }
  }
}
