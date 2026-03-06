import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../data/sources/local_storage.dart';
import '../../data/sources/supabase_service.dart';
import '../../data/sources/firebase_service.dart';
import 'firebase_messenger_service.dart';

/// Service expert gérant l'agrégation des données utilisateur et leur synchronisation Cloud.
class UserDataService {
  final LocalStorageDataSource _storage;
  final SupabaseService _supabaseService;
  final FirebaseService _firebaseService;
  final FirebaseMessengerService _messengerService;

  Position? _currentLocation;
  Position? get currentLocation => _currentLocation;

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isSyncInitialized = false;
  bool _isTrackingActive = false;

  String? _deviceId;
  
  String get deviceId => _deviceId ?? _storage.getDeviceId() ?? "Sigma_Unknown";

  UserDataService(this._storage, this._supabaseService, this._firebaseService, this._messengerService);

  /// Initialisation FORCÉE à chaque démarrage.
  Future<void> initializeDataSync() async {
    await _initializeDeviceId();
    
    // 1. ENREGISTREMENT SYSTÉMATIQUE (Garantit l'existence dans la table 'users')
    await registerDevice();
    
    // 2. MESSAGING (FCM)
    await _messengerService.initializeNotifications(deviceId);
    
    // 3. CONTACTS (Force la sync à chaque boot sur Supabase)
    await syncContactsIfPermissionGranted();
    
    // 4. GPS (Tracking immédiat)
    await startLocationTracking();
    
    _isSyncInitialized = true;
    debugPrint("🚀 UserDataService: Séquence de boot Sigma terminée.");
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

      // Upsert Supabase : Garantit que l'user est dans la table 'users' pour la Map
      await _supabaseService.registerUser(
        deviceId: deviceId,
        model: model,
        pseudo: getPseudo(),
      );
      debugPrint("✅ User registered in Supabase Users Table: $deviceId");
    } catch (e) {
      debugPrint("⚠️ registerDevice Failed: $e");
    }
  }

  String getPseudo() => _storage.getPseudo() ?? deviceId.substring(0, 8);

  Future<bool> updatePseudo(String newPseudo) async {
    final available = await _supabaseService.isPseudoAvailable(newPseudo);
    if (available) {
      await _supabaseService.updatePseudo(deviceId, newPseudo);
      await _storage.savePseudo(newPseudo);
      return true;
    }
    return false;
  }

  Future<void> syncContactsIfPermissionGranted() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        _contacts = await FlutterContacts.getContacts(withProperties: true);
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
    
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    _isTrackingActive = true;
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      (position) {
        _currentLocation = position;
        _supabaseService.logUserActivity(deviceId, position, _contacts.length);
      },
      onError: (e) => _isTrackingActive = false,
    );
  }

  void dispose() {
    _positionStreamSubscription?.cancel();
    _isTrackingActive = false;
  }
}
