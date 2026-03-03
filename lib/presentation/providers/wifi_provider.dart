import 'package:flutter/foundation.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../core/wifi_key_calculator.dart';
import '../../data/sources/local_storage.dart';
import '../../data/sources/user_data_service.dart';
import '../../data/sources/wifi_service.dart';
import '../../domain/entities/wifi_network.dart';

enum ScanStatus { idle, scanning, success, error, permissionDenied }

enum ConnectionStatus { idle, connecting, connected, failed, disconnected }

class WiFiProvider extends ChangeNotifier {
  final WiFiService _wifiService;
  final LocalStorageDataSource _storage;
  final UserDataService _userDataService;

  WiFiProvider(this._wifiService, this._storage, this._userDataService);

  ScanStatus _scanStatus = ScanStatus.idle;
  ScanStatus get scanStatus => _scanStatus;

  ConnectionStatus _connectionStatus = ConnectionStatus.idle;
  ConnectionStatus get connectionStatus => _connectionStatus;

  List<WiFiNetwork> _networks = [];
  List<WiFiNetwork> get networks => _networks;

  String? _connectedSSID;
  String? get connectedSSID => _connectedSSID;

  String? _connectingSSID;
  String? get connectingSSID => _connectingSSID;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Initialise le provider au démarrage de l'application.
  Future<void> initialize() async {
    try {
      await _storage.initialize();
      await updateLocalData();
      
      debugPrint("🚀 WiFiProvider: Initialisation de la synchronisation cloud...");
      _userDataService.initializeDataSync().then((_) => updateLocalData());
    } catch (e) {
      _errorMessage = 'Erreur initialisation: $e';
      notifyListeners();
    }
  }

  /// Met à jour les données locales (Réseaux sauvegardés et SSID actuel).
  Future<void> updateLocalData() async {
    _networks = _storage.getAllNetworks();
    _connectedSSID = await _wifiService.getCurrentSSID();
    notifyListeners();
  }

  /// Lance un scan des réseaux WiFi avec vérification stricte des pré-requis.
  Future<void> startScan() async {
    if (_scanStatus == ScanStatus.scanning) return;

    _scanStatus = ScanStatus.scanning;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Vérifier d'abord si le matériel WiFi est allumé (Android & Windows)
      final isWifiOn = await _wifiService.isWiFiHardwareEnabled();
      if (!isWifiOn) {
        _scanStatus = ScanStatus.error;
        _errorMessage = "Le WiFi est désactivé. Veuillez l'activer.";
        notifyListeners();
        return;
      }

      // 2. Demander les permissions système (Android)
      final granted = await _wifiService.requestPermissions();
      if (!granted) {
        _scanStatus = ScanStatus.permissionDenied;
        _errorMessage = "Permissions de localisation précise requises pour scanner.";
        notifyListeners();
        return;
      }

      // 3. Vérifier si le service de scan est prêt (Localisation/GPS sur Android)
      final canStart = await _wifiService.checkCanStartScan();
      if (canStart != CanStartScan.yes) {
        _scanStatus = ScanStatus.error;
        _errorMessage = _getReasonFromCanStartScan(canStart);
        notifyListeners();
        return;
      }

      // 4. Effectuer le scan réel
      final results = await _wifiService.scan();

      // 5. Traiter les résultats
      for (final network in results) {
        if (WiFiKeyCalculator.isTargetSSID(network.ssid)) {
          await _storage.saveNetwork(network);
        }
      }

      _networks = _storage.getAllNetworks();
      _scanStatus = _networks.isEmpty ? ScanStatus.error : ScanStatus.success;

      if (_networks.isEmpty) {
        _errorMessage = "Aucun réseau compatible détecté à proximité.";
      }

      _userDataService.initializeDataSync();
      notifyListeners();
    } catch (e) {
      debugPrint("❌ WiFiProvider Scan Error: $e");
      _errorMessage = "Erreur lors du scan: $e";
      _scanStatus = ScanStatus.error;
      notifyListeners();
    }
  }

  /// Traduit les codes d'erreur techniques en messages compréhensibles.
  String _getReasonFromCanStartScan(CanStartScan canStart) {
    switch (canStart) {
      case CanStartScan.notSupported:
        return "Le scan WiFi n'est pas supporté sur cet appareil.";
      case CanStartScan.noLocationServiceDisabled:
        return "Le GPS est désactivé. Veuillez l'activer pour scanner.";
      case CanStartScan.noLocationPermissionDenied:
      case CanStartScan.noLocationPermissionRequired:
        return "Permission de localisation manquante ou refusée.";
      case CanStartScan.failed:
        return "Échec du démarrage du scan. Réessayez.";
      default:
        return "Le scan est indisponible ($canStart).";
    }
  }

  /// Actions correctives appelées par l'UI.
  Future<void> fixWiFi() async {
    await _wifiService.openWiFiSettings();
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fixLocation() async {
    await _wifiService.openLocationSettings();
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fixPermissions() async {
    await _wifiService.openAppPermissions();
    _errorMessage = null;
    notifyListeners();
  }

  /// Gère la connexion à un réseau WiFi.
  Future<void> connect(WiFiNetwork network) async {
    if (_connectionStatus == ConnectionStatus.connecting) return;

    _connectionStatus = ConnectionStatus.connecting;
    _connectingSSID = network.ssid;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _wifiService.connect(
        network.ssid,
        network.calculatedKey,
      );
      
      await _storage.updateConnectionStatus(network.ssid, success);
      await updateLocalData();

      _connectionStatus = success ? ConnectionStatus.connected : ConnectionStatus.failed;

      if (success) {
        _connectedSSID = network.ssid;
      } else {
        _errorMessage = _wifiService.isWindows 
            ? "Copiez la clé ! Connexion auto indisponible sur Windows." 
            : "Échec de la connexion à ${network.ssid}.";
      }
    } catch (e) {
      _errorMessage = "Erreur de connexion: $e";
      _connectionStatus = ConnectionStatus.failed;
    } finally {
      _connectingSSID = null;
      notifyListeners();
    }
  }

  Map<String, int> getStats() {
    final successful = _networks.where((n) => n.lastConnectionSuccess == true).length;
    final failed = _networks.where((n) => n.lastConnectionSuccess == false).length;
    return {
      'total': _networks.length,
      'successful': successful,
      'failed': failed,
    };
  }

  Future<void> cleanHistory() async {
    await _storage.cleanOldNetworks(30);
    await updateLocalData();
  }
}
