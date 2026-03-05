import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animated_emoji/animated_emoji.dart';
import '../../data/sources/firebase_messenger_service.dart';
import '../../data/sources/user_data_service.dart';
import '../widgets/messenger_audio_widgets.dart';

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

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _sortedDocs(QuerySnapshot? snapshot) {
    final docs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(snapshot?.docs ?? const []);
    docs.sort((a, b) {
      final aTs = a.data()['timestamp'] as Timestamp?;
      final bTs = b.data()['timestamp'] as Timestamp?;
      final aTime = aTs?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
      final bTime = bTs?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
      return aTime.compareTo(bTime);
    });
    return docs;
  }

  Future<void> _send(String userId, {String? content, String type = 'text', String? fileUrl, int? duration}) async {
    final msg = content ?? _controller.text.trim();
    if ((msg.isEmpty && fileUrl == null && type != 'audio') || _isSending) return;

    setState(() => _isSending = true);
    final sent = await _messenger.sendMessage(
      userId,
      msg.isEmpty ? (type == 'audio' ? '🎤 Vocal' : 'Message') : msg,
      isAdmin: false,
      type: type,
      fileUrl: fileUrl,
      durationInSeconds: duration,
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

  Future<void> _handleAudio(String userId, String path, Duration duration) async {
    final url = await _messenger.uploadAudio(userId, path);
    if (url != null) {
      await _send(userId, type: 'audio', fileUrl: url, duration: duration.inSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserDataService>().deviceId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Sigma Pro', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _messenger.getMessagesStream(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final docs = _sortedDocs(snapshot.data);
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
                            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
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
                        fileUrl: msg['file_url'],
                        duration: msg['duration'],
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
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: "Écrire au support...",
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _controller.text.trim().isEmpty 
            ? VoiceRecorder(onStop: (path, dur) => _handleAudio(userId, path, dur))
            : IconButton.filled(
                onPressed: _isSending ? null : () => _send(userId),
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
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
  final String? fileUrl;
  final int? duration;
  final Timestamp? timestamp;

  const _UserMessageBubble({
    required this.content,
    required this.isAdmin,
    required this.type,
    this.fileUrl,
    this.duration,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: type == 'audio' ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: type == 'audio' ? null : BoxDecoration(
          color: isAdmin 
              ? (isDark ? Colors.grey[800] : Colors.grey[300])
              : Theme.of(context).colorScheme.primaryContainer,
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
            else if (type == 'audio' && fileUrl != null)
               AudioMessageBubble(url: fileUrl!, isAdmin: isAdmin, duration: duration != null ? Duration(seconds: duration!) : null)
            else
               Text(content, style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color)),
            
            if (timestamp != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat('HH:mm').format(timestamp!.toDate()),
                  style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45),
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
