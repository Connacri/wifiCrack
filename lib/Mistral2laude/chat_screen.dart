import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../data/sources/supabase_service.dart';
import 'app_provider.dart';
import 'message.dart';
import 'notification_service.dart';
import 'objectbox_service.dart';
import 'webrtc_service.dart';

class ChatScreen extends StatefulWidget {
  final String myDeviceId;
  final String friendDeviceId;
  final String? friendPseudo;

  const ChatScreen({
    super.key,
    required this.myDeviceId,
    required this.friendDeviceId,
    this.friendPseudo,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final ObjectBoxService _objectBox;
  late final WebRTCService _webrtcService;
  final NotificationService _notifService = NotificationService();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  WebRTCState _connectionState = WebRTCState.idle;
  bool _servicesReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      provider.contactService.resetUnreadCount(widget.friendDeviceId);
      _initServices(provider);
    });
  }

  Future<void> _initServices(AppProvider provider) async {
    _objectBox = provider.objectBox;

    _webrtcService = WebRTCService(
      supabaseService: SupabaseService(),
      deviceId: widget.myDeviceId,
      friendDeviceId: widget.friendDeviceId,
    );

    _webrtcService.onStateChanged = (state) {
      if (mounted) setState(() => _connectionState = state);
    };

    _webrtcService.onMessageReceived = (content) {
      _saveMessage(content, isMe: false);
      _notifService.showMessageNotification(
        senderPseudo: widget.friendPseudo ?? 'Ami',
        messagePreview: content,
        conversationId: widget.friendDeviceId,
      );
      provider.contactService.updateContactPreview(
        deviceId: widget.friendDeviceId,
        preview: content,
        messageAt: DateTime.now(),
      );
    };

    _webrtcService.onVoiceReceived = (voiceUrl) {
      _saveMessage(
        '[🎤 Message vocal]',
        isMe: false,
        isVoice: true,
        voiceUrl: voiceUrl,
      );
      _notifService.showMessageNotification(
        senderPseudo: widget.friendPseudo ?? 'Ami',
        messagePreview: '🎤 Message vocal',
        conversationId: widget.friendDeviceId,
      );
    };

    await _webrtcService.initialize();

    if (mounted) setState(() => _servicesReady = true);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _webrtcService.dispose();
    super.dispose();
  }

  void _saveMessage(
    String content, {
    required bool isMe,
    bool isVoice = false,
    String? voiceUrl,
  }) {
    final msg = M2CMessage(
      senderDeviceId: isMe ? widget.myDeviceId : widget.friendDeviceId,
      receiverDeviceId: isMe ? widget.friendDeviceId : widget.myDeviceId,
      content: content,
      isVoice: isVoice,
      voiceUrl: voiceUrl,
      timestamp: DateTime.now(),
      status: isMe ? MessageStatus.sent : MessageStatus.read,
    );
    _objectBox.messageBox.put(msg);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    _saveMessage(text, isMe: true);

    final sent = await _webrtcService.sendMessage(text);
    if (!sent && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ Connexion non établie. Message sauvegardé localement.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    context.read<AppProvider>().contactService.updateContactPreview(
      deviceId: widget.friendDeviceId,
      preview: text,
      messageAt: DateTime.now(),
    );
  }

  Future<void> _startRecording() async {
    if (!await _audioRecorder.hasPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission microphone refusée')),
        );
      }
      return;
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 64000),
      path: path,
    );

    if (mounted) setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    if (mounted) setState(() => _isRecording = false);

    if (path == null) return;

    final file = File(path);
    if (!await file.exists() || await file.length() < 1000) return;

    _saveMessage(
      '[🎤 Message vocal]',
      isMe: true,
      isVoice: true,
      voiceUrl: path,
    );
    await _webrtcService.sendVoiceMessage(path);
  }

  Future<void> _playVoice(String url) async {
    await _audioPlayer.stop();
    if (url.startsWith('http')) {
      await _audioPlayer.play(UrlSource(url));
    } else {
      await _audioPlayer.play(DeviceFileSource(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                (widget.friendPseudo ?? widget.friendDeviceId)[0].toUpperCase(),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendPseudo ?? widget.friendDeviceId.substring(0, 8),
                ),
                _ConnectionStatusDot(state: _connectionState),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<M2CMessage>>(
              stream: _objectBox.watchConversation(
                myDeviceId: widget.myDeviceId,
                friendDeviceId: widget.friendDeviceId,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun message.\nEnvoyez le premier ! 👋',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final msg = messages[index];
                    final isMe = msg.senderDeviceId == widget.myDeviceId;
                    return _MessageBubble(
                      message: msg,
                      isMe: isMe,
                      onPlayVoice: _playVoice,
                    );
                  },
                );
              },
            ),
          ),

          _InputBar(
            controller: _messageController,
            isRecording: _isRecording,
            isReady: _servicesReady,
            onSend: _sendMessage,
            onRecordStart: _startRecording,
            onRecordStop: _stopRecording,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final M2CMessage message;
  final bool isMe;
  final Future<void> Function(String) onPlayVoice;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.onPlayVoice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor = isMe
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final textColor = isMe
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 64 : 8,
          right: isMe ? 8 : 64,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.isVoice && message.voiceUrl != null)
              InkWell(
                onTap: () => onPlayVoice(message.voiceUrl!),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_fill, color: textColor, size: 32),
                    const SizedBox(width: 4),
                    Text('Message vocal', style: TextStyle(color: textColor)),
                  ],
                ),
              )
            else
              Text(message.content, style: TextStyle(color: textColor)),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    _statusIcon(message.status),
                    size: 12,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  IconData _statusIcon(MessageStatus s) {
    switch (s) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
    }
  }
}

class _ConnectionStatusDot extends StatelessWidget {
  final WebRTCState state;
  const _ConnectionStatusDot({required this.state});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (state) {
      case WebRTCState.connected:
        color = Colors.green;
        label = 'Connecté';
        break;
      case WebRTCState.connecting:
        color = Colors.orange;
        label = 'Connexion...';
        break;
      case WebRTCState.failed:
        color = Colors.red;
        label = 'Échec';
        break;
      default:
        color = Colors.grey;
        label = 'Hors ligne';
    }
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isRecording;
  final bool isReady;
  final VoidCallback onSend;
  final VoidCallback onRecordStart;
  final VoidCallback onRecordStop;

  const _InputBar({
    required this.controller,
    required this.isRecording,
    required this.isReady,
    required this.onSend,
    required this.onRecordStart,
    required this.onRecordStop,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Row(
          children: [
            GestureDetector(
              onLongPressStart: (_) => onRecordStart(),
              onLongPressEnd: (_) => onRecordStop(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecording
                      ? Colors.red
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Icon(
                  isRecording ? Icons.mic : Icons.mic_none,
                  color: isRecording
                      ? Colors.white
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !isRecording && isReady,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: isRecording
                      ? '🔴 Enregistrement...'
                      : isReady
                      ? 'Message...'
                      : 'Connexion en cours...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: isReady ? onSend : null,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
