import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import 'contact.dart';
import 'app_provider.dart';
import 'chat_screen.dart';
import 'qr_generator_screen.dart';
import 'qr_scanner_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.myContacts, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              user.pseudo ?? user.deviceId.substring(0, 8),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.myQrCodeTooltip,
            icon: const Icon(Icons.qr_code),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QRGeneratorScreen(user: user),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.scanFriendTooltip,
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final added = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => QRScannerScreen(
                    myDeviceId: user.deviceId,
                    contactService: provider.contactService,
                  ),
                ),
              );
              if (added == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.friendAddedSuccess),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit_pseudo') _editPseudo(context, provider);
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit_pseudo', child: Text(l10n.editPseudoMenu)),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<M2CContact>>(
        stream: provider.contactService.watchContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final contacts = snapshot.data ?? [];

          if (contacts.isEmpty) {
            return _EmptyContactsPlaceholder(
              onScanPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QRScannerScreen(
                    myDeviceId: user.deviceId,
                    contactService: provider.contactService,
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: contacts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return _ContactTile(
                contact: contact,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      myDeviceId: user.deviceId,
                      friendDeviceId: contact.deviceId,
                      friendPseudo: contact.pseudo,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _editPseudo(BuildContext context, AppProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final controller =
        TextEditingController(text: provider.currentUser.pseudo);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.myPseudoTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.enterPseudoHint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(l10n.save)),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      provider.updatePseudo(result);
    }
  }
}

class _ContactTile extends StatelessWidget {
  final M2CContact contact;
  final VoidCallback onTap;

  const _ContactTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasUnread = contact.unreadCount > 0;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          contact.displayName[0].toUpperCase(),
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
      ),
      title: Text(
        contact.displayName,
        style: TextStyle(fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal),
      ),
      subtitle: contact.lastMessagePreview != null
          ? Text(
              contact.lastMessagePreview!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: hasUnread
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            )
          : Text(
              '${l10n.addedOn} ${_formatDate(contact.addedAt)}',
              style: theme.textTheme.bodySmall,
            ),
      trailing: hasUnread
          ? Badge(
              label: Text(contact.unreadCount.toString()),
              child: const SizedBox.shrink(),
            )
          : null,
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

class _EmptyContactsPlaceholder extends StatelessWidget {
  final VoidCallback onScanPressed;

  const _EmptyContactsPlaceholder({required this.onScanPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80,
              color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(l10n.noContacts, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l10n.scanFriendToStart),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onScanPressed,
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(l10n.scanFriendButton),
          ),
        ],
      ),
    );
  }
}
