import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import '../../l10n/app_localizations.dart';

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
  Timer? _timer;
  Duration _currentDuration = Duration.zero;

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
    _timer?.cancel();
    _audioRecorder.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/vocal_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        const config = RecordConfig(encoder: AudioEncoder.aacLc);
        await _audioRecorder.start(config, path: path);
        
        setState(() {
          _isRecording = true;
          _startTime = DateTime.now();
          _currentDuration = Duration.zero;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _currentDuration = DateTime.now().difference(_startTime!);
            });
          }
        });
      }
    } catch (e) {
      debugPrint("❌ Recording Error: $e");
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    try {
      final path = await _audioRecorder.stop();
      // Délai de sécurité pour laisser le temps au plugin de fermer le flux fichier
      await Future.delayed(const Duration(milliseconds: 200));

      if (path != null && _startTime != null) {
        final duration = DateTime.now().difference(_startTime!);
        if (duration.inMilliseconds > 500) {
          widget.onStop(path, duration);
        }
      }
    } catch (e) {
      debugPrint("❌ Stop Recording Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isRecording = false;
          _startTime = null;
          _currentDuration = Duration.zero;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isRecording)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDuration(_currentDuration),
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        GestureDetector(
          onLongPressStart: (_) => _start(),
          onLongPressEnd: (_) => _stop(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(_isRecording ? 16 : 12),
            decoration: BoxDecoration(
              color: _isRecording ? Colors.red : Colors.deepPurple,
              shape: BoxShape.circle,
          boxShadow: _isRecording 
              ? [BoxShadow(color: Colors.red.withValues(alpha: 0.4), blurRadius: 15, spreadRadius: 5)]
              : [],
            ),
            child: ScaleTransition(
              scale: _isRecording ? _controller.drive(Tween(begin: 1.0, end: 1.2)) : const AlwaysStoppedAnimation(1.0),
              child: const Icon(Icons.mic, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
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
      if (mounted && d != Duration.zero) setState(() => _totalDuration = d);
    });
  }

  @override
  void didUpdateWidget(AudioMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration && widget.duration != null) {
      setState(() => _totalDuration = widget.duration!);
    }
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
    final l10n = AppLocalizations.of(context)!;
    if (_playerState == PlayerState.playing) {
      await _player.pause();
    } else {
      if (widget.url.startsWith('p2p:')) {
        final fileName = widget.url.replaceFirst('p2p:', '');
        final docDir = await getApplicationDocumentsDirectory();
        File file = File('${docDir.path}/$fileName');
        if (!await file.exists()) {
          final tempDir = await getTemporaryDirectory();
          file = File('${tempDir.path}/$fileName');
        }
        
        if (await file.exists()) {
          await _player.play(DeviceFileSource(file.path));
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.audioUnavailable)),
            );
          }
        }
      } else {
        await _player.play(UrlSource(widget.url));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.isAdmin 
        ? Colors.deepPurple 
        : (isDark ? Colors.grey[800] : Colors.grey[200]);
    final contentColor = widget.isAdmin ? Colors.white : (isDark ? Colors.white : Colors.black87);

    // Si on joue, on montre la position, sinon on montre la durée totale
    final displayDuration = _playerState == PlayerState.playing ? _position : _totalDuration;

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
                  backgroundColor: contentColor.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(displayDuration),
                      style: TextStyle(fontSize: 10, color: contentColor.withValues(alpha: 0.7)),
                    ),
                    if (_playerState != PlayerState.playing && _totalDuration != Duration.zero)
                      Text(
                        "🎤",
                        style: TextStyle(fontSize: 10, color: contentColor.withValues(alpha: 0.5)),
                      ),
                  ],
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
