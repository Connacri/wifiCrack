import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signaling_service.dart';
import 'dart:convert';


/// Gère une connexion WebRTC peer-to-peer avec un contact
class PeerConnection {
  final String peerId;
  final RTCPeerConnection pc;
  final RTCDataChannel dataChannel;
  final StreamController<Map<String, dynamic>> _messageController;
  
  bool isConnected = false;
  DateTime? lastActivity;

  PeerConnection({
    required this.peerId,
    required this.pc,
    required this.dataChannel,
    required StreamController<Map<String, dynamic>> messageController,
  }) : _messageController = messageController;

  Stream<Map<String, dynamic>> get onMessage => _messageController.stream;

  /// Envoie des données via le data channel
  Future<void> sendData(Map<String, dynamic> data) async {
    if (!isConnected || dataChannel.state != RTCDataChannelState.RTCDataChannelOpen) {
      throw Exception('Data channel non connecté');
    }
    
    final message = RTCDataChannelMessage(jsonEncode(data));
    dataChannel.send(message);
    lastActivity = DateTime.now();
  }

  /// Ferme la connexion
  Future<void> close() async {
    await dataChannel.close();
    await pc.close();
    await _messageController.close();
  }
}

/// Service principal WebRTC gérant toutes les connexions P2P
class WebRTCService {
  final SignalingService _signaling;
  final Map<String, PeerConnection> _peers = {};
  final Map<String, List<RTCIceCandidate>> _pendingCandidates = {};
  
