import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';
import 'contact.dart';
import 'message.dart';
import 'user.dart';

/// Service ObjectBox - Singleton robuste pour Mistral2laude
class ObjectBoxService {
  static final ObjectBoxService _instance = ObjectBoxService._internal();
  factory ObjectBoxService() => _instance;
  ObjectBoxService._internal();

  Store? _store;
  bool _isInitialized = false;

  // ─── Getters Guards ──────────────────────────────────────────────────────
  Box<M2CMessage> get messageBox {
    _assertInit();
    return _store!.box<M2CMessage>();
  }

  Box<M2CContact> get contactBox {
    _assertInit();
    return _store!.box<M2CContact>();
  }

  Box<M2CUser> get userBox {
    _assertInit();
    return _store!.box<M2CUser>();
  }

  bool get isInitialized => _isInitialized;

  // ─── Initialisation ───────────────────────────────────────────────────────
  Future<void> init() async {
    if (_isInitialized && _store != null) return;

    try {
      if (_store != null) {
        _store!.close();
        _store = null;
      }

      final dir = await getApplicationDocumentsDirectory();
      final storePath = '${dir.path}/obx_mistral2laude_v5';

      _store = Store(getObjectBoxModel(), directory: storePath);

      _isInitialized = true;
      debugPrint('[ObjectBox] M2C Store initialisé → $storePath');
    } catch (e) {
      debugPrint('[ObjectBox] M2C ERREUR init: $e');
      rethrow;
    }
  }

  // ─── Messages : requête bidirectionnelle optimisée ────────────────────────
  Stream<List<M2CMessage>> watchConversation({
    required String myDeviceId,
    required String friendDeviceId,
  }) {
    _assertInit();
    final condition =
        (M2CMessage_.senderDeviceId.equals(myDeviceId) &
            M2CMessage_.receiverDeviceId.equals(friendDeviceId)) |
        (M2CMessage_.senderDeviceId.equals(friendDeviceId) &
            M2CMessage_.receiverDeviceId.equals(myDeviceId));

    // FIX: watch est sur QueryBuilder (pas sur Query)
    final queryBuilder = _store!
        .box<M2CMessage>()
        .query(condition)
        .order(M2CMessage_.timestamp);

    return queryBuilder.watch(triggerImmediately: true).map((q) => q.find());
  }

  // ─── Contacts ─────────────────────────────────────────────────────────────
  Stream<List<M2CContact>> watchContacts() {
    _assertInit();

    // FIX: watch est sur QueryBuilder (pas sur Query)
    final queryBuilder = _store!
        .box<M2CContact>()
        .query()
        .order(M2CContact_.lastMessageAt, flags: Order.descending);

    return queryBuilder.watch(triggerImmediately: true).map((q) => q.find());
  }

  // ─── Fermeture ────────────────────────────────────────────────────────────
  void close() {
    if (_store != null && !_store!.isClosed()) {
      _store!.close();
    }
    _isInitialized = false;
    _store = null;
  }

  void _assertInit() {
    if (!_isInitialized || _store == null) {
      throw StateError(
        '[ObjectBox] M2C Service non initialisé. Appelez init() d\'abord.',
      );
    }
  }
}
