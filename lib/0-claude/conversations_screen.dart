import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'conversation.dart';
import 'contact.dart';
import 'app_provider.dart';
import 'chat_screen.dart';
import 'add_contact_screen.dart';
import '../l10n/app_localizations.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final conversations = provider.conversations;
    final contacts = provider.contacts;
    final l10n = AppLocalizations.of(context)!;

    // FIX BUG 2 : on construit un Map<deviceId, Contact> à partir de
    // provider.contacts (déjà en mémoire) pour éviter un FutureBuilder
    // par ListTile — ce qui causait des rebuilds non contrôlés et rendait
    // impossible l'affichage d'une conversation fraîchement créée.
    final contactMap = {for (final c in contacts) c.deviceId: c};

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.messagesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: l10n.addContactTooltip,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddContactScreen()),
            ),
          ),
        ],
      ),
      body: conversations.isEmpty
          ? _EmptyState(onAddContact: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddContactScreen()),
        );
      })
          : ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          final contact = contactMap[conversation.conversationId];

          // Contact introuvable en mémoire (ne devrait pas arriver
          // avec ensureConversationExists, mais défense en profondeur)
          if (contact == null) return const SizedBox.shrink();

          return _ConversationTile(
            conversation: conversation,
            contact: contact,
          );
        },
      ),
    );
  }
}

// ── Écran vide ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddContact;

  const _EmptyState({required this.onAddContact});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 72,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noConversations,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addContactToStart,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAddContact,
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(l10n.scanQrCodeTitle),
          ),
        ],
      ),
    );
  }
}

// ── Tuile de conversation ─────────────────────────────────────────────────────

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final Contact contact;

  const _ConversationTile({
    required this.conversation,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isOnline = provider.isContactOnline(contact.deviceId);
    final isTyping = provider.isContactTyping(contact.deviceId);
    final l10n = AppLocalizations.of(context)!;

    // Sous-titre : état de la conversation
    final String subtitle;
    final Color subtitleColor;
    final FontStyle subtitleStyle;

    if (isTyping) {
      subtitle = l10n.typingStatus;
      subtitleColor = Theme.of(context).colorScheme.primary;
      subtitleStyle = FontStyle.italic;
    } else if (conversation.lastMessagePreview != null) {
      final preview = conversation.lastMessagePreview!;
      subtitle = _getLocalizedPreview(context, preview);
      subtitleColor = Theme.of(context).colorScheme.outline;
      subtitleStyle = FontStyle.normal;
    } else {
      // FIX : conversation vide (contact fraîchement ajouté)
      subtitle = l10n.sayHello;
      subtitleColor = Theme.of(context).colorScheme.outlineVariant;
      subtitleStyle = FontStyle.italic;
    }

    return ListTile(
      leading: _Avatar(contact: contact, isOnline: isOnline),
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
              _formatTime(context, conversation.lastMessageTime!),
              style: TextStyle(
                fontSize: 12,
                color: conversation.unreadCount > 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: subtitleColor,
          fontStyle: subtitleStyle,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: conversation.unreadCount > 0
          ? _UnreadBadge(count: conversation.unreadCount)
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(contact: contact),
          ),
        );
      },
    );
  }

  String _getLocalizedPreview(BuildContext context, String preview) {
    final l10n = AppLocalizations.of(context)!;
    switch (preview) {
      case '[ENCRYPTED]':
        return l10n.encryptedMessage;
      case '[ENCRYPTED_ME]':
        return l10n.youEncryptedMessage;
      case '[AUDIO]':
        return l10n.vocalMessage;
      case '[AUDIO_ME]':
        return 'You: ${l10n.vocalMessage}';
      case '[IMAGE]':
        return l10n.imageMessage;
      case '[IMAGE_ME]':
        return 'You: ${l10n.imageMessage}';
      case '[FILE]':
        return l10n.fileMessage;
      case '[FILE_ME]':
        return 'You: ${l10n.fileMessage}';
      default:
        return preview;
    }
  }

  String _formatTime(BuildContext context, DateTime time) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      final locale = Localizations.localeOf(context).toString();
      return DateFormat('EEEE', locale).format(time);
    } else {
      return DateFormat('dd/MM/yy').format(time);
    }
  }
}

// ── Composants réutilisables ──────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final Contact contact;
  final bool isOnline;

  const _Avatar({required this.contact, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            contact.pseudo[0].toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
