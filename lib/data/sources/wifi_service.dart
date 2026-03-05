import 'dart:io';
import 'package:flutter/foundation.dart';
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

  /// Vérifie si le GPS est activé.
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Vérifie si le scan peut démarrer et identifie précisément le blocage.
  Future<CanStartScan> checkCanStartScan() async {
    if (isWindows) return CanStartScan.yes;
    try {
      return await WiFiScan.instance.canStartScan();
    } catch (_) {
      return CanStartScan.failed;
    }
  }

  /// Demande et vérifie les permissions critiques (Localisation Précise + WiFi).
  Future<bool> requestPermissions() async {
    if (!isMobile) return true;
    
    try {
      // Sur Android 12+, on demande NEARBY_WIFI_DEVICES + LOCATION
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.locationWhenInUse,
        Permission.nearbyWifiDevices,
      ].request();

      // On vérifie si on a la localisation précise
      final status = await Permission.location.status;
      if (status.isPermanentlyDenied) {
        return false;
      }
      
      return status.isGranted || statuses[Permission.nearbyWifiDevices]?.isGranted == true;
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
        await WiFiScan.instance.startScan();
        // Délai pour permettre la réception de nouveaux résultats
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      final results = await WiFiScan.instance.getScannedResults();
      debugPrint("📱 WiFiService: ${results.length} réseaux détectés sur Android.");
      
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
      // Force l'encodage UTF-8 pour éviter les problèmes de caractères spéciaux
      final result = await Process.run('netsh', ['wlan', 'show', 'networks', 'mode=bssid']);
      if (result.exitCode != 0) return [];

      final output = result.stdout as String;
      
      // RegExp universelle : On cherche les lignes qui commencent par un mot (SSID/Nom) suivi de ':'
      // Le pattern [ \t]+:[ \t]+ permet de capturer la valeur après les deux points.
      final ssidRegex = RegExp(r'^(?:SSID|Nom|Name|Nombre)[^:]+:[ \t]+(.*)$', multiLine: true);
      final signalRegex = RegExp(r'Signal[^:]+:[ \t]+(\d+)%', multiLine: true);

      final ssidMatches = ssidRegex.allMatches(output).toList();
      final signalMatches = signalRegex.allMatches(output).toList();

      for (int i = 0; i < ssidMatches.length; i++) {
        final ssid = ssidMatches[i].group(1)?.trim() ?? "";
        if (ssid.isEmpty) continue;

        // On récupère le signal correspondant s'il existe
        int signalValue = 0;
        if (i < signalMatches.length) {
          signalValue = int.tryParse(signalMatches[i].group(1) ?? "0") ?? 0;
        }

        // Conversion Qualité % -> RSSI dBm
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
      debugPrint("❌ Windows Universal Scan Error: $e");
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

  /// Connexion Mobile via wifi_iot.
  Future<bool> _connectMobile(String ssid, String key, bool isSecure) async {
    try {
      await WiFiForIoTPlugin.disconnect();
      return await WiFiForIoTPlugin.connect(
        ssid,
        password: key,
        security: isSecure ? NetworkSecurity.WPA : NetworkSecurity.NONE,
        joinOnce: true,
      );
    } catch (e) {
      debugPrint("❌ WiFiService Mobile Connect Error: $e");
      return false;
    }
  }

  /// Connexion Windows via génération de profil XML et netsh.
  Future<bool> _connectWindows(String ssid, String key) async {
    debugPrint("🖥️ WiFiService Windows: Tentative de connexion à $ssid...");
    try {
      final profileXml = _generateWlanProfile(ssid, key);
      final tempDir = Directory.systemTemp;
      final profileFile = File('${tempDir.path}\\wifi_profile.xml');
      await profileFile.writeAsString(profileXml);

      // Importation du profil
      final addResult = await Process.run('netsh', ['wlan', 'add', 'profile', 'filename=${profileFile.path}']);
      await profileFile.delete(); // Sécurité : suppression immédiate du mot de passe en clair

      if (addResult.exitCode != 0) {
        debugPrint("❌ WiFiService Windows: Erreur ajout profil : ${addResult.stderr}");
        return false;
      }

      // Déclenchement de la connexion
      final connectResult = await Process.run('netsh', ['wlan', 'connect', 'name=$ssid']);
      return connectResult.exitCode == 0;
    } catch (e) {
      debugPrint("❌ WiFiService Windows Connect Error: $e");
      return false;
    }
  }

  /// Génère le XML requis par Windows pour les réseaux WPA2-PSK.
  String _generateWlanProfile(String ssid, String key) {
    return '''<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$ssid</name>
    <SSIDConfig>
        <SSID><name>$ssid</name></SSID>
    </SSIDConfig>
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

  /// Récupère le SSID du réseau actuellement connecté.
  Future<String?> getCurrentSSID() async {
    if (!isMobile) return null;
    try {
      return await WiFiForIoTPlugin.getSSID();
    } catch (_) {
      return null;
    }
  }

  /// Déconnexion forcée du WiFi.
  Future<bool> disconnect() async {
    try {
      if (isWindows) {
        final result = await Process.run('netsh', ['wlan', 'disconnect']);
        return result.exitCode == 0;
      }
      return await WiFiForIoTPlugin.disconnect();
    } catch (e) {
      debugPrint("❌ WiFiService Disconnect Error: $e");
      return false;
    }
  }
}
