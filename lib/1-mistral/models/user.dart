import 'package:objectbox/objectbox.dart';

@Entity()
class MistralUser {
  @Id()
  int id = 0;
  String deviceId;
  String? pseudo;
  String? model;
  DateTime? lastSeen;
  int coins;

  MistralUser({
    required this.deviceId,
    this.pseudo,
    this.model,
    this.lastSeen,
    this.coins = 0,
  });
}
