import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_recording_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;
  final int duration;

  const AudioPlayerWidget({
    super.key,
    required this.filePath,
    required this.duration,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _totalDuration = Duration(seconds: widget.duration);
    _setupPlayer();
  }

  void _setupPlayer() {
    _player.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });

    _player.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _player.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(DeviceFileSource(widget.filePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _totalDuration.inSeconds > 0
        ? _position.inSeconds / _totalDuration.inSeconds
        : 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton play/pause
        IconButton(
          onPressed: _togglePlayPause,
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 28,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),

        const SizedBox(width: 8),

        // Waveform visuelle (barre de progression)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de progression
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                  minHeight: 4,
                ),
              ),

              const SizedBox(height: 4),

              // Durée
              Text(
                '${_position.toMMSS()} / ${_totalDuration.toMMSS()}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Icône microphone
        const Icon(Icons.mic, size: 16, color: Colors.grey),
      ],
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
