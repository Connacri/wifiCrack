import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:io';

class PermissionService {
  static const List<Permission> requiredPermissions = [
    Permission.location,
    Permission.nearbyWifiDevices,
    Permission.notification,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ];

  /// Vérifie si toutes les permissions sont accordées.
  static Future<bool> areAllPermissionsGranted() async {
    if (Platform.isWindows) return true; // Bypass Windows
    for (var permission in requiredPermissions) {
      if (Platform.isAndroid && permission == Permission.nearbyWifiDevices) {
        // nearbyWifiDevices est pour Android 13+
        continue; 
      }
      if (!await permission.isGranted) return false;
    }
    return true;
  }

  /// Demande toutes les permissions et retourne vrai si tout est accepté.
  static Future<bool> requestAllPermissions() async {
    if (Platform.isWindows) return true; // Bypass Windows
    Map<Permission, PermissionStatus> statuses = await requiredPermissions.request();
    return statuses.values.every((status) => status.isGranted);
  }

  /// Vérifie si le matériel (GPS/WiFi) est activé.
  static Future<bool> isHardwareEnabled() async {
    if (Platform.isWindows) return true; // Bypass Windows
    bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    bool wifiEnabled = await WiFiForIoTPlugin.isEnabled();
    return gpsEnabled && wifiEnabled;
  }

  /// Affiche une dialog d'alerte si les conditions ne sont pas remplies.
  static void showPermissionDialog(BuildContext context, {required VoidCallback onRetry}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Autorisations Requises", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
          "Pour utiliser cette application, vous devez impérativement :\n\n"
          "1. Accepter TOUTES les permissions (Localisation, Appareils à proximité).\n"
          "2. Activer votre GPS.\n"
          "3. Activer votre WiFi.\n\n"
          "Sans cela, l'application ne peut pas fonctionner.",
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry();
            },
            child: const Text("J'ai compris, configurer"),
          ),
        ],
      ),
    );
  }
}
