import 'package:objectbox/objectbox.dart';

@Entity()
class M2CUser {
  @Id()
  int id = 0;

  @Unique()
  String deviceId;

  String? pseudo;
  String? model;
  DateTime? lastSeen;
  int coins;

  M2CUser({
    required this.deviceId,
    this.pseudo,
    this.model,
    this.lastSeen,
    this.coins = 0,
  });

  M2CUser copyWith({
    String? pseudo,
    String? model,
    DateTime? lastSeen,
    int? coins,
  }) {
    return M2CUser(
      deviceId: deviceId,
      pseudo: pseudo ?? this.pseudo,
      model: model ?? this.model,
      lastSeen: lastSeen ?? this.lastSeen,
      coins: coins ?? this.coins,
    )..id = id;
  }
}
