import 'package:objectbox/objectbox.dart';

enum MessageType {
  text,
  audio,
  image,
  file,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

@Entity()
class Message {
  @Id()
  int id = 0;

  @Index()
  String messageId; // UUID unique

  @Index()
  String conversationId; // deviceId du contact pour les conversations 1-1

  /// Contenu chiffré du message (base64)
  String encryptedContent;

  /// Type de message
  int typeIndex; // MessageType.index

  /// Statut du message
  int statusIndex; // MessageStatus.index

  /// Est-ce que c'est un message envoyé ou reçu
  bool isSentByMe;

  /// Date d'envoi/réception
  DateTime timestamp;

  /// Chemin local du fichier média (audio/image/file)
  String? localMediaPath;

  /// Taille du fichier en bytes
  int? fileSize;

  /// Durée pour les messages audio (en secondes)
  int? audioDuration;

  /// Indique si le message a été lu
  bool isRead;

  /// Tentatives d'envoi (pour retry)
  int sendAttempts;

  Message({
    required this.messageId,
    required this.conversationId,
    required this.encryptedContent,
    required this.typeIndex,
    this.statusIndex = 0, // MessageStatus.sending
    required this.isSentByMe,
    DateTime? timestamp,
    this.localMediaPath,
    this.fileSize,
    this.audioDuration,
    this.isRead = false,
    this.sendAttempts = 0,
  }) : timestamp = timestamp ?? DateTime.now();

  MessageType get type => MessageType.values[typeIndex];
  MessageStatus get status => MessageStatus.values[statusIndex];

  set type(MessageType value) => typeIndex = value.index;
  set status(MessageStatus value) => statusIndex = value.index;
}
