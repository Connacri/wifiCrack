import 'package:objectbox/objectbox.dart';

@Entity()
class M2CContact {
  @Id()
  int id = 0;

  @Unique()
  String deviceId;

  String? pseudo;
  DateTime addedAt;

  /// Dernier message reçu (pour preview dans la liste)
  String? lastMessagePreview;
  DateTime? lastMessageAt;

  /// Nombre de messages non lus
  int unreadCount;

  M2CContact({
    required this.deviceId,
    this.pseudo,
    required this.addedAt,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  String get displayName => pseudo?.isNotEmpty == true ? pseudo! : deviceId.substring(0, 8);
}
