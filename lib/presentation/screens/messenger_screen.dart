import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animated_emoji/animated_emoji.dart';

import '../../data/sources/firebase_messenger_service.dart';
import '../../data/sources/p2p_transfer_service.dart';
import '../../data/sources/supabase_service.dart';
import '../../data/sources/user_data_service.dart';
import '../widgets/messenger_audio_widgets.dart';

/// Admin dashboard listing users from Supabase and messages from Firestore.
class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final SupabaseService _supabase = SupabaseService();
  late FirebaseMessengerService _messenger;
  late Future<List<Map<String, dynamic>>> _usersFuture;
  bool _messengerInitialized = false;

  @override
  void initState() {
    super.initState();
    _usersFuture = _supabase.fetchUniqueUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messengerInitialized) return;
    _messenger = context.read<FirebaseMessengerService>();
    _messengerInitialized = true;
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = _supabase.fetchUniqueUsers();
    });
  }

  Future<void> _editPseudo() async {
    final userData = context.read<UserDataService>();
    final currentPseudo = userData.getPseudo();
    final controller = TextEditingController(text: currentPseudo);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier mon Pseudo"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Nouveau Pseudo"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          FilledButton(
            onPressed: () async {
              final newPseudo = controller.text.trim();
              if (newPseudo.isNotEmpty && newPseudo != currentPseudo) {
                final success = await userData.updatePseudo(newPseudo);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success 
                        ? "Pseudo mis à jour !" 
                        : "Pseudo indisponible ou erreur."),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                  if (success) _refreshUsers();
                }
              }
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<UserDataService>().deviceId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Messenger Dashboard'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Changer mon pseudo",
            onPressed: _editPseudo,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshUsers,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun utilisateur trouve.'));
          }

          final users = snapshot.data!
              .where((u) => u['device_id'] != currentUserId)
              .toList();

          return RefreshIndicator(
            onRefresh: () async => _refreshUsers(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: users.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = users[index];
                final deviceId = user['device_id']?.toString() ?? '';
                if (deviceId.isEmpty) return const SizedBox.shrink();
                final pseudo =
                    user['pseudo']?.toString() ?? deviceId.substring(0, 8);
                final model = user['model']?.toString() ?? 'Inconnu';

                return _UserChatTile(
                  userId: deviceId,
                  displayTitle: pseudo,
                  subtitle: model,
                  messenger: _messenger,
                  onTap: () => _openChat(deviceId, pseudo),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _openChat(String deviceId, String pseudo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailedChatScreen(userId: deviceId, pseudo: pseudo),
      ),
    );
  }
}

class _UserChatTile extends StatelessWidget {
  final String userId;
  final String displayTitle;
  final String subtitle;
  final FirebaseMessengerService messenger;
  final VoidCallback onTap;

  const _UserChatTile({
    required this.userId,
    required this.displayTitle,
    required this.subtitle,
    required this.messenger,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: messenger.getUnreadCountStream(userId, isAdmin: true),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data ?? 0;

        return ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: Colors.orange[unreadCount > 0 ? 800 : 400],
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            displayTitle,
            style: TextStyle(
              fontWeight:
                  unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: unreadCount > 0
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        );
      },
    );
  }
}

class DetailedChatScreen extends StatefulWidget {
  final String userId;
  final String pseudo;

  const DetailedChatScreen({
    super.key,
    required this.userId,
    required this.pseudo,
  });

  @override
  State<DetailedChatScreen> createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late FirebaseMessengerService _messenger;
  late P2PTransferService _p2pService;
  late StreamSubscription _p2pSubscription;
  bool _servicesReady = false;

