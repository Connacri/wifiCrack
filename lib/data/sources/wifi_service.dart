import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../../domain/entities/wifi_network.dart';
import '../../core/wifi_key_calculator.dart';

/// Service expert pour la gestion du matériel WiFi (Android & Windows).
/// Unifie les accès système et gère les particularités de chaque plateforme.
class WiFiService {
  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Demande et vérifie les permissions critiques pour le WiFi.
  Future<bool> requestPermissions() async {
    if (!isMobile) return true;
    
    try {
      final statuses = await [
        Permission.location,
        Permission.nearbyWifiDevices,
      ].request();

      final isLocationEnabled = await Permission.location.serviceStatus.isEnabled;
      if (!isLocationEnabled) {
        debugPrint("⚠️ WiFiService: Le service de localisation (GPS) est désactivé.");
      }
      
      return statuses[Permission.location]?.isGranted == true;
    } catch (e) {
      debugPrint("❌ WiFiService Permission Error: $e");
      return false;
    }
  }

  /// Vérifie si le scan est actuellement possible.
  Future<bool> isWiFiEnabled() async {
    if (isWindows) return true; 
    
    try {
      final can = await WiFiScan.instance.canGetScannedResults();
      return can == CanGetScannedResults.yes;
    } catch (_) {
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

  /// Implémentation Windows via analyse de la commande système 'netsh'.
  Future<List<WiFiNetwork>> _scanWindows() async {
    List<WiFiNetwork> networks = [];
    debugPrint("🖥️ WiFiService: Déclenchement du scan Windows (netsh)...");
    
    try {
      final result = await Process.run('netsh', ['wlan', 'show', 'networks', 'mode=bssid']);
      if (result.exitCode != 0) {
        debugPrint("❌ WiFiService Windows Scan Error: ${result.stderr}");
        return [];
      }

      final output = result.stdout as String;
      final lines = output.split('\n');
      
      String? currentSsid;
      int? currentSignal;

      for (var line in lines) {
        final trimmed = line.trim();
        
        // Détection SSID (bilingue)
        if ((trimmed.startsWith("SSID") || trimmed.startsWith("Nom")) && trimmed.contains(":")) {
          // Si on commence un nouveau SSID alors qu'on en avait déjà un en attente
          _pushNetworkIfValid(networks, currentSsid, currentSignal);
          
          currentSsid = trimmed.split(":")[1].trim();
          currentSignal = null; // Reset signal pour ce nouveau SSID
        } 
        // Détection Signal (%)
        else if (trimmed.contains("Signal") && trimmed.contains(":")) {
          final signalStr = trimmed.split(":")[1].trim().replaceAll("%", "");
          final quality = int.tryParse(signalStr) ?? 0;
          // Conversion Quality (0-100) -> RSSI dBm (-100 à -50)
          currentSignal = (quality / 2 - 100).toInt();
        }
      }
      
      // Ajouter le dernier réseau trouvé
      _pushNetworkIfValid(networks, currentSsid, currentSignal);
      
      debugPrint("🖥️ WiFiService: ${networks.length} réseaux analysés sur Windows.");
    } catch (e) {
      debugPrint("❌ WiFiService Windows Error: $e");
    }
    return networks;
  }

  /// Helper interne pour valider et ajouter un réseau à la liste.
  void _pushNetworkIfValid(List<WiFiNetwork> list, String? ssid, int? signal) {
    if (ssid != null && ssid.isNotEmpty) {
      final key = WiFiKeyCalculator.calculate(ssid);
      list.add(WiFiNetwork(
        ssid: ssid,
        calculatedKey: key ?? "",
        signalStrength: signal ?? -100, // RSSI par défaut si non trouvé
        lastSeen: DateTime.now(),
        isSecure: true, // netsh wlan show networks renvoie les réseaux sécurisés
      ));
    }
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
