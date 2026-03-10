import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'contact.dart';
import 'message.dart';
import 'conversation.dart';
import '../objectbox.g.dart';
import 'dart:convert';
import 'dart:io';

/// Service de base de données ObjectBox avec cache de 100 derniers messages
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  late Store _store;
  late Box<Contact> _contactBox;
  late Box<Message> _messageBox;
  late Box<Conversation> _conversationBox;

  bool _isInitialized = false;

  /// Initialise ObjectBox
  Future<void> initialize() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    final storePath = p.join(dir.path, 'objectbox');

    try {
      _store = await openStore(directory: storePath);
    } catch (e) {
      debugPrint('❌ Erreur critique ObjectBox: $e');
      // Si l'erreur persiste, on tente une dernière fois sans spécifier le dossier
      // (ObjectBox utilisera son dossier par défaut)
      if (e.toString().contains('ObjectBoxException')) {
         _store = await openStore();
      } else {
        rethrow;
      }
    }

    _contactBox = _store.box<Contact>();
    _messageBox = _store.box<Message>();
    _conversationBox = _store.box<Conversation>();

    _isInitialized = true;

    // Nettoyer les vieux messages au démarrage
    await _cleanOldMessages();
  }

  // === Contacts ===

  Future<void> saveContact(Contact contact) async {
    _contactBox.put(contact);
  }

  Future<Contact?> getContact(String deviceId) async {
    final query = _contactBox
        .query(Contact_.deviceId.equals(deviceId))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  Future<List<Contact>> getAllContacts() async {
    return _contactBox.getAll();
  }

  Future<void> deleteContact(String deviceId) async {
    final contact = await getContact(deviceId);
    if (contact != null) {
      _contactBox.remove(contact.id);
      
      // Supprimer aussi la conversation et les messages
      await deleteConversation(deviceId);
    }
  }

  Future<void> updateContactOnlineStatus(String deviceId, bool isOnline) async {
    final contact = await getContact(deviceId);
    if (contact != null) {
      contact.isOnline = isOnline;
      contact.lastSeen = DateTime.now();
      _contactBox.put(contact);
    }
  }

  // === Messages ===

  Future<void> saveMessage(Message message) async {
    _messageBox.put(message);
    await _updateConversation(message);
    await _enforceMessageLimit(message.conversationId);
  }

  Future<void> updateMessage(Message message) async {
    _messageBox.put(message);
    
    // Mettre à jour la conversation si c'est le dernier message
    final conversation = await getConversation(message.conversationId);
    if (conversation != null &&
        (conversation.lastMessageTime == null ||
            message.timestamp.isAfter(conversation.lastMessageTime!))) {
      await _updateConversation(message);
    }
  }

  Future<Message?> getMessageById(String messageId) async {
    final query = _messageBox
        .query(Message_.messageId.equals(messageId))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  Future<List<Message>> getMessages(String conversationId, {int limit = 100}) async {
    final query = _messageBox
        .query(Message_.conversationId.equals(conversationId))
        .order(Message_.timestamp, flags: Order.descending)
        .build();
    query.limit = limit;
    final results = query.find();
    query.close();
    return results.reversed.toList();
  }

  Future<List<Message>> getFailedMessages(String conversationId) async {
    final query = _messageBox
        .query(Message_.conversationId.equals(conversationId)
            .and(Message_.statusIndex.equals(MessageStatus.failed.index)))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  Future<int> getUnreadCount(String conversationId) async {
    final query = _messageBox
        .query(Message_.conversationId.equals(conversationId)
            .and(Message_.isSentByMe.equals(false))
            .and(Message_.isRead.equals(false)))
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  Future<void> markConversationAsRead(String conversationId) async {
    final query = _messageBox
        .query(Message_.conversationId.equals(conversationId)
            .and(Message_.isSentByMe.equals(false))
            .and(Message_.isRead.equals(false)))
        .build();
    
    final messages = query.find();
    for (final message in messages) {
      message.isRead = true;
    }
    _messageBox.putMany(messages);
    query.close();

    // Mettre à jour la conversation
    final conversation = await getConversation(conversationId);
    if (conversation != null) {
      conversation.unreadCount = 0;
      _conversationBox.put(conversation);
    }
  }

  /// Limite à 100 messages par conversation
  Future<void> _enforceMessageLimit(String conversationId) async {
    const maxMessages = 100;
    
    final query = _messageBox
        .query(Message_.conversationId.equals(conversationId))
        .order(Message_.timestamp, flags: Order.descending)
        .build();
    
    final allMessages = query.find();
    query.close();

    if (allMessages.length > maxMessages) {
      // Garder les 100 plus récents, supprimer les autres
      final toDelete = allMessages.skip(maxMessages).toList();
      _messageBox.removeMany(toDelete.map((m) => m.id).toList());
    }
  }

  /// Nettoie les messages de plus de 30 jours
  Future<void> _cleanOldMessages() async {
    final threshold = DateTime.now().subtract(const Duration(days: 30));
    
    final query = _messageBox
        .query(Message_.timestamp.lessThan(threshold.millisecondsSinceEpoch))
        .build();
    
    final oldMessages = query.find();
    _messageBox.removeMany(oldMessages.map((m) => m.id).toList());
    query.close();
  }

  // === Conversations ===

  Future<Conversation?> getConversation(String conversationId) async {
    final query = _conversationBox
        .query(Conversation_.conversationId.equals(conversationId))
        .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  Future<List<Conversation>> getAllConversations() async {
    final query = _conversationBox
        .query()
        .order(Conversation_.lastMessageTime, flags: Order.descending)
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  Future<void> _updateConversation(Message message) async {
    var conversation = await getConversation(message.conversationId);
    
    if (conversation == null) {
      conversation = Conversation(
        conversationId: message.conversationId,
      );
    }

    // Mettre à jour avec le dernier message
    if (message.type == MessageType.text) {
      try {
        final encryptedData = jsonDecode(message.encryptedContent);
        // Pour l'aperçu, on ne peut pas déchiffrer ici, donc on montre juste un indicateur
        conversation.lastMessagePreview = message.isSentByMe 
            ? 'Vous: [Message chiffré]' 
            : '[Message chiffré]';
      } catch (e) {
        conversation.lastMessagePreview = message.encryptedContent.length > 50
            ? '${message.encryptedContent.substring(0, 50)}...'
            : message.encryptedContent;
      }
    } else {
      conversation.lastMessagePreview = message.isSentByMe
          ? 'Vous: ${_getMessageTypeLabel(message.type)}'
          : _getMessageTypeLabel(message.type);
    }

    conversation.lastMessageTime = message.timestamp;

    if (!message.isSentByMe && !message.isRead) {
      conversation.unreadCount++;
    }

    _conversationBox.put(conversation);
  }

  String _getMessageTypeLabel(MessageType type) {
    switch (type) {
      case MessageType.audio:
        return '🎤 Message vocal';
      case MessageType.image:
        return '🖼️ Image';
      case MessageType.file:
        return '📎 Fichier';
      default:
        return 'Message';
    }
  }

  Future<void> updateConversationTyping(String conversationId, bool isTyping) async {
    final conversation = await getConversation(conversationId);
    if (conversation != null) {
      conversation.isTyping = isTyping;
      conversation.lastTypingTime = isTyping ? DateTime.now() : null;
      _conversationBox.put(conversation);
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    // Supprimer la conversation
    final conversation = await getConversation(conversationId);
    if (conversation != null) {
      _conversationBox.remove(conversation.id);
    }

    // Supprimer tous les messages
    final query = _messageBox
        .query(Message_.conversationId.equals(conversationId))
        .build();
    final messages = query.find();
    _messageBox.removeMany(messages.map((m) => m.id).toList());
    query.close();
  }

  // === Statistiques ===

  Future<int> getTotalMessageCount() async {
    return _messageBox.count();
  }

  Future<int> getTotalContactCount() async {
    return _contactBox.count();
  }

  /// Ferme le store
  void close() {
    _store.close();
  }
}


