import 'package:objectbox/objectbox.dart';

/// Statuts de livraison d'un message
enum MessageStatus { sending, sent, delivered, read, failed }

@Entity()
class M2CMessage {
  @Id()
  int id = 0;

  /// Index composite pour requêtes bidirectionnelles performantes
  @Index()
  String senderDeviceId;

  @Index()
  String receiverDeviceId;

  String content;
  bool isVoice;
  String? voiceUrl;

  @Property(type: PropertyType.date)
  DateTime timestamp;

  /// Statut sérialisé comme int (enum non supporté nativement par ObjectBox)
  int statusIndex;

  M2CMessage({
    required this.senderDeviceId,
    required this.receiverDeviceId,
    required this.content,
    this.isVoice = false,
    this.voiceUrl,
    required this.timestamp,
    MessageStatus status = MessageStatus.sending,
  }) : statusIndex = status.index;

  MessageStatus get status => MessageStatus.values[statusIndex];
  set status(MessageStatus s) => statusIndex = s.index;

  bool get isDelivered => statusIndex >= MessageStatus.delivered.index;
  bool get isRead => statusIndex >= MessageStatus.read.index;
}