  bool _isSending = false;
  bool _hasTypedText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_servicesReady) return;
    _messenger = context.read<FirebaseMessengerService>();
    _p2pService = context.read<P2PTransferService>();
    
    _p2pSubscription = _p2pService.messageStream.listen((data) {
      if (data['user_id'] == widget.userId) { 
        _messenger.receiveP2PMessage(data);
      }
    });

    _servicesReady = true;
  }

  @override
  void dispose() {
    _p2pSubscription.cancel();
    _controller.removeListener(_onInputChanged);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasTypedText && mounted) {
      setState(() => _hasTypedText = hasText);
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;
    final target = _scrollController.position.maxScrollExtent;
    if (animated) {
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(target);
    }
  }

  Future<void> _send({
    String? content,
    String type = 'text',
    String? fileUrl,
    int? duration,
  }) async {
    final msg = content ?? _controller.text.trim();
    if ((msg.isEmpty && fileUrl == null && type != 'audio') || _isSending) {
      return;
    }

    setState(() => _isSending = true);
    
    await _messenger.sendP2PMessage(
      widget.userId,
      context.read<UserDataService>().deviceId, 
      msg.isEmpty ? (type == 'audio' ? 'Vocal Sigma' : 'Message') : msg,
      _p2pService,
      type: type,
      fileUrl: fileUrl,
      durationInSeconds: duration,
    );

    if (!mounted) return;
    setState(() => _isSending = false);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _handleAudio(String path, Duration duration) async {
    await _p2pService.sendVocalP2P(widget.userId, path);
    await _send(
      type: 'audio', 
      fileUrl: 'p2p:${path.split(RegExp(r'[\\/ ]')).last}', 
      duration: duration.inSeconds
    );
  }

  void _showAddCoinsDialog() {
    final supabase = context.read<SupabaseService>();
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Coins pour ${widget.pseudo}'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Nombre de coins a ajouter',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              final amount = int.tryParse(ctrl.text) ?? 0;
              if (amount <= 0) return;

              await supabase.addCoins(widget.userId, amount);
              if (!mounted) return;

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$amount coins ajoutes a ${widget.pseudo}'),
                ),
              );
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.pseudo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("P2P Secure • ${widget.userId.substring(0,6)}...", style: const TextStyle(fontSize: 10, color: Colors.greenAccent)),
          ],
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.monetization_on, color: Colors.orange),
            onPressed: _showAddCoinsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messenger.localMessageStream,
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                
                final conversationMessages = messages.where((m) => 
                  (m['user_id'] == widget.userId && !(m['is_admin'] ?? false)) || 
                  (m['target_id'] == widget.userId && (m['is_admin'] ?? true))
                ).toList()
                ..sort((a, b) { // Tri par date
                  final aTime = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime.now();
                  final bTime = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime.now();
                  return aTime.compareTo(bTime);
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: conversationMessages.length,
                  itemBuilder: (context, index) {
                    final msg = conversationMessages[index];
                    return _MessageBubble(
                      content: msg['content']?.toString() ?? '',
                      isAdmin: msg['is_admin'] as bool? ?? false,
                      isRead: msg['status'] == 'sent',
                      type: msg['type']?.toString() ?? 'text',
                      fileUrl: msg['file_url']?.toString(),
                      duration: msg['duration'] as int?,
                      timestamp: msg['timestamp'] != null ? Timestamp.fromDate(DateTime.parse(msg['timestamp'])) : null,
                    );
                  },
                );
              },
            ),
          ),
          _buildEmojiBar(),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildEmojiBar() {
    final emojis = [
      AnimatedEmojis.redHeart,
      AnimatedEmojis.smile,
      AnimatedEmojis.wink,
      AnimatedEmojis.laughing,
      AnimatedEmojis.partyPopper,
      AnimatedEmojis.fire,
      AnimatedEmojis.rocket,
      AnimatedEmojis.ok,
    ];

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: emojis.length,
        itemBuilder: (context, index) => IconButton(
          onPressed: () => _send(content: emojis[index].name, type: 'emoji'),
          icon: AnimatedEmoji(emojis[index], size: 24),
        ),
      ),
    );
  }

  Widget _buildInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: 'Message Sigma...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            !_hasTypedText
                ? VoiceRecorder(onStop: _handleAudio)
                : IconButton.filled(
                    onPressed: _isSending ? null : () => _send(),
                    icon: const Icon(Icons.send),
                  ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String content;
  final bool isAdmin;
  final bool isRead;
  final String type;
  final String? fileUrl;
  final int? duration;
  final Timestamp? timestamp;

  const _MessageBubble({
    required this.content,
    required this.isAdmin,
    required this.isRead,
    required this.type,
    this.fileUrl,
    this.duration,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: type == 'audio'
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: type == 'audio'
            ? null
            : BoxDecoration(
                color: isAdmin
                    ? (isDark ? Colors.deepPurple[800] : Colors.deepPurple[100])
                    : (isDark ? Colors.grey[800] : Colors.grey[300]),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(isAdmin ? 15 : 0),
                  bottomRight: Radius.circular(isAdmin ? 0 : 15),
                ),
              ),
        child: Column(
          crossAxisAlignment:
              isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (type == 'emoji')
              AnimatedEmoji(_getEmojiData(content), size: 48)
            else if (type == 'audio' && fileUrl != null)
              AudioMessageBubble(
                url: fileUrl!,
                isAdmin: isAdmin,
                duration: duration != null ? Duration(seconds: duration!) : null,
              )
            else
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            const SizedBox(height: 2),
            Padding(
              padding: type == 'audio'
                  ? const EdgeInsets.only(right: 8, bottom: 4)
                  : EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (timestamp != null)
                    Text(
                      DateFormat('HH:mm').format(timestamp!.toDate()),
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  if (isAdmin) ...[
                    const SizedBox(width: 5),
                    Icon(
                      Icons.done_all,
                      size: 14,
                      color: isRead ? Colors.blue : Colors.grey,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedEmojiData _getEmojiData(String name) {
    const map = {
      'heart': AnimatedEmojis.redHeart,
      'redHeart': AnimatedEmojis.redHeart,
      'smile': AnimatedEmojis.smile,
      'wink': AnimatedEmojis.wink,
      'laughing': AnimatedEmojis.laughing,
      'partyPopper': AnimatedEmojis.partyPopper,
      'fire': AnimatedEmojis.fire,
      'rocket': AnimatedEmojis.rocket,
      'ok': AnimatedEmojis.ok,
    };
    return map[name] ?? AnimatedEmojis.smile;
  }
}
