import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../data/sources/supabase_service.dart';

/// États possibles de la connexion WebRTC
enum WebRTCState { idle, connecting, connected, disconnected, failed }

class WebRTCService {
  final SupabaseService _supabaseService;
  final String _deviceId;
  final String _friendDeviceId;

  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  StreamSubscription? _signalSubscription;

  /// Set des signaux déjà traités pour éviter les doublons
  final Set<String> _processedSignalIds = {};

  WebRTCState _state = WebRTCState.idle;
  WebRTCState get state => _state;

  // ─── Callbacks ────────────────────────────────────────────────────────────
  Function(String content)? onMessageReceived;
  Function(String voiceUrl)? onVoiceReceived;
  Function(WebRTCState state)? onStateChanged;

  WebRTCService({
    required SupabaseService supabaseService,
    required String deviceId,
    required String friendDeviceId,
  })  : _supabaseService = supabaseService,
        _deviceId = deviceId,
        _friendDeviceId = friendDeviceId;

  /// L'initiateur est déterminé de façon déterministe par comparaison lexicographique.
  /// Cela garantit qu'UN SEUL côté crée l'offre, sans coordination supplémentaire.
  bool get _isInitiator => _deviceId.compareTo(_friendDeviceId) > 0;

  // ─── Initialisation ───────────────────────────────────────────────────────
  Future<void> initialize() async {
    _setState(WebRTCState.connecting);

    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
        // TURN server recommandé en production pour les réseaux restrictifs
        // {'urls': 'turn:your-turn.server:3478', 'username': 'user', 'credential': 'pass'},
      ],
      'sdpSemantics': 'unified-plan',
    });

    _setupPeerConnectionCallbacks();
    _listenToIncomingSignals();

    // L'initiateur crée le data channel ET envoie l'offre
    if (_isInitiator) {
      await _createDataChannelAndOffer();
    }
    // L'autre côté attend l'offre dans _listenToIncomingSignals
  }

  void _setupPeerConnectionCallbacks() {
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate?.isNotEmpty == true) {
        _sendSignal('candidate', {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      debugPrint('[WebRTC] ICE state: $state');
      switch (state) {
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
        case RTCIceConnectionState.RTCIceConnectionStateCompleted:
          _setState(WebRTCState.connected);
          break;
        case RTCIceConnectionState.RTCIceConnectionStateFailed:
          _setState(WebRTCState.failed);
          break;
        case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
          _setState(WebRTCState.disconnected);
          break;
        default:
          break;
      }
    };

    // Le non-initiateur reçoit le data channel via cet événement
    _peerConnection!.onDataChannel = (RTCDataChannel channel) {
      _dataChannel = channel;
      _setupDataChannelCallbacks();
      debugPrint('[WebRTC] DataChannel reçu: ${channel.label}');
    };
  }

  Future<void> _createDataChannelAndOffer() async {
    // Créer le DataChannel côté initiateur
    final dcInit = RTCDataChannelInit()
      ..ordered = true
      ..maxRetransmits = 3;

    _dataChannel = await _peerConnection!.createDataChannel('chat', dcInit);
    _setupDataChannelCallbacks();

    // Créer et envoyer l'offre
    final offer = await _peerConnection!.createOffer({
      'offerToReceiveAudio': false,
      'offerToReceiveVideo': false,
    });
    await _peerConnection!.setLocalDescription(offer);

    await _sendSignal('offer', {'sdp': offer.sdp, 'type': offer.type});
    debugPrint('[WebRTC] Offre envoyée');
  }

  void _setupDataChannelCallbacks() {
    _dataChannel!.onDataChannelState = (RTCDataChannelState state) {
      debugPrint('[WebRTC] DataChannel state: $state');
    };

    _dataChannel!.onMessage = (RTCDataChannelMessage message) {
      if (message.isBinary) return; // Non géré dans cette version

      try {
        final decoded = jsonDecode(message.text) as Map<String, dynamic>;
        final type = decoded['type'] as String?;

        if (type == 'text') {
          onMessageReceived?.call(decoded['content'] as String);
        } else if (type == 'voice') {
          onVoiceReceived?.call(decoded['url'] as String);
        }
      } catch (_) {
        // Fallback: traiter comme texte brut
        onMessageReceived?.call(message.text);
      }
    };
  }

  // ─── Signaux entrants ──────────────────────────────────────────────────────
  void _listenToIncomingSignals() {
    _signalSubscription = _supabaseService
        .getIncomingSignals(_deviceId)
        .listen((signals) async {
      for (final signal in signals) {
        final signalId = signal['id']?.toString() ?? '';
        
        // Déduplication: ignorer les signaux déjà traités
        if (_processedSignalIds.contains(signalId)) continue;
        if (signalId.isNotEmpty) _processedSignalIds.add(signalId);

        final payload = signal['payload'] as Map<String, dynamic>?;
        if (payload == null) continue;

        // Filtrer: traiter uniquement les signaux de notre ami
        final senderId = payload['senderId'] as String?;
        if (senderId != _friendDeviceId) continue;

        final type = payload['type'] as String?;
        final data = payload['data'] as Map<String, dynamic>?;
        if (type == null || data == null) continue;

        try {
          switch (type) {
            case 'offer':
              await _handleOffer(data);
              break;
            case 'answer':
              await _handleAnswer(data);
              break;
            case 'candidate':
              await _handleCandidate(data);
              break;
          }
        } catch (e) {
          debugPrint('[WebRTC] Erreur traitement signal $type: $e');
        }
      }
    });
  }

  Future<void> _handleOffer(Map<String, dynamic> data) async {
    if (_peerConnection == null) return;

    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(data['sdp'] as String?, data['type'] as String?),
    );

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    await _sendSignal('answer', {'sdp': answer.sdp, 'type': answer.type});
    debugPrint('[WebRTC] Réponse envoyée');
  }

  Future<void> _handleAnswer(Map<String, dynamic> data) async {
    if (_peerConnection == null) return;
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(data['sdp'] as String?, data['type'] as String?),
    );
    debugPrint('[WebRTC] Réponse reçue, connexion en cours...');
  }

  Future<void> _handleCandidate(Map<String, dynamic> data) async {
    if (_peerConnection == null) return;
    await _peerConnection!.addCandidate(
      RTCIceCandidate(
        data['candidate'] as String?,
        data['sdpMid'] as String?,
        data['sdpMLineIndex'] as int?,
      ),
    );
  }

  // ─── Envoi de messages ────────────────────────────────────────────────────
  Future<bool> sendMessage(String text) async {
    if (!_isDataChannelReady) {
      debugPrint('[WebRTC] DataChannel non prêt');
      return false;
    }
    final msg = jsonEncode({'type': 'text', 'content': text});
    await _dataChannel!.send(RTCDataChannelMessage(msg));
    return true;
  }

  Future<bool> sendVoiceMessage(String localPath) async {
    if (!_isDataChannelReady) return false;
    final msg = jsonEncode({'type': 'voice', 'url': localPath});
    await _dataChannel!.send(RTCDataChannelMessage(msg));
    return true;
  }

  bool get _isDataChannelReady =>
      _dataChannel != null &&
      _dataChannel!.state == RTCDataChannelState.RTCDataChannelOpen;

  // ─── Envoi de signal (via Supabase) ───────────────────────────────────────
  Future<void> _sendSignal(String type, Map<String, dynamic> data) async {
    await _supabaseService.sendP2PSignal(
      _friendDeviceId,
      {
        'senderId': _deviceId,
        'type': type,
        'data': data,
      },
    );
  }

  void _setState(WebRTCState newState) {
    _state = newState;
    onStateChanged?.call(newState);
  }

  // ─── Dispose ──────────────────────────────────────────────────────────────
  Future<void> dispose() async {
    await _signalSubscription?.cancel();
    _signalSubscription = null;

    await _dataChannel?.close();
    _dataChannel = null;

    await _peerConnection?.close();
    _peerConnection = null;

    _processedSignalIds.clear();
    _setState(WebRTCState.idle);
    debugPrint('[WebRTC] Ressources libérées');
  }
}
