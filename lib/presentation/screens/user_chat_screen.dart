import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animated_emoji/animated_emoji.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  bool _isMarkingRead = false;
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final userId = context.read<UserDataService>().deviceId;
      _markAsRead(userId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _markAsRead(String userId) async {
    if (_isMarkingRead) return;
    _isMarkingRead = true;
    try {
      await _messenger.markAsRead(userId, isAdmin: false);
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

  void _handleMessageListChanged(String userId, int messageCount) {
    if (messageCount <= _lastMessageCount) return;
    _lastMessageCount = messageCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToBottom();
      _markAsRead(userId);
    });
  }

  Future<void> _send(String userId, {String? content, String type = 'text'}) async {
    final msg = content ?? _controller.text.trim();
    if (msg.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    final sent = await _messenger.sendMessage(
      userId,
      msg,
      isAdmin: false,
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
    final userId = context.read<UserDataService>().deviceId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Sigma Pro'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messenger.getMessagesStream(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final docs = snapshot.data?.docs ?? [];
                _handleMessageListChanged(userId, docs.length);

                if (docs.isEmpty && snapshot.connectionState != ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedEmoji(AnimatedEmojis.smile, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          "Comment pouvons-nous vous aider ?",
                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index].data() as Map<String, dynamic>;
                    return _UserMessageBubble(
                      content: msg['content'] ?? "",
                      isAdmin: msg['is_admin'] ?? false,
                      type: msg['type'] ?? 'text',
                      timestamp: msg['timestamp'] as Timestamp?,
                    );
                  },
                );
              },
            ),
          ),
          _buildEmojiBar(userId),
          _buildInput(userId),
        ],
      ),
    );
  }

  Widget _buildEmojiBar(String userId) {
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
            onPressed: () => _send(userId, content: emojis[index].name, type: 'emoji'),
            icon: AnimatedEmoji(emojis[index], size: 24),
          );
        },
      ),
    );
  }

  Widget _buildInput(String userId) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _send(userId),
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
            onPressed: _isSending ? null : () => _send(userId),
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class _UserMessageBubble extends StatelessWidget {
  final String content;
  final bool isAdmin;
  final String type;
  final Timestamp? timestamp;

  const _UserMessageBubble({
    required this.content,
    required this.isAdmin,
    required this.type,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
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
            if (type == 'emoji')
               AnimatedEmoji(_getEmojiData(content), size: 48)
            else
               Text(content, style: const TextStyle(fontSize: 16)),
            
            if (timestamp != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat('HH:mm').format(timestamp!.toDate()),
                  style: const TextStyle(fontSize: 10, color: Colors.black45),
                ),
              ),
          ],
        ),
      ),
    );
  }

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
