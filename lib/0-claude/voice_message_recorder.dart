import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'audio_recording_service.dart';
import 'dart:ui';

class VoiceMessageRecorder extends StatefulWidget {
  final Function(String path, int duration) onRecordingComplete;
  final VoidCallback onCancel;

  const VoiceMessageRecorder({
    super.key,
    required this.onRecordingComplete,
    required this.onCancel,
  });

  @override
  State<VoiceMessageRecorder> createState() => _VoiceMessageRecorderState();
}

class _VoiceMessageRecorderState extends State<VoiceMessageRecorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Duration _duration = Duration.zero;
  double _amplitude = 0.0;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _startRecording();
  }

  Future<void> _startRecording() async {
    final audioService = context.read<AppProvider>().audioRecording;

    try {
      await audioService.startRecording();
      setState(() => _isRecording = true);

      audioService.onDurationUpdate.listen((duration) {
        if (!mounted) return;
        setState(() => _duration = duration);
        if (duration.inMinutes >= 5) {
          _stopRecording();
        }
      });

      audioService.onAmplitudeUpdate.listen((amplitude) {
        if (!mounted) return;
        setState(() => _amplitude = amplitude);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
        widget.onCancel();
      }
    }
  }

  Future<void> _stopRecording() async {
    final audioService = context.read<AppProvider>().audioRecording;
    final path = await audioService.stopRecording();
    if (path != null) {
      widget.onRecordingComplete(path, _duration.inSeconds);
    }
  }

  Future<void> _cancelRecording() async {
    final audioService = context.read<AppProvider>().audioRecording;
    await audioService.cancelRecording();
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            // FIX: withOpacity() déprécié depuis Flutter 3.27 → withValues(alpha:)
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _cancelRecording,
            icon: const Icon(Icons.close, color: Colors.red),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 40,
                  width: _amplitude *
                      MediaQuery.of(context).size.width *
                      0.5,
                  decoration: BoxDecoration(
                    // FIX: withValues(alpha:) sur une couleur de thème
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _duration.toMMSS(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: FloatingActionButton(
                  onPressed: _stopRecording,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.send),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}