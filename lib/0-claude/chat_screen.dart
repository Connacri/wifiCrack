import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'message.dart';
import 'contact.dart';
import 'app_provider.dart';
import 'voice_message_recorder.dart';
import 'audio_player_widget.dart';

class ChatScreen extends StatefulWidget {
  final Contact contact;

  const ChatScreen({super.key, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isTyping = false;
  bool _showRecorder = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _markAsRead();
  }

  Future<void> _loadMessages() async {
    final provider = context.read<AppProvider>();
    final messages = await provider.getConversationMessages(widget.contact.deviceId);
    setState(() => _messages = messages);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _markAsRead() async {
    final provider = context.read<AppProvider>();
    await provider.markConversationAsRead(widget.contact.deviceId);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    
    final provider = context.read<AppProvider>();
    await provider.sendTextMessage(widget.contact.deviceId, text);
    await provider.sendTyping(widget.contact.deviceId, false);
    
    await _loadMessages();
  }

  void _onTextChanged(String text) {
    final provider = context.read<AppProvider>();
    final nowTyping = text.isNotEmpty;
    
    if (nowTyping != _isTyping) {
      _isTyping = nowTyping;
      provider.sendTyping(widget.contact.deviceId, nowTyping);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isOnline = provider.isContactOnline(widget.contact.deviceId);
    final isTyping = provider.isContactTyping(widget.contact.deviceId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  child: Text(widget.contact.pseudo[0].toUpperCase()),
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.contact.pseudo, style: const TextStyle(fontSize: 16)),
                  Text(
                    isOnline ? (isTyping ? 'en train d\'écrire...' : 'en ligne') : 'hors ligne',
                    style: TextStyle(
                      fontSize: 12,
                      color: isTyping ? Colors.green : Colors.grey,
                      fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _MessageBubble(
                message: _messages[index],
                contact: widget.contact,
              ),
            ),
          ),
          if (_showRecorder)
            VoiceMessageRecorder(
              onRecordingComplete: (path, duration) async {
                setState(() => _showRecorder = false);
                await provider.sendAudioMessage(widget.contact.deviceId, path, duration);
                await _loadMessages();
              },
              onCancel: () => setState(() => _showRecorder = false),
            )
          else
            _ChatInput(
              controller: _messageController,
              onChanged: _onTextChanged,
              onSend: _sendMessage,
              onVoicePressed: () => setState(() => _showRecorder = true),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    context.read<AppProvider>().sendTyping(widget.contact.deviceId, false);
    super.dispose();
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final Contact contact;

  const _MessageBubble({required this.message, required this.contact});

  @override
  Widget build(BuildContext context) {
    final isSent = message.isSentByMe;
    final theme = Theme.of(context);

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSent ? theme.colorScheme.primaryContainer : theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isSent ? const Radius.circular(4) : null,
            bottomLeft: !isSent ? const Radius.circular(4) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.type == MessageType.text)
              Text(message.encryptedContent)
            else if (message.type == MessageType.audio && message.localMediaPath != null)
              AudioPlayerWidget(filePath: message.localMediaPath!, duration: message.audioDuration ?? 0),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                if (isSent) ...[const SizedBox(width: 4), _StatusIcon(status: message.status)],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (status) {
      case MessageStatus.sending: icon = Icons.schedule; color = Colors.grey; break;
      case MessageStatus.sent: icon = Icons.check; color = Colors.grey; break;
      case MessageStatus.delivered: icon = Icons.done_all; color = Colors.grey; break;
      case MessageStatus.read: icon = Icons.done_all; color = Colors.blue; break;
      case MessageStatus.failed: icon = Icons.error_outline; color = Colors.red; break;
    }
    return Icon(icon, size: 14, color: color);
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;
  final VoidCallback onVoicePressed;

  const _ChatInput({
    required this.controller,
    required this.onChanged,
    required this.onSend,
    required this.onVoicePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Message...',
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, _) => IconButton.filled(
              onPressed: value.text.trim().isNotEmpty ? onSend : onVoicePressed,
              icon: Icon(value.text.trim().isNotEmpty ? Icons.send : Icons.mic),
            ),
          ),
        ],
      ),
    );
  }
}
