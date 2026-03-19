import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../data/sources/local_storage.dart';
import '../../data/sources/supabase_service.dart';
import 'message_service.dart';

/// Service expert gérant l'agrégation des données utilisateur et leur synchronisation Cloud.
/// Corrigé pour compatibilité FlutterContacts v2.0.0.
class UserDataService {
  final LocalStorageDataSource _storage;
  final SupabaseService _supabaseService;
  final MessageService _messengerService;

  Position? _currentLocation;
  Position? get currentLocation => _currentLocation;

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isSyncInitialized = false;
  bool _isSyncInitializing = false;
  bool _isTrackingActive = false;

  String? _deviceId;
  
  String get deviceId => _deviceId ?? _storage.getDeviceId() ?? "Sigma_Unknown";

  UserDataService(this._storage, this._supabaseService, this._messengerService);

  /// Initialisation globale des services de données.
  Future<void> initializeDataSync() async {
    if (_isSyncInitialized || _isSyncInitializing) return;
    _isSyncInitializing = true;
    try {
      await _initializeDeviceId();
      await registerDevice();
      await _messengerService.initializeNotifications();
      await syncContactsIfPermissionGranted();
      await startLocationTracking();
      _isSyncInitialized = true;
      debugPrint("🚀 UserDataService: Initialisation Sigma complète.");
    } catch (e) {
      debugPrint("⚠️ UserDataService Init Error: $e");
    } finally {
      _isSyncInitializing = false;
    }
  }

  Future<void> _initializeDeviceId() async {
    try {
      final savedId = _storage.getDeviceId();
      if (savedId != null) {
        _deviceId = savedId;
        return;
      }

      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = "Android_${androidInfo.id}";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = "iOS_${iosInfo.identifierForVendor}";
      } else {
        _deviceId = "Sigma_${DateTime.now().millisecondsSinceEpoch}";
      }
      await _storage.saveDeviceId(_deviceId!);
    } catch (e) {
      _deviceId = "Sigma_Err_${DateTime.now().millisecondsSinceEpoch}";
    }
  }

  Future<void> registerDevice() async {
    try {
      String model = "Unknown";
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        model = "${androidInfo.manufacturer} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        model = "Apple ${iosInfo.utsname.machine}";
      }

      await _supabaseService.registerUser(
        device_id: deviceId, // Correction du nom du paramètre
        model: model,
        pseudo: getPseudo(),
      );
    } catch (e) {
      debugPrint("⚠️ registerDevice Failed: $e");
    }
  }

  String getPseudo() => _storage.getPseudo() ?? (deviceId.length > 8 ? deviceId.substring(deviceId.length - 8) : deviceId);

  Future<bool> updatePseudo(String newPseudo) async {
    try {
      final available = await _supabaseService.isPseudoAvailable(newPseudo);
      if (available) {
        await _supabaseService.updatePseudo(deviceId, newPseudo);
        await _storage.savePseudo(newPseudo);
        return true;
      }
    } catch (e) {
      debugPrint("❌ updatePseudo Error: $e");
    }
    return false;
  }

  Future<void> syncContactsIfPermissionGranted() async {
    try {
      // Dans FlutterContacts v2.0.0, l'API est FlutterContacts.permissions.request(type)
      final status = await FlutterContacts.permissions.request(PermissionType.read);
      if (status == PermissionStatus.granted) {
        // getAll() remplace getContacts(), avec le paramètre 'properties'
        _contacts = await FlutterContacts.getAll(
          properties: {ContactProperty.name, ContactProperty.phone},
        );
        if (_contacts.isNotEmpty) {
          await _supabaseService.syncContacts(_contacts);
        }
      }
    } catch (e) {
      debugPrint("⚠️ Contacts Sync Error: $e");
    }
  }

  Future<void> startLocationTracking() async {
    if (_isTrackingActive) return;
    
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      
      if (permission == LocationPermission.deniedForever) return;
      
      _isTrackingActive = true;
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20,
        ),
      ).listen(
        (position) {
          _currentLocation = position;
          _supabaseService.logUserActivity(deviceId, position, _contacts.length);
        },
        onError: (e) {
          _isTrackingActive = false;
        },
      );
    } catch (e) {
      _isTrackingActive = false;
    }
  }

  void dispose() {
    _positionStreamSubscription?.cancel();
    _isTrackingActive = false;
  }
}