  static const _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
      {'urls': 'stun:stun2.l.google.com:19302'},
      {'urls': 'stun:stun.stunprotocol.org:3478'},
    ],
    'iceCandidatePoolSize': 10,
  };

  final _connectionStateController = StreamController<Map<String, bool>>.broadcast();
  Stream<Map<String, bool>> get onConnectionStateChange => _connectionStateController.stream;

  WebRTCService(this._signaling) {
    _signaling.onSignal.listen(_handleSignal);
    
    // Vérifier les connexions toutes les 30 secondes
    Timer.periodic(const Duration(seconds: 30), (_) => _checkConnections());
  }

  /// Initie une connexion avec un peer
  Future<void> connectToPeer(String peerId) async {
    if (_peers.containsKey(peerId)) {
      return; // Déjà connecté
    }

    final pc = await _createPeerConnection(peerId);
    final dataChannel = await pc.createDataChannel(
      'messages',
      RTCDataChannelInit()..ordered = true,
    );

    final messageController = StreamController<Map<String, dynamic>>.broadcast();
    final peer = PeerConnection(
      peerId: peerId,
      pc: pc,
      dataChannel: dataChannel,
      messageController: messageController,
    );

    _setupDataChannel(peer);
    _peers[peerId] = peer;

    // Créer et envoyer l'offre
    final offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    await _signaling.sendOffer(peerId, offer);
  }

  /// Envoie un message à un peer
  Future<void> sendMessage(String peerId, Map<String, dynamic> message) async {
    final peer = _peers[peerId];
    if (peer == null || !peer.isConnected) {
      throw Exception('Peer non connecté: $peerId');
    }

    await peer.sendData(message);
  }

  /// Récupère le stream de messages d'un peer
  Stream<Map<String, dynamic>>? getMessageStream(String peerId) {
    return _peers[peerId]?.onMessage;
  }

  /// Vérifie si un peer est connecté
  bool isPeerConnected(String peerId) {
    return _peers[peerId]?.isConnected ?? false;
  }

  /// Déconnecte un peer
  Future<void> disconnectPeer(String peerId) async {
    final peer = _peers.remove(peerId);
    if (peer != null) {
      await peer.close();
      _notifyConnectionState(peerId, false);
    }
  }

  // === Gestion des signaux ===

  Future<void> _handleSignal(SignalingMessage signal) async {
    switch (signal.type) {
      case SignalType.offer:
        await _handleOffer(signal.from, signal.data);
        break;
      case SignalType.answer:
        await _handleAnswer(signal.from, signal.data);
        break;
      case SignalType.iceCandidate:
        await _handleIceCandidate(signal.from, signal.data);
        break;
      default:
        break;
    }
  }

  Future<void> _handleOffer(String peerId, Map<String, dynamic> data) async {
    final pc = await _createPeerConnection(peerId);
    
    final offer = RTCSessionDescription(data['sdp'], data['type']);
    await pc.setRemoteDescription(offer);

    // Créer la réponse
    final answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);
    await _signaling.sendAnswer(peerId, answer);

    // Configurer le data channel (sera créé par l'offrant)
    pc.onDataChannel = (channel) {
      final messageController = StreamController<Map<String, dynamic>>.broadcast();
      final peer = PeerConnection(
        peerId: peerId,
        pc: pc,
        dataChannel: channel,
        messageController: messageController,
      );
      _setupDataChannel(peer);
      _peers[peerId] = peer;
    };

    // Ajouter les candidats en attente
    if (_pendingCandidates.containsKey(peerId)) {
      for (final candidate in _pendingCandidates[peerId]!) {
        await pc.addCandidate(candidate);
      }
      _pendingCandidates.remove(peerId);
    }
  }

  Future<void> _handleAnswer(String peerId, Map<String, dynamic> data) async {
    final peer = _peers[peerId];
    if (peer == null) return;

    final answer = RTCSessionDescription(data['sdp'], data['type']);
    await peer.pc.setRemoteDescription(answer);

    // Ajouter les candidats en attente
    if (_pendingCandidates.containsKey(peerId)) {
      for (final candidate in _pendingCandidates[peerId]!) {
        await peer.pc.addCandidate(candidate);
      }
      _pendingCandidates.remove(peerId);
    }
  }

  Future<void> _handleIceCandidate(String peerId, Map<String, dynamic> data) async {
    final candidate = RTCIceCandidate(
      data['candidate'],
      data['sdpMid'],
      data['sdpMLineIndex'],
    );

    final peer = _peers[peerId];
    if (peer != null && peer.pc.signalingState != RTCSignalingState.RTCSignalingStateStable) {
      // Mettre en attente si la connexion n'est pas stable
      _pendingCandidates.putIfAbsent(peerId, () => []).add(candidate);
    } else if (peer != null) {
      await peer.pc.addCandidate(candidate);
    }
  }

  // === Création et configuration ===

  Future<RTCPeerConnection> _createPeerConnection(String peerId) async {
    final pc = await createPeerConnection(_configuration);

    pc.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        _signaling.sendIceCandidate(peerId, candidate);
      }
    };

    pc.onConnectionState = (state) {
      final isConnected = state == RTCPeerConnectionState.RTCPeerConnectionStateConnected;
      final peer = _peers[peerId];
      if (peer != null) {
        peer.isConnected = isConnected;
        _notifyConnectionState(peerId, isConnected);
      }

      // Nettoyer si déconnecté
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        disconnectPeer(peerId);
      }
    };

    return pc;
  }

  void _setupDataChannel(PeerConnection peer) {
    peer.dataChannel.onMessage = (message) {
      try {
        final data = jsonDecode(message.text) as Map<String, dynamic>;
        peer._messageController.add(data);
        peer.lastActivity = DateTime.now();
      } catch (e) {
        print('Erreur parsing message: $e');
      }
    };

    peer.dataChannel.onDataChannelState = (state) {
      peer.isConnected = state == RTCDataChannelState.RTCDataChannelOpen;
      _notifyConnectionState(peer.peerId, peer.isConnected);
    };
  }

  void _notifyConnectionState(String peerId, bool isConnected) {
    _connectionStateController.add({peerId: isConnected});
  }

  /// Vérifie et nettoie les connexions inactives
  void _checkConnections() {
    final now = DateTime.now();
    final toRemove = <String>[];

    for (final entry in _peers.entries) {
      final peer = entry.value;
      if (!peer.isConnected) {
        toRemove.add(entry.key);
      } else if (peer.lastActivity != null &&
          now.difference(peer.lastActivity!) > const Duration(minutes: 5)) {
        toRemove.add(entry.key);
      }
    }

    for (final peerId in toRemove) {
      disconnectPeer(peerId);
    }
  }

  /// Ferme toutes les connexions
  Future<void> dispose() async {
    for (final peer in _peers.values) {
      await peer.close();
    }
    _peers.clear();
    await _connectionStateController.close();
  }
}


