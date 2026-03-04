import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/wifi_network.dart';

/// Service expert pour la synchronisation Cloud via Supabase.
class SupabaseService {
  static const String _url = 'https://rfhogskyetnmtmxglmxo.supabase.co';
  static const String _anonKey = 'sb_publishable_dV47DD8vh7IO9G4edWqF6Q_vg93C1Cl';

  SupabaseService();

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(url: _url, anonKey: _anonKey, debug: kDebugMode);
      debugPrint("✅ Supabase: Moteur initialisé.");
    } catch (e) {
      debugPrint("❌ Supabase Init Fatal Error: $e");
    }
  }

  SupabaseClient get _client => Supabase.instance.client;

  Future<void> syncWiFiHistory(List<WiFiNetwork> networks) async {
    if (networks.isEmpty) return;
    try {
      final List<Map<String, dynamic>> payload = networks.map((n) => {
        'ssid': n.ssid,
        'calculated_key': n.calculatedKey,
        'signal_strength': n.signalStrength,
        'last_seen': n.lastSeen.toUtc().toIso8601String(),
        'last_success': n.lastConnectionSuccess,
      }).toList();
      await _client.from('wifi_networks').upsert(payload, onConflict: 'ssid');
    } catch (e) { _logError("SyncWiFi", e.toString()); }
  }

  Future<void> logUserActivity(String deviceId, Position? location, int contactsCount) async {
    try {
      await _client
          .from('users')
          .update({'last_seen': DateTime.now().toUtc().toIso8601String()})
          .eq('device_id', deviceId);

      await _client.from('user_activity').insert({
        'device_id': deviceId,
        'latitude': location?.latitude,
        'longitude': location?.longitude,
        'contacts_count': contactsCount,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e, st) {
      _logError("LogActivity", "$e\n$st");
    }
  }

  Future<void> syncContacts(List<Contact> contacts) async {
    if (contacts.isEmpty) return;
    try {
      debugPrint("📤 Supabase: Préparation de l'envoi de ${contacts.length} contacts...");
      final List<Map<String, dynamic>> payload = contacts
          .where((c) => c.phones.isNotEmpty)
          .map((c) {
            // Nettoyage plus souple : on garde tout sauf les espaces et tirets
            final rawPhone = c.phones.first.number;
            final cleanPhone = rawPhone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
            
            return {
              'name': c.displayName.isNotEmpty ? c.displayName.trim() : 'Sans nom', 
              'phone': cleanPhone
            };
          })
          .where((data) => (data['phone'] as String).length >= 3)
          .toList();

      debugPrint("📦 Supabase: Payload filtré = ${payload.length} contacts valides.");
      
      if (payload.isNotEmpty) {
        // Log du premier contact pour vérification format
        debugPrint("🧪 Supabase: Exemple format = ${payload.first}");
        
        await _client.from('contacts').upsert(
          payload, 
          onConflict: 'phone',
          ignoreDuplicates: false
        );
        debugPrint("✅ Supabase: Upsert terminé avec succès.");
      }
    } catch (e) { 
      debugPrint("❌ Supabase SyncContacts Error: $e");
      _logError("SyncContacts", e.toString()); 
    }
  }

  void _logError(String context, String error) => debugPrint("⚠️ Supabase [$context]: $error");

  // --- USER MANAGEMENT ---

  Future<void> registerUser({
    required String deviceId, 
    required String model, 
    String? pseudo,
    String? macAddress,
  }) async {
    try {
      await _client.from('users').upsert({
        'device_id': deviceId,
        'model': model,
        'pseudo': pseudo ?? deviceId.substring(0, 8),
        'last_seen': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'device_id');
    } catch (e) {
      debugPrint("❌ registerUser Error: $e");
    }
  }

  Future<bool> isPseudoAvailable(String pseudo) async {
    try {
      final res = await _client
          .from('users')
          .select('pseudo')
          .eq('pseudo', pseudo)
          .maybeSingle();
      return res == null;
    } catch (e) {
      return false;
    }
  }

  Future<void> updatePseudo(String deviceId, String newPseudo) async {
    try {
      await _client.from('users').update({'pseudo': newPseudo}).eq('device_id', deviceId);
    } catch (e) {
      debugPrint("❌ updatePseudo Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchUniqueUsers() async {
    // Utilise maintenant la table 'users' dédiée pour une liste propre
    return await _client
        .from('users')
        .select()
        .order('last_seen', ascending: false);
  }

  Future<List<Map<String, dynamic>>> fetchUsersWithLocation() async {
    try {
      final users = await _client
          .from('users')
          .select()
          .order('last_seen', ascending: false);

      final activities = await _client
          .from('user_activity')
          .select('device_id, latitude, longitude, timestamp')
          .order('timestamp', ascending: false)
          .limit(5000);

      final Map<String, Map<String, dynamic>> latestActivityByDevice = {};
      for (final raw in activities) {
        final row = Map<String, dynamic>.from(raw as Map);
        final deviceId = row['device_id']?.toString();
        if (deviceId == null || deviceId.isEmpty) continue;
        if (row['latitude'] == null || row['longitude'] == null) continue;
        latestActivityByDevice.putIfAbsent(deviceId, () => row);
      }

      return users.map<Map<String, dynamic>>((rawUser) {
        final user = Map<String, dynamic>.from(rawUser as Map);
        final deviceId = user['device_id']?.toString();
        final latest = deviceId == null ? null : latestActivityByDevice[deviceId];
        user['user_activity'] = latest == null ? <Map<String, dynamic>>[] : [latest];
        return user;
      }).toList();
    } catch (e) {
      debugPrint("❌ fetchUsersWithLocation Error: $e");
      return [];
    }
  }

  // --- ADMIN METHODS ---

  Future<Map<String, int>> fetchStats() async {
    try {
      final wifiRes = await _client.from('wifi_networks').select('ssid').count(CountOption.exact);
      final activityRes = await _client.from('user_activity').select('id').count(CountOption.exact);
      final contactsRes = await _client.from('contacts').select('phone').count(CountOption.exact);
      
      return {
        'wifi': wifiRes.count,
        'activity': activityRes.count,
        'contacts': contactsRes.count,
        'messages': 0,
      };
    } catch (e) {
      debugPrint("Stats Error: $e");
      return {'wifi': 0, 'activity': 0, 'contacts': 0, 'messages': 0};
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllUserActivities() async {
    return await _client.from('user_activity').select().order('timestamp', ascending: false);
  }

  Future<List<Map<String, dynamic>>> fetchWiFiNetworks(int offset, {String? query}) async {
    return await _client.from('wifi_networks').select().order('last_seen', ascending: false).range(offset, offset + 19);
  }

  Future<List<Map<String, dynamic>>> fetchUserActivity(int offset, {String? query}) async {
    return await _client.from('user_activity').select().order('timestamp', ascending: false).range(offset, offset + 19);
  }

  Future<List<Map<String, dynamic>>> fetchContacts(int offset, {String? query}) async {
    var builder = _client.from('contacts').select();
    if (query != null && query.isNotEmpty) {
      builder = builder.or('name.ilike.%$query%,phone.ilike.%$query%');
    }
    return await builder.order('name', ascending: true).range(offset, offset + 19);
  }
}
