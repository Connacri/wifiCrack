import 'package:objectbox/objectbox.dart';

@Entity()
class Conversation {
  @Id()
  int id = 0;

  @Unique()
  @Index()
  String conversationId; // deviceId du contact pour 1-1

  /// Dernier message (extrait déchiffré)
  String? lastMessagePreview;

  /// Timestamp du dernier message
  DateTime? lastMessageTime;

  /// Nombre de messages non lus
  int unreadCount;

  /// L'autre participant est en train d'écrire
  bool isTyping;

  /// Timestamp du dernier "isTyping"
  DateTime? lastTypingTime;

  /// Conversation épinglée
  bool isPinned;

  /// Conversation archivée
  bool isArchived;

  /// Conversation muette
  bool isMuted;

  Conversation({
    required this.conversationId,
    this.lastMessagePreview,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.isTyping = false,
    this.lastTypingTime,
    this.isPinned = false,
    this.isArchived = false,
    this.isMuted = false,
  });
}
