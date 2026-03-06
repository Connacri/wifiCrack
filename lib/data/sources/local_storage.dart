import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wifi_network_model.dart';
import '../../domain/entities/wifi_network.dart';

/// Local storage source for WiFi history with an in-memory cache.
class LocalStorageDataSource {
  static const String _networksKey = 'wifi_networks_history';
  static const String _deviceIdKey = 'sigma_device_id';

  SharedPreferences? _prefs;

  // In-memory cache to avoid repetitive disk access and JSON decoding.
  List<WiFiNetwork> _cache = [];
  bool _isInitialized = false;

  /// Initializes SharedPreferences and hydrates the initial cache.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      if (_prefs == null) return;

      final jsonString = _prefs!.getString(_networksKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _cache = jsonList
            .map<WiFiNetwork>(
              (json) => WiFiNetworkModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        _cache = [];
      }

      _isInitialized = true;
      debugPrint(
        'LocalStorage initialized with ${_cache.length} cached networks.',
      );
    } catch (e) {
      debugPrint('LocalStorage init error: $e');
      _cache = [];
    }
  }

  /// Saves or updates a network.
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
      debugPrint('LocalStorage save error: $e');
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
      debugPrint('LocalStorage update error: $e');
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
      debugPrint('LocalStorage clean error: $e');
    }
  }

  /// Device ID management.
  String? getDeviceId() {
    return _prefs?.getString(_deviceIdKey);
  }

  Future<void> saveDeviceId(String id) async {
    if (!_isInitialized || _prefs == null) {
      await initialize();
    }
    await _prefs?.setString(_deviceIdKey, id);
  }

  /// Admin Session management.
  bool isAdminLoggedIn() {
    return _prefs?.getBool('sigma_admin_logged_in') ?? false;
  }

  Future<void> setAdminLoggedIn(bool value) async {
    if (!_isInitialized || _prefs == null) {
      await initialize();
    }
    await _prefs?.setBool('sigma_admin_logged_in', value);
  }

  String? getPseudo() {
    return _prefs?.getString('sigma_user_pseudo');
  }

  Future<void> savePseudo(String pseudo) async {
    if (!_isInitialized || _prefs == null) {
      await initialize();
    }
    await _prefs?.setString('sigma_user_pseudo', pseudo);
  }

  Future<void> _persist() async {
    try {
      if (!_isInitialized || _prefs == null) {
        await initialize();
      }
      if (_prefs == null) return;

      final jsonList =
          _cache.map((n) => WiFiNetworkModel.fromEntity(n).toJson()).toList();
      await _prefs!.setString(_networksKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('LocalStorage persistence error: $e');
    }
  }
}
