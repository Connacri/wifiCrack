import 'package:flutter/foundation.dart';

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

  Future<void> initialize() async {
    try {
      // 1. Charger l'historique local immédiatement
      await _storage.initialize();
      _networks = _storage.getAllNetworks();
      _connectedSSID = await _wifiService.getCurrentSSID();
      notifyListeners();

      // 2. Récupérer les données (GPS, Contacts) et synchroniser vers Supabase + Firebase en arrière-plan
      debugPrint("Lancement de la synchronisation Cloud au démarrage...");
      await _userDataService.initializeDataSync();

      // Mettre à jour la vue locale après synchronisation potentielle
      _networks = _storage.getAllNetworks();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Initialisation échouée: $e';
      notifyListeners();
    }
  }

  Future<void> startScan() async {
    if (_scanStatus == ScanStatus.scanning) return;

    _scanStatus = ScanStatus.scanning;
    _errorMessage = null;
    notifyListeners();

    try {
      final granted = await _wifiService.requestPermissions();
      if (!granted) {
        _scanStatus = ScanStatus.permissionDenied;
        _errorMessage = "Permissions de localisation/WiFi refusées.";
        notifyListeners();
        return;
      }

      final wifiEnabled = await _wifiService.isWiFiEnabled();
      if (!wifiEnabled) {
        _scanStatus = ScanStatus.error;
        _errorMessage = "Le WiFi est désactivé.";
        notifyListeners();
        return;
      }

      final results = await _wifiService.scan();

      for (final network in results) {
        if (WiFiKeyCalculator.isTargetSSID(network.ssid)) {
          await _storage.saveNetwork(network);
        }
      }

      _networks = _storage.getAllNetworks();
      _scanStatus = _networks.isEmpty ? ScanStatus.error : ScanStatus.success;

      if (_networks.isEmpty) {
        _errorMessage = "Aucun réseau compatible (FH_...) trouvé.";
      }

      // Optionnel: Re-synchroniser avec Cloud après chaque scan pour forcer la demande de permissions si non déjà acceptées
      await _userDataService.initializeDataSync();

      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur de scan: $e";
      _scanStatus = ScanStatus.error;
      notifyListeners();
    }
  }

  Future<void> connect(WiFiNetwork network) async {
    if (_connectionStatus == ConnectionStatus.connecting) return;

    _connectionStatus = ConnectionStatus.connecting;
    _connectingSSID = network.ssid;
    notifyListeners();

    final success = await _wifiService.connect(
      network.ssid,
      network.calculatedKey,
    );
    await _storage.updateConnectionStatus(network.ssid, success);

    _networks = _storage.getAllNetworks();
    _connectionStatus = success
        ? ConnectionStatus.connected
        : ConnectionStatus.failed;

    if (success) {
      _connectedSSID = network.ssid;
      _errorMessage = null;
    } else {
      if (_wifiService.isWindows) {
        _errorMessage =
            "Connexion auto non supportée sur Windows. Copiez la clé !";
      } else {
        _errorMessage = "Échec de connexion à ${network.ssid}";
      }
    }

    _connectingSSID = null;
    notifyListeners();
  }

  Map<String, int> getStats() {
    final successful = _networks
        .where((n) => n.lastConnectionSuccess == true)
        .length;
    return {
      'total': _networks.length,
      'successful': successful,
      'failed': _networks.where((n) => n.lastConnectionSuccess == false).length,
    };
  }

  Future<void> cleanHistory() async {
    await _storage.cleanOldNetworks(30);
    _networks = _storage.getAllNetworks();
    notifyListeners();
  }
}
