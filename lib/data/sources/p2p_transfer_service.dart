import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:path_provider/path_provider.dart';
import 'supabase_service.dart';

/// Service expert pour le transfert de fichiers P2P via WebRTC.
/// Implémente le cycle complet : Handshake, ICE Candidates et Chunking.
class P2PTransferService {
  final SupabaseService _supabase;
  final String myDeviceId;

  // Multi-connexions
  final Map<String, RTCPeerConnection> _peerConnections = {};
  final Map<String, RTCDataChannel> _dataChannels = {};
  
  StreamSubscription? _signalSub;
  
  // Buffers pour la réception par utilisateur
  final Map<String, Map<String, List<int>>> _receivingBuffers = {};
  final Map<String, String> _currentReceivingFileNames = {};
  final Map<String, List<RTCIceCandidate>> _pendingIceCandidates = {};
  final Map<String, String> _lastHandledOfferSdp = {};
  final Set<int> _processedSignalIds = {};

  // Files d'attente par utilisateur
  final Map<String, List<String>> _pendingTransfers = {}; 
  final Map<String, List<Map<String, dynamic>>> _pendingMessages = {};

  P2PTransferService(this._supabase, this.myDeviceId) {
    _initSignalListener();
  }

  void _initSignalListener() {
    debugPrint("📡 P2P: Initialisation de l'écouteur de signaux pour $myDeviceId");
    _signalSub = _supabase.getIncomingSignals(myDeviceId).listen(
      (signals) {
        debugPrint("📡 P2P: Flux reçu, nombre de signaux : ${signals.length}");
        for (var signal in signals) {
          try {
            final id = int.tryParse(signal['id']?.toString() ?? '');
            if (id != null && !_processedSignalIds.add(id)) {
              continue;
            }

            final payloadRaw = signal['payload'];
            if (payloadRaw is! Map) {
              continue;
            }

            final payload = Map<String, dynamic>.from(payloadRaw);
            final fromId =
                (payload['from'] ?? signal['from'] ?? signal['from_id'] ?? '')
                    .toString();
            if (fromId.isEmpty || fromId == myDeviceId) {
              continue;
            }

            unawaited(
              _handleIncomingSignal(payload, fromId).catchError((e) {
                debugPrint('❌ P2P signal handling error: $e');
              }),
            );
          } catch (e) {
            debugPrint('⚠️ P2P: signal ignoré (format invalide): $e');
          }
        }
      },
      onError: (e) {
        debugPrint('❌ P2P signal stream error: $e');
      },
    );
  }

  Future<void> _handleIncomingSignal(
    Map<String, dynamic> data,
    String fromId,
  ) async {
    final type = data['type'];

    if (type == 'offer') {
      await _handleOffer(data['sdp'], fromId);
    } else if (type == 'answer') {
      final pc = _peerConnections[fromId];
      if (pc == null) return;
      await pc.setRemoteDescription(
        RTCSessionDescription(data['sdp'], 'answer'),
      );
      await _flushPendingCandidates(fromId);
    } else if (type == 'candidate') {
      final c = data['candidate'];
      if (c is! Map) return;
      final sdpMLineIndex = int.tryParse(c['sdpMLineIndex']?.toString() ?? '');
      final candidate = RTCIceCandidate(
        c['candidate']?.toString(),
        c['sdpMid']?.toString(),
        sdpMLineIndex,
      );
      final pc = _peerConnections[fromId];
      if (pc == null) {
        _pendingIceCandidates.putIfAbsent(fromId, () => []).add(candidate);
        return;
      }
      await pc.addCandidate(candidate);
    }
  }

  Future<void> queueFileForTransfer(String targetUserId, String filePath) async {
    _pendingTransfers.putIfAbsent(targetUserId, () => []).add(filePath);
    if (_dataChannels[targetUserId]?.state == RTCDataChannelState.RTCDataChannelOpen) {
      _processQueue(targetUserId);
    } else {
      await _startConnection(targetUserId, isCaller: true);
    }
  }

