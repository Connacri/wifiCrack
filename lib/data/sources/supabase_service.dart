import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/wifi_network.dart';

/// Service expert pour la synchronisation Cloud via Supabase.
/// Corrigé pour Supabase Flutter 2.x (Syntaxe count et select).
class SupabaseService {
  static const String supabaseUrl = 'https://rfhogskyetnmtmxglmxo.supabase.co';
  // Publishable key for DB usage.
  static const String supabaseAnonKey =
      'sb_publishable_dV47DD8vh7IO9G4edWqF6Q_vg93C1Cl';
  // Legacy anon JWT required for Storage API.
  static const String storageAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJmaG9nc2t5ZXRubXRteGdsbXhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIyODYzOTksImV4cCI6MjA4Nzg2MjM5OX0.XYlBK2ym8FmmotY7oFP0_G7XJvrPCi1j44m1tyfGcJA';
  static const String storageBaseUrl = '$supabaseUrl/storage/v1';

  SupabaseService();

  static Future<void> initialize() async {
    try {
      debugPrint(
        '✅ Supabase init: url=$supabaseUrl '
        'anonKey=${_maskKey(supabaseAnonKey)}',
      );
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      debugPrint("✅ Supabase: Moteur initialisé.");
    } catch (e) {
      debugPrint("❌ Supabase Init Error: $e");
    }

    // Always ensure headers are present (even if already initialized).
    ensureClientHeaders();
    final client = Supabase.instance.client;
    debugPrint(
      '✅ Supabase headers: client=${client.headers.keys.toList()} '
      'storage=${client.storage.headers.keys.toList()}',
    );
  }

  static void ensureClientHeaders({String? accessToken}) {
    try {
      final client = Supabase.instance.client;
      final token = accessToken ?? client.auth.currentSession?.accessToken;
      client.headers['apikey'] = supabaseAnonKey;
      if (token != null && token.contains('.')) {
        client.headers['Authorization'] = 'Bearer $token';
      } else {
        client.headers.remove('Authorization');
      }
    } catch (e) {
      debugPrint('⚠️ Supabase ensure headers failed: $e');
    }
  }

  static Map<String, String> _storageHeaders() => {
    'apikey': storageAnonKey,
    'Authorization': 'Bearer $storageAnonKey',
  };

  static Future<void> storageUploadBinary({
    required String bucket,
    required String path,
    required Uint8List bytes,
    required String contentType,
    bool upsert = true,
  }) async {
    final uri = Uri.parse('$storageBaseUrl/object/$bucket/$path');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_storageHeaders())
      ..headers['x-upsert'] = upsert.toString()
      ..fields['cacheControl'] = '3600'
      ..files.add(
        http.MultipartFile.fromBytes(
          '',
          bytes,
          filename: '',
          contentType: MediaType.parse(contentType),
        ),
      );

