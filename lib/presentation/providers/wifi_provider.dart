import 'package:flutter/foundation.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../core/wifi_key_calculator.dart';
import '../../data/sources/local_storage.dart';
import '../../data/sources/user_data_service.dart';
import '../../data/sources/wifi_service.dart';
import '../../domain/entities/wifi_network.dart';
import '../../l10n/app_localizations.dart';

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

  List<WiFiNetwork> _historyNetworks = [];
  List<WiFiNetwork> _scannedNetworks = [];
  bool _showHistory = false;

  bool get showHistory => _showHistory;

  void setShowHistory(bool value) {
    _showHistory = value;
    notifyListeners();
  }

  List<WiFiNetwork> get networks {
    final list = _showHistory ? _historyNetworks : _scannedNetworks;
    // Filtrage : uniquement les réseaux commençant par "fh_" et signal > -95 dBm
    return list
        .where(
          (n) =>
              n.ssid.toLowerCase().startsWith("fh_") && n.signalStrength > -95,
        )
        .toList()
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
      _historyNetworks = _storage.getAllNetworks();
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
    _historyNetworks = _storage.getAllNetworks();
    _connectedSSID = await _wifiService.getCurrentSSID();
    notifyListeners();
  }

  /// Lance un scan des réseaux WiFi avec vérification stricte des pré-requis.
  Future<void> startScan(AppLocalizations l10n) async {
    if (_scanStatus == ScanStatus.scanning) return;

    _scanStatus = ScanStatus.scanning;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Vérification matérielle globale (WiFi + GPS + Permissions)
      final status = await _wifiService.checkHardwareAndPermissions();

      if (!status['wifi']!) {
        _stopScanWithError(l10n.wifiDisabled);
        return;
      }

      if (!status['permission']!) {
        _scanStatus = ScanStatus.permissionDenied;
        _errorMessage = l10n.locationWifiPermsRequired;
        notifyListeners();
        return;
      }

      if (!status['gps']! && _wifiService.isMobile) {
        _stopScanWithError(l10n.gpsRequiredAndroid);
        return;
      }

      // 2. Vérification de la capacité de scan (Throttling Android)
      final canStart = await _wifiService.checkCanStartScan();
      if (canStart != CanStartScan.yes) {
        _stopScanWithError(_getReasonFromCanStartScan(canStart, l10n));
        return;
      }

      // 3. Scan réel
      final results = await _wifiService.scan();

      // 4. Filtrage et sauvegarde des cibles
      _scannedNetworks = [];
      bool foundNew = false;
      for (final network in results) {
        _scannedNetworks.add(network);
        if (WiFiKeyCalculator.isTargetSSID(network.ssid)) {
          await _storage.saveNetwork(network);
          foundNew = true;
        }
      }

      if (foundNew) {
        _historyNetworks = _storage.getAllNetworks();
      }

      _scanStatus = _scannedNetworks.isEmpty
          ? ScanStatus.error
          : ScanStatus.success;
      if (_scannedNetworks.isEmpty) {
        _errorMessage = l10n.noCompatibleNetworks;
      }

      notifyListeners();
    } catch (e) {
      _stopScanWithError(l10n.scanError(e.toString()));
    }
  }

  void _stopScanWithError(String message) {
    _errorMessage = message;
    _scanStatus = ScanStatus.error;
    notifyListeners();
  }

  String _getReasonFromCanStartScan(
    CanStartScan canStart,
    AppLocalizations l10n,
  ) {
    switch (canStart) {
      case CanStartScan.notSupported:
        return l10n.scanNotSupported;
      case CanStartScan.noLocationServiceDisabled:
        return l10n.gpsDisabled;
      case CanStartScan.failed:
        return l10n.failed;
      default:
        return l10n.scanUnavailable(canStart.toString());
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
  Future<void> connect(WiFiNetwork network, AppLocalizations l10n) async {
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
            ? l10n.manualKeyEntryNote
            : l10n.scanError(network.ssid);
      }
    } catch (e) {
      debugPrint("❌ Connection Error: $e");
      _errorMessage = "${l10n.error}: $e";
      _connectionStatus = ConnectionStatus.failed;
    } finally {
      _connectingSSID = null;
      notifyListeners();
    }
  }

  Future<void> disconnect(AppLocalizations l10n) async {
    if (_connectionStatus == ConnectionStatus.connecting) return;

    final ssid = _connectedSSID;
    if (ssid == null) return;

    _connectionStatus = ConnectionStatus.connecting;
    _connectingSSID = ssid;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _wifiService.disconnect();
      await updateLocalData();

      if (success) {
        _connectedSSID = null;
        _connectionStatus = ConnectionStatus.disconnected;
      } else {
        _connectionStatus = ConnectionStatus.failed;
        _errorMessage = l10n.failed;
      }
    } catch (e) {
      debugPrint("âŒ Disconnect Error: $e");
      _errorMessage = "${l10n.error}: $e";
      _connectionStatus = ConnectionStatus.failed;
    } finally {
      _connectingSSID = null;
      notifyListeners();
    }
  }

  Map<String, int> getStats() {
    final successful = _historyNetworks
        .where((n) => n.lastConnectionSuccess == true)
        .length;
    final failed = _historyNetworks
        .where((n) => n.lastConnectionSuccess == false)
        .length;
    return {
      'total': _historyNetworks.length,
      'successful': successful,
      'failed': failed,
    };
  }
}
