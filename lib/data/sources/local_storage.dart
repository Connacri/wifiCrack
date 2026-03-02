import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wifi_network_model.dart';
import '../../domain/entities/wifi_network.dart';

/// Source de données locale experte pour la gestion de l'historique WiFi.
/// Implémente un cache en mémoire pour optimiser les performances de lecture.
class LocalStorageDataSource {
  static const String _networksKey = 'wifi_networks_history';
  static const String _deviceIdKey = 'sigma_device_id';
  
  late final SharedPreferences _prefs;
  
  // Cache en mémoire pour éviter les accès disque et le décodage JSON répétitifs
  List<WiFiNetwork> _cache = [];
  bool _isInitialized = false;

  /// Initialise SharedPreferences et charge le cache initial
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      
      final jsonString = _prefs.getString(_networksKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _cache = jsonList
            .map<WiFiNetwork>((json) => WiFiNetworkModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _cache = [];
      }
      
      _isInitialized = true;
      debugPrint("📦 LocalStorage: Initialisé avec ${_cache.length} réseaux en cache.");
    } catch (e) {
      debugPrint("❌ LocalStorage Init Error: $e");
      _cache = [];
    }
  }

  /// Sauvegarde ou met à jour un réseau.
  Future<void> saveNetwork(WiFiNetwork network) async {
    try {
      final index = _cache.indexWhere((n) => n.ssid == network.ssid);

      if (index != -1) {
        _cache[index] = network.copyWith(
          lastConnectionAttempt: _cache[index].lastConnectionAttempt,
          lastConnectionSuccess: _cache[index].lastConnectionSuccess,
        );
      } else {
        _cache.add(network);
      }

      _cache.sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
      await _persist();
    } catch (e) {
      debugPrint("❌ LocalStorage Save Error: $e");
    }
  }

  List<WiFiNetwork> getAllNetworks() {
    return List.unmodifiable(_cache);
  }

  Future<void> updateConnectionStatus(String ssid, bool success) async {
    try {
      final index = _cache.indexWhere((n) => n.ssid == ssid);
      if (index != -1) {
        _cache[index] = _cache[index].copyWith(
          lastConnectionAttempt: DateTime.now(),
          lastConnectionSuccess: success,
        );
        await _persist();
      }
    } catch (e) {
      debugPrint("❌ LocalStorage Update Error: $e");
    }
  }

  Future<void> cleanOldNetworks(int daysOld) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final originalSize = _cache.length;
      _cache.removeWhere((n) => n.lastSeen.isBefore(cutoffDate));
      if (_cache.length != originalSize) {
        await _persist();
      }
    } catch (e) {
      debugPrint("❌ LocalStorage Clean Error: $e");
    }
  }

  /// Gestion de l'ID Unique de l'appareil
  String? getDeviceId() {
    return _prefs.getString(_deviceIdKey);
  }

  Future<void> saveDeviceId(String id) async {
    await _prefs.setString(_deviceIdKey, id);
  }

  String? getPseudo() {
    return _prefs.getString('sigma_user_pseudo');
  }

  Future<void> savePseudo(String pseudo) async {
    await _prefs.setString('sigma_user_pseudo', pseudo);
  }

  Future<void> _persist() async {
    try {
      final jsonList = _cache
          .map((n) => WiFiNetworkModel.fromEntity(n).toJson())
          .toList();
      await _prefs.setString(_networksKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint("❌ LocalStorage Persistence Error: $e");
    }
  }
}
