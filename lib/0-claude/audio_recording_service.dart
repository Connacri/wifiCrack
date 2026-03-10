import 'dart:async';
import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum RecordingState {
  idle,
  recording,
  paused,
}

/// Service d'enregistrement audio pour les messages vocaux
class AudioRecordingService {
  final _audioRecorder = AudioRecorder();
  
  RecordingState _state = RecordingState.idle;
  DateTime? _recordingStartTime;
  String? _currentFilePath;
  Timer? _durationTimer;
  
  final _durationController = StreamController<Duration>.broadcast();
  final _amplitudeController = StreamController<double>.broadcast();

  RecordingState get state => _state;
  Stream<Duration> get onDurationUpdate => _durationController.stream;
  Stream<double> get onAmplitudeUpdate => _amplitudeController.stream;

  /// Démarre l'enregistrement
  Future<void> startRecording() async {
    if (_state != RecordingState.idle) {
      throw Exception('Enregistrement déjà en cours');
    }

    // Vérifier et demander les permissions
    final hasPermission = await _checkPermissions();
    if (!hasPermission) {
      throw Exception('Permission microphone refusée');
    }

    // Générer le chemin du fichier
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _currentFilePath = '${dir.path}/audio/voice_$timestamp.m4a';
    await Directory('${dir.path}/audio').create(recursive: true);

    // Configurer l'encodeur
    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
      numChannels: 1,
    );

    // Démarrer l'enregistrement
    await _audioRecorder.start(config, path: _currentFilePath!);
    
    _state = RecordingState.recording;
    _recordingStartTime = DateTime.now();

    // Démarrer le timer de durée
    _startDurationTimer();

    // Écouter l'amplitude
    _startAmplitudeStream();
  }

  /// Met en pause l'enregistrement
  Future<void> pauseRecording() async {
    if (_state != RecordingState.recording) return;

    await _audioRecorder.pause();
    _state = RecordingState.paused;
    _durationTimer?.cancel();
  }

  /// Reprend l'enregistrement
  Future<void> resumeRecording() async {
    if (_state != RecordingState.paused) return;

    await _audioRecorder.resume();
    _state = RecordingState.recording;
    _startDurationTimer();
  }

  /// Arrête l'enregistrement et retourne le chemin du fichier
  Future<String?> stopRecording() async {
    if (_state == RecordingState.idle) return null;

    _durationTimer?.cancel();
    
    final path = await _audioRecorder.stop();
    
    _state = RecordingState.idle;
    _recordingStartTime = null;
    
    return path ?? _currentFilePath;
  }

  /// Annule l'enregistrement et supprime le fichier
  Future<void> cancelRecording() async {
    if (_state == RecordingState.idle) return;

    _durationTimer?.cancel();
    
    await _audioRecorder.stop();
    
    // Supprimer le fichier
    if (_currentFilePath != null) {
      final file = File(_currentFilePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    _state = RecordingState.idle;
    _recordingStartTime = null;
    _currentFilePath = null;
  }

  /// Obtient la durée actuelle de l'enregistrement
  Duration getCurrentDuration() {
    if (_recordingStartTime == null) return Duration.zero;
    return DateTime.now().difference(_recordingStartTime!);
  }

  /// Vérifie si le microphone est disponible
  Future<bool> isMicrophoneAvailable() async {
    return await _audioRecorder.hasPermission();
  }

  // === Méthodes privées ===

  Future<bool> _checkPermissions() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  void _startDurationTimer() {
    _durationTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_state == RecordingState.recording) {
        _durationController.add(getCurrentDuration());
      }
    });
  }

  void _startAmplitudeStream() {
    _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 200))
        .listen((amplitude) {
      // Normaliser l'amplitude entre 0.0 et 1.0
      final normalized = (amplitude.current + 50) / 50;
      _amplitudeController.add(normalized.clamp(0.0, 1.0));
    });
  }

  /// Nettoie les ressources
  Future<void> dispose() async {
    await cancelRecording();
    await _audioRecorder.dispose();
    await _durationController.close();
    await _amplitudeController.close();
  }
}

/// Utilitaire pour formater la durée
extension DurationFormatter on Duration {
  String toMMSS() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
