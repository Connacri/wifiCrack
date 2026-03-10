import 'package:objectbox/objectbox.dart';

@Entity()
class MistralMessage {
  @Id()
  int id = 0;
  String senderDeviceId;
  String receiverDeviceId;
  String content;
  bool isVoice;
  String? voiceUrl;
  DateTime timestamp;
  bool isDelivered;
  bool isRead;

  MistralMessage({
    required this.senderDeviceId,
    required this.receiverDeviceId,
    required this.content,
    this.isVoice = false,
    this.voiceUrl,
    required this.timestamp,
    this.isDelivered = false,
    this.isRead = false,
  });
}
