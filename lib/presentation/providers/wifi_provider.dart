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
  List<WiFiNetwork> get networks {
    // Filtrage pour ne montrer que les réseaux à proximité (signal correct)
    return _networks.where((n) => n.signalStrength > -85).toList()
      ..sort((a, b) => b.signalStrength.compareTo(a.signalStrength));
  }

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
      _networks = _storage.getAllNetworks();
      _connectedSSID = await _wifiService.getCurrentSSID();
      notifyListeners();
      
      // La sync cloud est lancée de manière asynchrone pour ne pas bloquer l'UI
      _userDataService.initializeDataSync().then((_) => updateLocalData());
    } catch (e) {
      debugPrint("❌ WiFiProvider Init Error: $e");
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
      // 1. Vérification matérielle globale (WiFi + GPS + Permissions)
      final status = await _wifiService.checkHardwareAndPermissions();
      
      if (!status['wifi']!) {
        _stopScanWithError("Le WiFi est désactivé.");
        return;
      }

      if (!status['permission']!) {
        _scanStatus = ScanStatus.permissionDenied;
        _errorMessage = "Permissions de localisation/WiFi requises.";
        notifyListeners();
        return;
      }

      if (!status['gps']! && _wifiService.isMobile) {
        _stopScanWithError("Le GPS est requis pour scanner sur Android.");
        return;
      }

      // 2. Vérification de la capacité de scan (Throttling Android)
      final canStart = await _wifiService.checkCanStartScan();
      if (canStart != CanStartScan.yes) {
        _stopScanWithError(_getReasonFromCanStartScan(canStart));
        return;
      }

      // 3. Scan réel
      final results = await _wifiService.scan();

      // 4. Filtrage et sauvegarde des cibles
      bool foundNew = false;
      for (final network in results) {
        if (WiFiKeyCalculator.isTargetSSID(network.ssid)) {
          await _storage.saveNetwork(network);
          foundNew = true;
        }
      }

      if (foundNew) {
        _networks = _storage.getAllNetworks();
      }

      _scanStatus = _networks.isEmpty ? ScanStatus.error : ScanStatus.success;
      if (_networks.isEmpty) {
        _errorMessage = "Aucun réseau compatible détecté à proximité.";
      }
      
      notifyListeners();
    } catch (e) {
      _stopScanWithError("Erreur lors du scan: $e");
    }
  }

  void _stopScanWithError(String message) {
    _errorMessage = message;
    _scanStatus = ScanStatus.error;
    notifyListeners();
  }

  String _getReasonFromCanStartScan(CanStartScan canStart) {
    switch (canStart) {
      case CanStartScan.notSupported:
        return "Le scan WiFi n'est pas supporté sur cet appareil.";
      case CanStartScan.noLocationServiceDisabled:
        return "Le GPS est désactivé.";
      case CanStartScan.failed:
        return "Échec du moteur de scan.";
      default:
        return "Le scan est indisponible ($canStart).";
    }
  }

  /// Actions correctives appelées par l'UI.
  Future<void> fixWiFi() async {
    await _wifiService.openWiFiSettings();
  }

  Future<void> fixLocation() async {
    await _wifiService.openLocationSettings();
  }

  Future<void> fixPermissions() async {
    await _wifiService.openAppPermissions();
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

      if (success) {
        _connectionStatus = ConnectionStatus.connected;
        _connectedSSID = network.ssid;
      } else {
        _connectionStatus = ConnectionStatus.failed;
        _errorMessage = _wifiService.isWindows 
            ? "Veuillez entrer la clé manuellement si la connexion échoue." 
            : "Échec de la connexion à ${network.ssid}.";
      }
    } catch (e) {
      debugPrint("❌ Connection Error: $e");
      _errorMessage = "Erreur: $e";
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
}
