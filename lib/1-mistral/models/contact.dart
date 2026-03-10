import 'package:objectbox/objectbox.dart';

@Entity()
class MistralContact {
  @Id()
  int id = 0;
  String deviceId;
  String? pseudo;
  DateTime addedAt;

  MistralContact({
    required this.deviceId,
    this.pseudo,
    required this.addedAt,
  });
}
