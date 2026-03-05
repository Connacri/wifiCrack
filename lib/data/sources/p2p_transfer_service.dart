import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:path_provider/path_provider.dart';
import 'supabase_service.dart';

/// Service expert pour le transfert de fichiers P2P via WebRTC.
/// Implémente le cycle complet : Handshake, ICE Candidates et Chunking.
class P2PTransferService {
  final SupabaseService _supabase;
  final String myDeviceId;

  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  StreamSubscription? _signalSub;
  
  // Buffers pour la réception
  final Map<String, List<int>> _receivingBuffers = {};
  String? _currentReceivingFileName;

  // File d'attente des fichiers à envoyer
  final Map<String, List<String>> _pendingTransfers = {}; 

  P2PTransferService(this._supabase, this.myDeviceId) {
    _initSignalListener();
  }

  /// Écoute les signaux entrants (Offres, Réponses, ICE) via Supabase
  void _initSignalListener() {
    _signalSub = _supabase.getIncomingSignals(myDeviceId).listen((signals) {
      for (var signal in signals) {
        _handleIncomingSignal(signal['payload'], signal['from'] ?? "");
      }
    });
  }

  /// Gère les étapes du protocole WebRTC
  Future<void> _handleIncomingSignal(Map<String, dynamic> data, String fromId) async {
    final type = data['type'];
    
    if (type == 'offer') {
      await _handleOffer(data['sdp'], fromId);
    } else if (type == 'answer') {
      await _peerConnection?.setRemoteDescription(RTCSessionDescription(data['sdp'], 'answer'));
    } else if (type == 'candidate') {
      final candidate = RTCIceCandidate(data['candidate']['candidate'], data['candidate']['sdpMid'], data['candidate']['sdpMLineIndex']);
      await _peerConnection?.addCandidate(candidate);
    }
  }

  Future<void> queueFileForTransfer(String targetUserId, String filePath) async {
    _pendingTransfers.putIfAbsent(targetUserId, () => []).add(filePath);
    await _startConnection(targetUserId, isCaller: true);
  }

  Future<void> _startConnection(String targetUserId, {required bool isCaller}) async {
    final config = {
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
    };

    _peerConnection = await createPeerConnection(config);

    // Gestion des candidats ICE (Crucial pour passer les pare-feu)
    _peerConnection!.onIceCandidate = (candidate) {
      _supabase.sendP2PSignal(targetUserId, {
        'from': myDeviceId,
        'type': 'candidate',
        'candidate': candidate.toMap(),
      });
    };

    if (isCaller) {
      // Création du canal de données côté émetteur
      _dataChannel = await _peerConnection!.createDataChannel("sigma_transfer", RTCDataChannelInit());
      _setupDataChannel();

      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      
      await _supabase.sendP2PSignal(targetUserId, {
        'from': myDeviceId,
        'type': 'offer',
        'sdp': offer.sdp,
      });
    } else {
      // Côté récepteur : on attend le canal de données
      _peerConnection!.onDataChannel = (channel) {
        _dataChannel = channel;
        _setupDataChannel();
      };
    }
  }

  Future<void> _handleOffer(String sdp, String fromId) async {
    await _startConnection(fromId, isCaller: false);
    await _peerConnection!.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
    
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    
    await _supabase.sendP2PSignal(fromId, {
      'from': myDeviceId,
      'type': 'answer',
      'sdp': answer.sdp,
    });
  }

  void _setupDataChannel() {
    _dataChannel!.onDataChannelState = (state) {
      if (state == RTCDataChannelState.RTCDataChannelOpen) {
        _processQueue();
      }
    };

    _dataChannel!.onMessage = (message) {
      if (message.isBinary) {
        _receivingBuffers[_currentReceivingFileName!]?.addAll(message.binary);
      } else {
        final data = jsonDecode(message.text);
        if (data['type'] == 'meta') {
          _currentReceivingFileName = data['name'];
          _receivingBuffers[_currentReceivingFileName!] = [];
        } else if (data['type'] == 'end') {
          _saveReceivedFile(_currentReceivingFileName!);
        }
      }
    };
  }

  Future<void> _processQueue() async {
    for (var targetId in _pendingTransfers.keys) {
      final files = _pendingTransfers[targetId]!;
      for (var path in List.from(files)) {
        await _sendFile(path);
        files.remove(path);
      }
    }
  }

  Future<void> _sendFile(String path) async {
    if (_dataChannel?.state != RTCDataChannelState.RTCDataChannelOpen) return;

    final file = File(path);
    final bytes = await file.readAsBytes();
    final name = path.split('/').last;

    _dataChannel!.send(RTCDataChannelMessage(jsonEncode({'type': 'meta', 'name': name})));

    const chunkSize = 16000; // Chunk de sécurité pour WebRTC
    for (var i = 0; i < bytes.length; i += chunkSize) {
      final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      _dataChannel!.send(RTCDataChannelMessage.fromBinary(bytes.sublist(i, end)));
    }

    _dataChannel!.send(RTCDataChannelMessage(jsonEncode({'type': 'end'})));
  }

  Future<void> _saveReceivedFile(String name) async {
    final bytes = _receivingBuffers[name];
    if (bytes == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    
    _receivingBuffers.remove(name);
    debugPrint("✅ Fichier P2P reçu et sauvegardé : ${file.path}");
  }

  void dispose() {
    _signalSub?.cancel();
    _dataChannel?.close();
    _peerConnection?.dispose();
  }
}
