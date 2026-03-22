import 'dart:async';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../data/sources/message_service.dart';
import '../../data/sources/p2p_transfer_service.dart';
import '../../data/sources/user_data_service.dart';
import '../widgets/messenger_audio_widgets.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({super.key});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late MessageService _messenger;
  late P2PTransferService _p2pService;
  bool _servicesReady = false;

  bool _isSending = false;
  bool _hasTypedText = false;

  // ID Fixe pour le Support/Admin Sigma
  static const String adminId = "SIGMA_ADMIN_OFFICIAL";

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_servicesReady) return;
    _messenger = context.read<MessageService>();
    _p2pService = context.read<P2PTransferService>();
    
    // Marquer comme lu
    _messenger.markAsReadLocal(adminId);
    
    _servicesReady = true;
  }

  @override
  void dispose() {
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
    
    final myId = context.read<UserDataService>().deviceId;

    await _messenger.sendP2PMessage(
      adminId,
      myId,
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
    // Dans le cas du support, on peut uploader sur Firebase Storage pour que l'admin le voie
    final myId = context.read<UserDataService>().deviceId;
    final url = await _messenger.uploadAudio(myId, path);
    if (url != null) {
      await _send(type: 'audio', fileUrl: url, duration: duration.inSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.supportSigmaPro, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(l10n.p2pEncryptedChat, style: const TextStyle(fontSize: 10, color: Colors.greenAccent)),
          ],
        ),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messenger.localMessageStream,
              builder: (context, snapshot) {
                final allMessages = snapshot.data ?? [];
                
                // Filtrer pour ne garder que la conversation avec l'admin
                final messages = allMessages.where((m) => 
                  m['peer_id'] == adminId || m['target_id'] == adminId || m['user_id'] == adminId
                ).toList()
                ..sort((a, b) {
                  final aTs = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime.now();
                  final bTs = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime.now();
                  return aTs.compareTo(bTs);
                });

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AnimatedEmoji(AnimatedEmojis.smile, size: 64),
                        const SizedBox(height: 16),
                        Text(l10n.needHelpMessage),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isAdminMsg = msg['is_admin'] == false || msg['user_id'] == adminId;
                    
                    return _MessageBubble(
                      content: msg['content']?.toString() ?? '',
                      isMe: !isAdminMsg,
                      type: msg['type']?.toString() ?? 'text',
                      fileUrl: msg['file_url']?.toString(),
                      duration: msg['duration'] as int?,
                      timestamp: msg['timestamp'] != null 
                        ? Timestamp.fromDate(DateTime.parse(msg['timestamp'])) 
                        : null,
                    );
                  },
                );
              },
            ),
          ),
          _buildEmojiBar(),
          _buildInput(l10n),
        ],
      ),
    );
  }

  Widget _buildEmojiBar() {
    final emojis = [
      AnimatedEmojis.redHeart, AnimatedEmojis.smile, AnimatedEmojis.wink,
      AnimatedEmojis.laughing, AnimatedEmojis.partyPopper, AnimatedEmojis.fire,
      AnimatedEmojis.rocket, AnimatedEmojis.ok,
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

  Widget _buildInput(AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: l10n.supportChatPlaceholder,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
  final bool isMe;
  final String type;
  final String? fileUrl;
  final int? duration;
  final Timestamp? timestamp;

  const _MessageBubble({
    required this.content,
    required this.isMe,
    required this.type,
    this.fileUrl,
    this.duration,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: type == 'audio' ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: type == 'audio' ? null : BoxDecoration(
          color: isMe 
            ? Theme.of(context).colorScheme.primary 
            : (isDark ? Colors.grey[800] : Colors.grey[300]),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isMe ? 15 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 15),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (type == 'emoji')
              AnimatedEmoji(_getEmojiData(content), size: 48)
            else if (type == 'audio' && fileUrl != null)
              AudioMessageBubble(
                url: fileUrl!,
                isAdmin: !isMe,
                duration: duration != null ? Duration(seconds: duration!) : null,
              )
            else
              Text(
                content,
                style: TextStyle(fontSize: 16, color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87)),
              ),
            if (timestamp != null)
              Text(
                DateFormat('HH:mm').format(timestamp!.toDate()),
                style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.black45),
              ),
          ],
        ),
      ),
    );
  }

  AnimatedEmojiData _getEmojiData(String name) {
    const map = {
      'heart': AnimatedEmojis.redHeart, 'redHeart': AnimatedEmojis.redHeart,
      'smile': AnimatedEmojis.smile, 'wink': AnimatedEmojis.wink,
      'laughing': AnimatedEmojis.laughing, 'partyPopper': AnimatedEmojis.partyPopper,
      'fire': AnimatedEmojis.fire, 'rocket': AnimatedEmojis.rocket, 'ok': AnimatedEmojis.ok,
    };
    return map[name] ?? AnimatedEmojis.smile;
  }
}
