import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/wifi_network.dart';
import '../../core/wifi_key_calculator.dart';

/// Service expert pour la gestion du matériel WiFi (Android & Windows).
class WiFiService {
  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Vérifie si le matériel WiFi est réellement activé.
  Future<bool> isWiFiHardwareEnabled() async {
    if (isWindows) return true;
    try {
      return await WiFiForIoTPlugin.isEnabled();
    } catch (_) {
      return false;
    }
  }

  /// Tente d'activer le WiFi ou ouvre les paramètres.
  Future<void> openWiFiSettings() async {
    if (Platform.isAndroid) {
      await WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: true);
    }
  }

  /// Ouvre les paramètres de localisation.
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Ouvre les paramètres de l'application pour les permissions.
  Future<void> openAppPermissions() async {
    await openAppSettings();
  }

  /// Vérifie tout le pipeline matériel et permissions.
  Future<Map<String, bool>> checkHardwareAndPermissions() async {
    if (isWindows) return {'wifi': true, 'gps': true, 'permission': true};

    final wifiEnabled = await isWiFiHardwareEnabled();
    final gpsEnabled = await Geolocator.isLocationServiceEnabled();
    
    // Vérification des permissions critiques (Localisation + Nearby pour Android 13+)
    final locGranted = await Permission.location.isGranted;
    bool nearbyGranted = true;
    if (Platform.isAndroid) {
      // nearbyWifiDevices est requis pour scanner sur Android 13+ sans localisation
      nearbyGranted = await Permission.nearbyWifiDevices.isGranted;
    }

    return {
      'wifi': wifiEnabled,
      'gps': gpsEnabled,
      'permission': locGranted || nearbyGranted,
    };
  }

  /// Force l'ouverture des paramètres si nécessaire.
  Future<void> forceEnableHardware(BuildContext context) async {
    final status = await checkHardwareAndPermissions();
    
    if (!status['permission']!) {
      await requestPermissions();
    }
    
    if (!status['wifi']!) {
      await openWiFiSettings();
    }
    
    if (!status['gps']!) {
      await openLocationSettings();
    }
  }

  /// Vérifie si le service de scan est prêt.
  Future<CanStartScan> checkCanStartScan() async {
    if (isWindows) return CanStartScan.yes;
    try {
      return await WiFiScan.instance.canStartScan();
    } catch (_) {
      return CanStartScan.failed;
    }
  }

  /// Demande et vérifie les permissions critiques.
  Future<bool> requestPermissions() async {
    if (!isMobile) return true;
    
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.nearbyWifiDevices,
      ].request();

      return statuses[Permission.location]?.isGranted == true || 
             statuses[Permission.nearbyWifiDevices]?.isGranted == true;
    } catch (e) {
      debugPrint("❌ WiFiService Permission Error: $e");
      return false;
    }
  }

  /// Scanne les réseaux WiFi et retourne une liste unifiée d'entités [WiFiNetwork].
  Future<List<WiFiNetwork>> scan() async {
    if (isWindows) {
      return await _scanWindows();
    } else if (isMobile) {
      return await _scanMobile();
    }
    return [];
  }

  /// Implémentation Mobile (Android/iOS) via plugins natifs.
  Future<List<WiFiNetwork>> _scanMobile() async {
    try {
      final canStart = await WiFiScan.instance.canStartScan();
      if (canStart == CanStartScan.yes) {
        // On lance le scan et on attend un peu pour les résultats
        await WiFiScan.instance.startScan();
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      final results = await WiFiScan.instance.getScannedResults();
      debugPrint("📱 WiFiService: ${results.length} réseaux détectés.");
      
      return results.map((ap) {
        final key = WiFiKeyCalculator.calculate(ap.ssid) ?? "";
        return WiFiNetwork(
          ssid: ap.ssid,
          calculatedKey: key,
          signalStrength: ap.level,
          frequency: "${(ap.frequency / 1000).toStringAsFixed(1)} GHz",
          lastSeen: DateTime.now(),
          isSecure: ap.capabilities.toUpperCase().contains("WPA") || 
                    ap.capabilities.toUpperCase().contains("WEP"),
        );
      }).toList();
    } catch (e) {
      debugPrint("❌ WiFiService Mobile Scan Error: $e");
    }
    return [];
  }

  /// Implémentation Windows experte (Indépendante de la langue du système).
  Future<List<WiFiNetwork>> _scanWindows() async {
    List<WiFiNetwork> networks = [];
    try {
      final result = await Process.run('netsh', ['wlan', 'show', 'networks', 'mode=bssid']);
      if (result.exitCode != 0) return [];

      final output = result.stdout as String;
      final ssidRegex = RegExp(r'^(?:SSID|Nom|Name|Nombre)[^:]+:[ \t]+(.*)$', multiLine: true);
      final signalRegex = RegExp(r'Signal[^:]+:[ \t]+(\d+)%', multiLine: true);

      final ssidMatches = ssidRegex.allMatches(output).toList();
      final signalMatches = signalRegex.allMatches(output).toList();

      for (int i = 0; i < ssidMatches.length; i++) {
        final ssid = ssidMatches[i].group(1)?.trim() ?? "";
        if (ssid.isEmpty) continue;

        int signalValue = 0;
        if (i < signalMatches.length) {
          signalValue = int.tryParse(signalMatches[i].group(1) ?? "0") ?? 0;
        }

        final rssi = (signalValue / 2 - 100).toInt();
        final key = WiFiKeyCalculator.calculate(ssid);
        
        networks.add(WiFiNetwork(
          ssid: ssid,
          calculatedKey: key ?? "",
          signalStrength: rssi,
          lastSeen: DateTime.now(),
          isSecure: true,
        ));
      }
    } catch (e) {
      debugPrint("❌ Windows Scan Error: $e");
    }
    return networks;
  }

  /// Tente de se connecter au réseau spécifié.
  Future<bool> connect(String ssid, String key, {bool isSecure = true}) async {
    if (isWindows) {
      return await _connectWindows(ssid, key);
    } else if (isMobile) {
      return await _connectMobile(ssid, key, isSecure);
    }
    return false;
  }

  Future<bool> _connectMobile(String ssid, String key, bool isSecure) async {
    try {
      debugPrint("🚀 Tentative de connexion à $ssid...");
      
      // On s'assure de ne pas être déjà en mode forcé pour éviter les conflits
      await WiFiForIoTPlugin.forceWifiUsage(false);
      await WiFiForIoTPlugin.disconnect();
      
      // Attente d'un court instant après la déconnexion
      await Future.delayed(const Duration(milliseconds: 500));

      final success = await WiFiForIoTPlugin.connect(
        ssid,
        password: key,
        security: isSecure ? NetworkSecurity.WPA : NetworkSecurity.NONE,
        joinOnce: false,
      );

      if (success) {
        debugPrint("✅ Commande de connexion acceptée pour $ssid. Attente de l'établissement...");
        
        // Attente active de la connexion réelle (jusqu'à 10 secondes)
        bool connected = false;
        for (int i = 0; i < 10; i++) {
          await Future.delayed(const Duration(seconds: 1));
          final currentSSID = await WiFiForIoTPlugin.getSSID();
          if (currentSSID == ssid || currentSSID == "\"$ssid\"") {
            connected = true;
            break;
          }
        }

        if (connected) {
          debugPrint("🌐 Connecté à $ssid. Forçage du trafic WiFi pour l'accès internet...");
          // On force l'usage du WiFi pour toutes les requêtes de l'application
          await WiFiForIoTPlugin.forceWifiUsage(true);
          return true;
        } else {
          debugPrint("⚠️ Timeout : Connecté mais SSID non confirmé.");
          // On tente quand même de forcer au cas où l'OS cache le SSID
          await WiFiForIoTPlugin.forceWifiUsage(true);
          return true;
        }
      }

      return success;
    } catch (e) {
      debugPrint("❌ WiFi Connect Error: $e");
      return false;
    }
  }

  Future<bool> _connectWindows(String ssid, String key) async {
    try {
      final profileXml = _generateWlanProfile(ssid, key);
      final tempDir = Directory.systemTemp;
      final profileFile = File('${tempDir.path}\\wifi_profile.xml');
      await profileFile.writeAsString(profileXml);

      await Process.run('netsh', ['wlan', 'add', 'profile', 'filename=${profileFile.path}']);
      await profileFile.delete(); 

      final connectResult = await Process.run('netsh', ['wlan', 'connect', 'name=$ssid']);
      return connectResult.exitCode == 0;
    } catch (e) {
      debugPrint("❌ Windows Connect Error: $e");
      return false;
    }
  }

  String _generateWlanProfile(String ssid, String key) {
    return '''<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$ssid</name>
    <SSIDConfig><SSID><name>$ssid</name></SSID></SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>manual</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$key</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>''';
  }

  Future<String?> getCurrentSSID() async {
    if (!isMobile) return null;
    try {
      return await WiFiForIoTPlugin.getSSID();
    } catch (_) {
      return null;
    }
  }

  Future<bool> disconnect() async {
    try {
      if (isWindows) {
        final result = await Process.run('netsh', ['wlan', 'disconnect']);
        return result.exitCode == 0;
      }
      await WiFiForIoTPlugin.forceWifiUsage(false);
      return await WiFiForIoTPlugin.disconnect();
    } catch (e) {
      return false;
    }
  }
}