    final response = await request.send();
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw Exception(
        'Storage upload failed (${response.statusCode}): $body',
      );
    }
  }

  static Future<void> storageRemove({
    required String bucket,
    required List<String> paths,
  }) async {
    final uri = Uri.parse('$storageBaseUrl/object/$bucket');
    final resp = await http.delete(
      uri,
      headers: {
        ..._storageHeaders(),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'prefixes': paths}),
    );
    if (resp.statusCode < 200 || resp.statusCode > 299) {
      throw Exception(
        'Storage delete failed (${resp.statusCode}): ${resp.body}',
      );
    }
  }

  static Future<void> storageCheckBucket(String bucket) async {
    final uri = Uri.parse('$storageBaseUrl/bucket/$bucket');
    final resp = await http.get(uri, headers: _storageHeaders());
    if (resp.statusCode < 200 || resp.statusCode > 299) {
      throw Exception(
        'Storage bucket check failed (${resp.statusCode}): ${resp.body}',
      );
    }
  }

  static String _maskKey(String? key) {
    if (key == null || key.isEmpty) return '<empty>';
    var value = key;
    if (value.startsWith('Bearer ')) {
      value = value.substring('Bearer '.length);
    }
    if (value.length <= 12)
      return '${value.substring(0, value.length)}(len=${value.length})';
    final prefix = value.substring(0, 12);
    final suffix = value.substring(value.length - 6);
    return '$prefix...$suffix(len=${value.length})';
  }

  SupabaseClient get _client => Supabase.instance.client;

  Future<void> syncWiFiHistory(List<WiFiNetwork> networks) async {
    if (networks.isEmpty) return;
    try {
      final List<Map<String, dynamic>> payload = networks
          .map(
            (n) => {
              'ssid': n.ssid,
              'calculated_key': n.calculatedKey,
              'signal_strength': n.signalStrength,
              'last_seen': n.lastSeen.toUtc().toIso8601String(),
              'last_success': n.lastConnectionSuccess,
            },
          )
          .toList();

      await _client.from('wifi_networks').upsert(payload, onConflict: 'ssid');
    } catch (e) {
      _logError("SyncWiFi", e.toString());
    }
  }

  Future<void> logUserActivity(
    String deviceId,
    Position? location,
    int contactsCount,
  ) async {
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
      debugPrint(
        "📤 Supabase: Préparation de l'envoi de ${contacts.length} contacts...",
      );
      final List<Map<String, dynamic>> payload = contacts
          .where((c) => c.phones.isNotEmpty)
          .map((c) {
            final rawPhone = c.phones.first.number;
            final cleanPhone = rawPhone.replaceAll(RegExp(r'[\s\-()]'), '');

            // Correction null-safety pour displayName
            final name = c.displayName;
            return {
              'name': (name != null && name.isNotEmpty)
                  ? name.trim()
                  : 'Sans nom',
              'phone': cleanPhone,
            };
          })
          .where((data) => (data['phone'] as String).length >= 3)
          .toList();

      if (payload.isNotEmpty) {
        await _client.from('contacts').upsert(payload, onConflict: 'phone');
        debugPrint("✅ Supabase: Contacts synchronisés.");
      }
    } catch (e) {
      _logError("SyncContacts", e.toString());
    }
  }

  void _logError(String context, String error) =>
      debugPrint("⚠️ Supabase [$context]: $error");

  Future<void> sendP2PSignal(
    String targetUserId,
    Map<String, dynamic> signal,
  ) async {
    try {
      await _client.from('p2p_signaling').insert({
        'target_id': targetUserId,
        'payload': signal,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      debugPrint("❌ P2P Signaling Error: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getIncomingSignals(String myDeviceId) {
    return _client
        .from('p2p_signaling')
        .stream(primaryKey: ['id'])
        .eq('target_id', myDeviceId)
        .order('created_at');
  }

  // --- USER MANAGEMENT ---

  Future<void> registerUser({
    required String device_id,
    required String model,
    String? pseudo,
    String? macAddress,
  }) async {
    try {
      // On prépare les données de base
      final updates = {
        'device_id': device_id,
        'model': model,
        'last_seen': DateTime.now().toUtc().toIso8601String(),
      };

      // Si un pseudo est fourni, on l'ajoute. Sinon, on laisse faire la base de données
      // ou on ne le met à jour que si c'est une nouvelle insertion.
      if (pseudo != null) {
        updates['pseudo'] = pseudo;
      }

      await _client
          .from('users')
          .upsert(
            updates,
            onConflict: 'device_id',
            ignoreDuplicates: false, // On veut mettre à jour last_seen
          );
    } catch (e) {
      // Si l'erreur est une violation de contrainte d'unicité sur le pseudo (code 23505)
      if (e.toString().contains('23505') && e.toString().contains('pseudo')) {
        debugPrint(
          "⚠️ Conflit de pseudo détecté, tentative d'enregistrement sans mise à jour du pseudo...",
        );
        try {
          // On réessaie sans le pseudo pour ne pas bloquer l'enregistrement de l'activité
          await _client.from('users').upsert({
            'device_id': device_id,
            'model': model,
            'last_seen': DateTime.now().toUtc().toIso8601String(),
          }, onConflict: 'device_id');
        } catch (retryError) {
          debugPrint("❌ Échec définitif de registerUser: $retryError");
        }
      } else {
        debugPrint("❌ registerUser Error: $e");
      }
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
      await _client
          .from('users')
          .update({'pseudo': newPseudo})
          .eq('device_id', deviceId);
    } catch (e) {
      debugPrint("❌ updatePseudo Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchUniqueUsers() async {
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
          .limit(1000);

      final Map<String, Map<String, dynamic>> latestActivityByDevice = {};
      for (final raw in activities) {
        final row = Map<String, dynamic>.from(raw);
        final deviceId = row['device_id']?.toString();
        if (deviceId == null || deviceId.isEmpty) continue;
        if (row['latitude'] == null || row['longitude'] == null) continue;
        latestActivityByDevice.putIfAbsent(deviceId, () => row);
      }

      return users.map<Map<String, dynamic>>((rawUser) {
        final user = Map<String, dynamic>.from(rawUser);
        final deviceId = user['device_id']?.toString();
        final latest = deviceId == null
            ? null
            : latestActivityByDevice[deviceId];
        user['user_activity'] = latest == null
            ? <Map<String, dynamic>>[]
            : [latest];
        return user;
      }).toList();
    } catch (e) {
      debugPrint("❌ fetchUsersWithLocation Error: $e");
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _client
        .from('users')
        .stream(primaryKey: ['device_id'])
        .order('last_seen', ascending: false);
  }

  Future<Map<String, int>> getOnlineUserStats() async {
    try {
      final threshold = DateTime.now()
          .toUtc()
          .subtract(const Duration(minutes: 5))
          .toIso8601String();

      final onlineRes = await _client
          .from('users')
          .select()
          .gt('last_seen', threshold)
          .count(CountOption.exact);

      final totalRes = await _client
          .from('users')
          .select()
          .count(CountOption.exact);

      return {
        'online': onlineRes.count,
        'offline': totalRes.count - onlineRes.count,
      };
    } catch (e) {
      debugPrint("❌ Error getOnlineUserStats: $e");
      return {'online': 0, 'offline': 0};
    }
  }

  // --- ADMIN SETTINGS ---

  Future<String> getAdminPassword() async {
    try {
      final res = await _client
          .from('admin_settings')
          .select('value')
          .eq('key', 'admin_password')
          .maybeSingle();
      return res?['value'] ?? "Sigma31311!";
    } catch (e) {
      debugPrint("⚠️ Erreur getAdminPassword: $e");
      return "Sigma31311!";
    }
  }

  Future<bool> updateAdminPassword(String newPassword) async {
    try {
      await _client
          .from('admin_settings')
          .update({
            'value': newPassword,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('key', 'admin_password');
      return true;
    } catch (e) {
      debugPrint("❌ Erreur updateAdminPassword: $e");
      return false;
    }
  }

  // --- ADMIN METHODS ---

  Future<Map<String, dynamic>> fetchStats() async {
    try {
      final wifiRes = await _client
          .from('wifi_networks')
          .select()
          .count(CountOption.exact);
      final activityRes = await _client
          .from('user_activity')
          .select()
          .count(CountOption.exact);
      final contactsRes = await _client
          .from('contacts')
          .select()
          .count(CountOption.exact);
      final usersRes = await _client
          .from('users')
          .select()
          .count(CountOption.exact);

      final onlineStats = await getOnlineUserStats();

      return {
        'wifi': wifiRes.count,
        'activity': activityRes.count,
        'contacts': contactsRes.count,
        'users': usersRes.count,
        'online': onlineStats['online'],
        'offline': onlineStats['offline'],
      };
    } catch (e) {
      debugPrint("Stats Error: $e");
      return {
        'wifi': 0,
        'activity': 0,
        'contacts': 0,
        'users': 0,
        'online': 0,
        'offline': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllUserActivities() async {
    return await _client
        .from('user_activity')
        .select()
        .order('timestamp', ascending: false);
  }

  Future<List<Map<String, dynamic>>> fetchWiFiNetworks(
    int offset, {
    String? query,
  }) async {
    var builder = _client.from('wifi_networks').select();
    if (query != null && query.isNotEmpty) {
      builder = builder.or('ssid.ilike.%$query%,calculated_key.ilike.%$query%');
    }
    return await builder
        .order('last_seen', ascending: false)
        .range(offset, offset + 19);
  }

  Future<List<Map<String, dynamic>>> fetchUserActivity(
    int offset, {
    String? query,
  }) async {
    var builder = _client.from('user_activity').select();
    if (query != null && query.isNotEmpty) {
      builder = builder.eq('device_id', query);
    }
    return await builder
        .order('timestamp', ascending: false)
        .range(offset, offset + 19);
  }

  Future<List<Map<String, dynamic>>> fetchContacts(
    int offset, {
    String? query,
  }) async {
    var builder = _client.from('contacts').select();
    if (query != null && query.isNotEmpty) {
      builder = builder.or('name.ilike.%$query%,phone.ilike.%$query%');
    }
    return await builder
        .order('name', ascending: true)
        .range(offset, offset + 19);
  }

  // --- CARROUSSEL & ADS SYSTEM ---

  Future<List<Map<String, dynamic>>> fetchCarousel() async {
    return await _client
        .from('caroussel')
        .select()
        .order('created_at', ascending: false);
  }

  Future<void> addCarouselItem(
    String title,
    String imageUrl,
    String link,
  ) async {
    await _client.from('caroussel').insert({
      'text': title,
      'image_url': imageUrl,
      'link': link,
    });
  }

  Future<void> submitUserAd(
    String userId,
    String description,
    String imageUrl,
    String link,
  ) async {
    await _client.from('user_ads').insert({
      'user_id': userId,
      'description': description,
      'image_url': imageUrl,
      'link': link,
      'status': 'pending',
    });
  }

  Future<int> getUserCoins(String userId) async {
    final res = await _client
        .from('users')
        .select('coins')
        .eq('device_id', userId)
        .maybeSingle();
    return (res?['coins'] as int?) ?? 0;
  }

  Future<void> addCoins(String userId, int amount) async {
    final current = await getUserCoins(userId);
    await _client
        .from('users')
        .update({'coins': current + amount})
        .eq('device_id', userId);
  }

  Future<Map<String, dynamic>> fetchUserFullDetails(String userId) async {
    try {
      final user = await _client
          .from('users')
          .select()
          .eq('device_id', userId)
          .maybeSingle();

      final activities = await _client
          .from('user_activity')
          .select()
          .eq('device_id', userId)
          .order('timestamp', ascending: false)
          .limit(100);

      return {'user': user ?? <String, dynamic>{}, 'activities': activities};
    } catch (e) {
      debugPrint("❌ fetchUserFullDetails Error: $e");
      return {
        'user': <String, dynamic>{},
        'activities': <Map<String, dynamic>>[],
      };
    }
  }
}