  Future<void> _startConnection(String targetUserId, {required bool isCaller}) async {
    final existingPc = _peerConnections[targetUserId];
    final existingChannel = _dataChannels[targetUserId];
    final channelState = existingChannel?.state;
    if (existingPc != null) {
      if (!isCaller) {
        return;
      }
      if (channelState == RTCDataChannelState.RTCDataChannelOpen ||
          channelState == RTCDataChannelState.RTCDataChannelConnecting) {
        return;
      }
      await _cleanupPeer(targetUserId);
    }

    final config = {
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
    };

    final pc = await createPeerConnection(config);
    _peerConnections[targetUserId] = pc;

    pc.onIceCandidate = (candidate) {
      if (candidate.candidate == null || candidate.candidate!.isEmpty) return;
      _supabase.sendP2PSignal(targetUserId, {
        'from': myDeviceId,
        'type': 'candidate',
        'candidate': candidate.toMap(),
      });
    };

    pc.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateClosed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        _cleanupPeer(targetUserId);
      }
    };

    if (isCaller) {
      final channel = await pc.createDataChannel("sigma_transfer", RTCDataChannelInit());
      _dataChannels[targetUserId] = channel;
      _setupDataChannel(targetUserId, channel);

      final offer = await pc.createOffer();
      await pc.setLocalDescription(offer);
      
      await _supabase.sendP2PSignal(targetUserId, {
        'from': myDeviceId,
        'type': 'offer',
        'sdp': offer.sdp,
      });
    } else {
      pc.onDataChannel = (channel) {
        _dataChannels[targetUserId] = channel;
        _setupDataChannel(targetUserId, channel);
      };
    }
  }

  Future<void> _handleOffer(dynamic sdpRaw, String fromId) async {
    final sdp = sdpRaw?.toString() ?? '';
    if (sdp.isEmpty) return;
    if (_lastHandledOfferSdp[fromId] == sdp) return;

    await _startConnection(fromId, isCaller: false);
    final pc = _peerConnections[fromId];
    if (pc == null) return;

    try {
      await pc.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('wrong state: stable')) {
        debugPrint('⚠️ P2P: offer dupliquée ignorée pour $fromId');
        _lastHandledOfferSdp[fromId] = sdp;
        return;
      }
      rethrow;
    }

    await _flushPendingCandidates(fromId);

    final answer = await pc.createAnswer();
    try {
      await pc.setLocalDescription(answer);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('wrong state: stable')) {
        debugPrint('⚠️ P2P: answer déjà appliquée pour $fromId');
        _lastHandledOfferSdp[fromId] = sdp;
        return;
      }
      rethrow;
    }

    _lastHandledOfferSdp[fromId] = sdp;
    await _supabase.sendP2PSignal(fromId, {
      'from': myDeviceId,
      'type': 'answer',
      'sdp': answer.sdp,
    });
  }

  Future<void> _flushPendingCandidates(String peerId) async {
    final pending = _pendingIceCandidates[peerId];
    if (pending == null || pending.isEmpty) return;
    final pc = _peerConnections[peerId];
    if (pc == null) return;

    for (final candidate in List<RTCIceCandidate>.from(pending)) {
      await pc.addCandidate(candidate);
      pending.remove(candidate);
    }
  }

  Future<void> _cleanupPeer(String peerId) async {
    final channel = _dataChannels.remove(peerId);
    try {
      await channel?.close();
    } catch (_) {}

    final pc = _peerConnections.remove(peerId);
    try {
      await pc?.close();
      await pc?.dispose();
    } catch (_) {}

    _pendingIceCandidates.remove(peerId);
    _lastHandledOfferSdp.remove(peerId);
  }

  Future<void> sendVocalP2P(String targetUserId, String filePath) async {
    debugPrint("🚀 P2P: Préparation de l'envoi vocal direct vers $targetUserId");
    await queueFileForTransfer(targetUserId, filePath);
  }

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  Future<void> sendJson(String targetUserId, Map<String, dynamic> data) async {
    _pendingMessages.putIfAbsent(targetUserId, () => []).add(data);
    
    if (_dataChannels[targetUserId]?.state == RTCDataChannelState.RTCDataChannelOpen) {
      _processMessageQueue(targetUserId);
    } else {
      await _startConnection(targetUserId, isCaller: true);
    }
  }

  void _setupDataChannel(String targetUserId, RTCDataChannel channel) {
    channel.onDataChannelState = (state) {
      debugPrint("📡 P2P [$targetUserId]: État du canal = $state");
      if (state == RTCDataChannelState.RTCDataChannelOpen) {
        _processQueue(targetUserId);
        _processMessageQueue(targetUserId);
      }
    };

    channel.onMessage = (message) {
      if (message.isBinary) {
        final fileName = _currentReceivingFileNames[targetUserId];
        if (fileName != null) {
          _receivingBuffers[targetUserId]?[fileName]?.addAll(message.binary);
        }
      } else {
        try {
          final data = jsonDecode(message.text);
          if (data['type'] == 'meta') {
            final fileName = data['name'];
            _currentReceivingFileNames[targetUserId] = fileName;
            _receivingBuffers.putIfAbsent(targetUserId, () => {})[fileName] = [];
            debugPrint("📥 P2P [$targetUserId]: Réception de $fileName...");
          } else if (data['type'] == 'end') {
            final fileName = _currentReceivingFileNames[targetUserId];
            if (fileName != null) _saveReceivedFile(targetUserId, fileName);
          } else {
             // Message standard
             data['user_id'] = targetUserId; // Assurer la provenance
             _messageController.add(data);
             debugPrint("📨 P2P [$targetUserId]: Message reçu: ${data['content']}");
          }
        } catch (e) {
          debugPrint("⚠️ P2P: Erreur parsing JSON: $e");
        }
      }
    };
  }

  void _processMessageQueue(String targetUserId) {
    final channel = _dataChannels[targetUserId];
    if (channel?.state != RTCDataChannelState.RTCDataChannelOpen) return;
    
    final queue = _pendingMessages[targetUserId];
    if (queue == null) return;

    for (var msg in List.from(queue)) {
      channel!.send(RTCDataChannelMessage(jsonEncode(msg)));
      queue.remove(msg);
    }
  }

  void _processQueue(String targetUserId) {
    final queue = _pendingTransfers[targetUserId];
    if (queue == null) return;

    for (var path in List.from(queue)) {
      _sendFile(targetUserId, path);
      queue.remove(path);
    }
  }

  Future<void> _sendFile(String targetUserId, String path) async {
    final channel = _dataChannels[targetUserId];
    if (channel?.state != RTCDataChannelState.RTCDataChannelOpen) return;

    final file = File(path);
    final bytes = await file.readAsBytes();
    final name = path.split(RegExp(r'[\\/]')).last;

    channel!.send(RTCDataChannelMessage(jsonEncode({'type': 'meta', 'name': name})));

    const chunkSize = 16000;
    for (var i = 0; i < bytes.length; i += chunkSize) {
      final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      channel.send(RTCDataChannelMessage.fromBinary(bytes.sublist(i, end)));
    }

    channel.send(RTCDataChannelMessage(jsonEncode({'type': 'end'})));
  }

  Future<void> _saveReceivedFile(String targetUserId, String name) async {
    final bytes = _receivingBuffers[targetUserId]?[name];
    if (bytes == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    
    _receivingBuffers[targetUserId]?.remove(name);
    debugPrint("✅ Fichier P2P de $targetUserId reçu : ${file.path}");
  }

  void dispose() {
    _signalSub?.cancel();
    for (var channel in _dataChannels.values) {
      channel.close();
    }
    for (var pc in _peerConnections.values) {
      pc.dispose();
    }
    _messageController.close();
  }
}
