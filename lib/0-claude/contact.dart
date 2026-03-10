import 'package:objectbox/objectbox.dart';

@Entity()
class Contact {
  @Id()
  int id = 0;

  @Unique()
  @Index()
  String deviceId;

  String pseudo;
  String? avatarPath;
  
  /// Clé publique RSA pour le chiffrement E2E (format PEM)
  String publicKey;
  
  /// Date d'ajout du contact
  DateTime addedAt;
  
  /// Dernière fois que le contact était en ligne
  DateTime? lastSeen;
  
  /// Statut de connexion WebRTC
  bool isOnline;
  
  /// Informations du modèle d'appareil
  String? deviceModel;
  
  /// Score de fiabilité de la connexion (0-100)
  int connectionScore;

  Contact({
    required this.deviceId,
    required this.pseudo,
    required this.publicKey,
    this.avatarPath,
    DateTime? addedAt,
    this.lastSeen,
    this.isOnline = false,
    this.deviceModel,
    this.connectionScore = 100,
  }) : addedAt = addedAt ?? DateTime.now();
}
