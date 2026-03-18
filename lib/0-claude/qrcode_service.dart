import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'contact.dart';
import 'crypto_service.dart';
import 'dart:io';

/// Données encodées dans le QR Code
class QRCodeData {
  final String deviceId;
  final String pseudo;
  final String publicKey;
  final String? deviceModel;
  final int version;

  QRCodeData({
    required this.deviceId,
    required this.pseudo,
    required this.publicKey,
    this.deviceModel,
    this.version = 1,
  });

  Map<String, dynamic> toJson() => {
        'v': version,
        'id': deviceId,
        'pseudo': pseudo,
        'key': publicKey,
        if (deviceModel != null) 'model': deviceModel,
      };

  factory QRCodeData.fromJson(Map<String, dynamic> json) {
    return QRCodeData(
      version: json['v'] ?? 1,
      deviceId: json['id'],
      pseudo: json['pseudo'],
      publicKey: json['key'],
      deviceModel: json['model'],
    );
  }

  /// Encode en string compressé pour QR Code
  String encode() {
    final jsonString = jsonEncode(toJson());
    final bytes = utf8.encode(jsonString);
    final compressed = gzip.encode(bytes);
    return base64Url.encode(compressed);
  }

  /// Décode depuis un string QR Code
  static QRCodeData decode(String encoded) {
    try {
      final compressed = base64Url.decode(encoded);
      final bytes = gzip.decode(compressed);
      final jsonString = utf8.decode(bytes);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return QRCodeData.fromJson(json);
    } catch (e) {
      throw Exception('QR Code invalide: $e');
    }
  }

  /// Convertit en Contact
  Contact toContact() {
    return Contact(
      deviceId: deviceId,
      pseudo: pseudo,
      publicKey: publicKey,
      deviceModel: deviceModel,
    );
  }
}

/// Service de gestion des QR Codes pour l'ajout d'amis
class QRCodeService {
  final CryptoService _crypto;
  final String _deviceId;
  final String _pseudo;

  QRCodeService(this._crypto, this._deviceId, this._pseudo);

  /// Génère les données QR Code de l'utilisateur actuel
  Future<QRCodeData> generateMyQRCode() async {
    final deviceInfo = await _getDeviceInfo();
    
    return QRCodeData(
      deviceId: _deviceId,
      pseudo: _pseudo,
      publicKey: _crypto.exportPublicKey(),
      deviceModel: deviceInfo,
    );
  }

  /// Génère le string encodé pour le QR Code
  Future<String> generateMyQRCodeString() async {
    final qrData = await generateMyQRCode();
    return qrData.encode();
  }

  /// Valide et parse un QR Code scanné
  QRCodeData parseScannedQRCode(String scannedData) {
    try {
      final qrData = QRCodeData.decode(scannedData);
      
      // Validations
      if (qrData.deviceId.isEmpty) {
        throw Exception('Device ID manquant');
      }
      
      if (qrData.pseudo.isEmpty) {
        throw Exception('Pseudo manquant');
      }
      
      if (qrData.publicKey.isEmpty) {
        throw Exception('Clé publique manquante');
      }

      // Vérifier que ce n'est pas notre propre QR Code
      if (qrData.deviceId == _deviceId) {
        throw Exception('Impossible de s\'ajouter soi-même');
      }

      // Valider le format de la clé publique
      if (!qrData.publicKey.contains('BEGIN RSA PUBLIC KEY')) {
        throw Exception('Format de clé publique invalide');
      }

      return qrData;
    } catch (e) {
      throw Exception('Erreur parsing QR Code: $e');
    }
  }

  /// Vérifie si un QR Code est valide sans le parser complètement
  bool isValidQRCode(String scannedData) {
    try {
      parseScannedQRCode(scannedData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        return windowsInfo.computerName;
      }
    } catch (e) {
      print('Erreur récupération info device: $e');
    }
    return null;
  }
}


