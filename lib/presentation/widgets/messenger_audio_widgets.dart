import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Widget expert pour l'enregistrement vocal avec animation Sigma.
class VoiceRecorder extends StatefulWidget {
  final Function(String path, Duration duration) onStop;

  const VoiceRecorder({super.key, required this.onStop});

  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> with SingleTickerProviderStateMixin {
  late AudioRecorder _audioRecorder;
  late AnimationController _controller;
  bool _isRecording = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/vocal_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        const config = RecordConfig();
        await _audioRecorder.start(config, path: path);
        
        setState(() {
          _isRecording = true;
          _startTime = DateTime.now();
        });
      }
    } catch (e) {
      debugPrint("❌ Recording Error: $e");
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();
    if (path != null && _startTime != null) {
      final duration = DateTime.now().difference(_startTime!);
      if (duration.inSeconds >= 1) {
        widget.onStop(path, duration);
      }
    }
    setState(() {
      _isRecording = false;
      _startTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _start(),
      onLongPressEnd: (_) => _stop(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(_isRecording ? 16 : 12),
        decoration: BoxDecoration(
          color: _isRecording ? Colors.red : Colors.deepPurple,
          shape: BoxShape.circle,
          boxShadow: _isRecording 
              ? [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 15, spreadRadius: 5)]
              : [],
        ),
        child: ScaleTransition(
          scale: _isRecording ? _controller.drive(Tween(begin: 1.0, end: 1.2)) : const AlwaysStoppedAnimation(1.0),
          child: const Icon(Icons.mic, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

/// Bulle de message audio avec lecteur intégré.
class AudioMessageBubble extends StatefulWidget {
  final String url;
  final bool isAdmin;
  final Duration? duration;

  const AudioMessageBubble({
    super.key, 
    required this.url, 
    required this.isAdmin, 
    this.duration
  });

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  late AudioPlayer _player;
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;
  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _stateSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _totalDuration = widget.duration ?? Duration.zero;

    _stateSub = _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _playerState = s);
    });

    _posSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _durSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _totalDuration = d);
    });
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (_playerState == PlayerState.playing) {
      await _player.pause();
    } else {
      await _player.play(UrlSource(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.isAdmin 
        ? Colors.deepPurple 
        : (isDark ? Colors.grey[800] : Colors.grey[200]);
    final contentColor = widget.isAdmin ? Colors.white : (isDark ? Colors.white : Colors.black87);

    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow,
              color: contentColor,
            ),
            onPressed: _playPause,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: _totalDuration.inMilliseconds > 0 
                      ? _position.inMilliseconds / _totalDuration.inMilliseconds 
                      : 0,
                  backgroundColor: contentColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDuration(_position),
                  style: TextStyle(fontSize: 10, color: contentColor.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
