import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animated_emoji/animated_emoji.dart';
import '../../data/sources/firebase_messenger_service.dart';
import '../../data/sources/supabase_service.dart';
import '../../data/sources/user_data_service.dart';

/// Screen "Messenger Sigma" : Dashboard Admin pour voir toutes les cibles.
class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final SupabaseService _supabase = SupabaseService();
  final FirebaseMessengerService _messenger = FirebaseMessengerService();
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _supabase.fetchUniqueUsers();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = _supabase.fetchUniqueUsers();
    });
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
            return const Center(child: Text("Aucun utilisateur trouvé."));
          }

          final users = snapshot.data!.where((u) => u['device_id'] != currentUserId).toList();

          if (users.isEmpty) {
            return const Center(child: Text("Aucune autre cible détectée."));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              final String deviceId = user['device_id'];
              final String pseudo = user['pseudo'] ?? deviceId.substring(0, 8);
              final String model = user['model'] ?? "Inconnu";
              
              return _UserChatTile(
                userId: deviceId,
                displayTitle: pseudo,
                subtitle: model,
                messenger: _messenger,
                onTap: () => _openChat(deviceId, pseudo),
              );
            },
          );
        },
      ),
    );
  }

  void _openChat(String deviceId, String pseudo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedChatScreen(userId: deviceId, pseudo: pseudo),
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
    required this.onTap
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
          title: Text(displayTitle, style: TextStyle(fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: unreadCount > 0
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text(unreadCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
  const DetailedChatScreen({super.key, required this.userId, required this.pseudo});

  @override
  State<DetailedChatScreen> createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseMessengerService _messenger = FirebaseMessengerService();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  bool _isMarkingRead = false;
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAsRead();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _markAsRead() async {
    if (_isMarkingRead) return;
    _isMarkingRead = true;
    try {
      await _messenger.markAsRead(widget.userId, isAdmin: true);
    } finally {
      _isMarkingRead = false;
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
      return;
    }
    _scrollController.jumpTo(target);
  }

  void _handleMessageListChanged(int messageCount) {
    if (messageCount <= _lastMessageCount) return;
    _lastMessageCount = messageCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToBottom();
      _markAsRead();
    });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _sortedDocs(
    QuerySnapshot<Map<String, dynamic>>? snapshot,
  ) {
    final docs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
      snapshot?.docs ?? const [],
    );
    docs.sort((a, b) {
      final aTs = a.data()['timestamp'] as Timestamp?;
      final bTs = b.data()['timestamp'] as Timestamp?;
      final aMs = aTs?.millisecondsSinceEpoch ?? 0;
      final bMs = bTs?.millisecondsSinceEpoch ?? 0;
      return aMs.compareTo(bMs);
    });
    return docs;
  }

  Future<void> _send({String? content, String type = 'text'}) async {
    final msg = content ?? _controller.text.trim();
    if (msg.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    final sent = await _messenger.sendMessage(
      widget.userId,
      msg,
      isAdmin: true,
      type: type,
    );
    if (!mounted) return;
    setState(() => _isSending = false);

    if (!sent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Echec envoi message. Reessayez.')),
      );
      return;
    }

    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.pseudo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.userId, style: const TextStyle(fontSize: 9, color: Colors.black54)),
          ],
        ),
        backgroundColor: Colors.orange[200],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messenger.getMessagesStream(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final docs = _sortedDocs(snapshot.data);
                _handleMessageListChanged(docs.length);

                if (docs.isEmpty) {
                  return const Center(child: Text('Aucun message pour le moment.'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index].data();
                    return _MessageBubble(
                      content: msg['content'] ?? "",
                      isAdmin: msg['is_admin'] ?? false,
                      isRead: msg['is_read'] ?? false,
                      type: msg['type'] ?? 'text',
                      timestamp: msg['timestamp'] as Timestamp?,
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
    // Correct usage according to doc: AnimatedEmojis.<emoji>
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          return IconButton(
            onPressed: () => _send(content: emojis[index].name, type: 'emoji'),
            icon: AnimatedEmoji(emojis[index], size: 24),
          );
        },
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: "Message Admin...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              onPressed: _isSending ? null : () => _send(),
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(backgroundColor: Colors.orange),
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
  final Timestamp? timestamp;

  const _MessageBubble({
    required this.content,
    required this.isAdmin,
    required this.isRead,
    required this.type,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
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
            if (type == 'emoji')
               AnimatedEmoji(_getEmojiData(content), size: 48)
            else
               Text(content, style: const TextStyle(fontSize: 16)),
            
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (timestamp != null)
                  Text(
                    DateFormat('HH:mm').format(timestamp!.toDate()),
                    style: const TextStyle(fontSize: 10, color: Colors.black45),
                  ),
                if (isAdmin) ...[
                  const SizedBox(width: 5),
                  Icon(Icons.done_all, size: 14, color: isRead ? Colors.blue : Colors.grey),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Expert mapping for GAFAM-style emoji recovery
  AnimatedEmojiData _getEmojiData(String name) {
    final map = {
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
