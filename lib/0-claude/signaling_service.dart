import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum SignalType {
  offer,
  answer,
  iceCandidate,
  presence,
  typing,
}

class SignalingMessage {
  final String from;
  final String to;
  final SignalType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  SignalingMessage({
    required this.from,
    required this.to,
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'from_device': from,
        'to_device': to,
        'signal_type': type.name,
        'data': data,
        'created_at': timestamp.toIso8601String(),
      };

  factory SignalingMessage.fromJson(Map<String, dynamic> json) {
    return SignalingMessage(
      from: json['from_device'],
      to: json['to_device'],
      type: SignalType.values.firstWhere((e) => e.name == json['signal_type']),
      data: json['data'],
      timestamp: DateTime.parse(json['created_at']),
    );
  }
}

/// Service de signaling WebRTC via Supabase Realtime
class SignalingService {
  final SupabaseClient _supabase;
  final String _deviceId;
  
  RealtimeChannel? _channel;
  final _signalController = StreamController<SignalingMessage>.broadcast();
  
  Stream<SignalingMessage> get onSignal => _signalController.stream;

  SignalingService(this._supabase, this._deviceId);

  /// Initialise le canal de signaling Realtime
  Future<void> initialize() async {
    // 1. Mettre à jour le statut utilisateur
    await _updateUserPresence(true);

    // 2. S'abonner au canal Realtime pour recevoir les signaux
    _channel = _supabase.channel('signaling:$_deviceId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'webrtc_signals',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'to_device',
          value: _deviceId,
        ),
        callback: (payload) {
          final signal = SignalingMessage.fromJson(payload.newRecord);
          _signalController.add(signal);
          
          // Supprimer le signal après lecture
          _deleteSignal(payload.newRecord['id']);
        },
      )
      ..subscribe();

    // 3. Nettoyer les anciens signaux au démarrage
    await _cleanOldSignals();
  }

  /// Envoie un signal de signaling
  Future<void> sendSignal(SignalingMessage message) async {
    await _supabase.from('webrtc_signals').insert(message.toJson());
  }

  /// Envoie une offre WebRTC
  Future<void> sendOffer(String toDeviceId, RTCSessionDescription offer) async {
    await sendSignal(SignalingMessage(
      from: _deviceId,
      to: toDeviceId,
      type: SignalType.offer,
      data: {
        'sdp': offer.sdp,
        'type': offer.type,
      },
    ));
  }

  /// Envoie une réponse WebRTC
  Future<void> sendAnswer(String toDeviceId, RTCSessionDescription answer) async {
    await sendSignal(SignalingMessage(
      from: _deviceId,
      to: toDeviceId,
      type: SignalType.answer,
      data: {
        'sdp': answer.sdp,
        'type': answer.type,
      },
    ));
  }

  /// Envoie un candidat ICE
  Future<void> sendIceCandidate(String toDeviceId, RTCIceCandidate candidate) async {
    await sendSignal(SignalingMessage(
      from: _deviceId,
      to: toDeviceId,
      type: SignalType.iceCandidate,
      data: {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      },
    ));
  }

  /// Envoie un signal de présence (en ligne/hors ligne)
  Future<void> sendPresence(String toDeviceId, bool isOnline) async {
    await sendSignal(SignalingMessage(
      from: _deviceId,
      to: toDeviceId,
      type: SignalType.presence,
      data: {'online': isOnline},
    ));
  }

  /// Envoie un signal "en train d'écrire"
  Future<void> sendTyping(String toDeviceId, bool isTyping) async {
    await sendSignal(SignalingMessage(
      from: _deviceId,
      to: toDeviceId,
      type: SignalType.typing,
      data: {'typing': isTyping},
    ));
  }

  /// Met à jour la présence de l'utilisateur dans la table users
  Future<void> _updateUserPresence(bool isOnline) async {
    await _supabase.from('users').upsert({
      'device_id': _deviceId,
      'last_seen': DateTime.now().toIso8601String(),
    });
  }

  /// Supprime un signal après lecture
  Future<void> _deleteSignal(int signalId) async {
    try {
      await _supabase.from('webrtc_signals').delete().eq('id', signalId);
    } catch (e) {
      // Ignore les erreurs de suppression
    }
  }

  /// Nettoie les signaux de plus de 5 minutes
  Future<void> _cleanOldSignals() async {
    final threshold = DateTime.now().subtract(const Duration(minutes: 5));
    await _supabase
        .from('webrtc_signals')
        .delete()
        .or('to_device.eq.$_deviceId,from_device.eq.$_deviceId')
        .lt('created_at', threshold.toIso8601String());
  }

  /// Ferme le service
  Future<void> dispose() async {
    await _updateUserPresence(false);
    await _channel?.unsubscribe();
    await _signalController.close();
  }
}
