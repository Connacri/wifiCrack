import '../objectbox.g.dart';
import 'contact.dart';
import 'user.dart';
import 'objectbox_service.dart';

class ContactService {
  final ObjectBoxService _objectBox;

  ContactService(this._objectBox);

  // ─── Vérifications ────────────────────────────────────────────────────────
  bool isContact(String deviceId) {
    return _objectBox.contactBox
        .query(M2CContact_.deviceId.equals(deviceId))
        .build()
        .findFirst() !=
        null;
  }

  // ─── Ajout / Suppression ──────────────────────────────────────────────────
  bool addContact(M2CContact contact) {
    if (isContact(contact.deviceId)) return false;
    _objectBox.contactBox.put(contact);
    return true;
  }

  void removeContact(String deviceId) {
    final contact = _objectBox.contactBox
        .query(M2CContact_.deviceId.equals(deviceId))
        .build()
        .findFirst();
    if (contact != null) {
      _objectBox.contactBox.remove(contact.id);
    }
  }

  // ─── Lecture ──────────────────────────────────────────────────────────────
  List<M2CContact> getContacts() {
    return _objectBox.contactBox.getAll();
  }

  M2CContact? getContact(String deviceId) {
    return _objectBox.contactBox
        .query(M2CContact_.deviceId.equals(deviceId))
        .build()
        .findFirst();
  }

  /// Stream réactif des contacts (trié par dernier message)
  Stream<List<M2CContact>> watchContacts() {
    return _objectBox.watchContacts();
  }

  // ─── Mise à jour du preview ───────────────────────────────────────────────
  void updateContactPreview({
    required String deviceId,
    required String preview,
    required DateTime messageAt,
    bool incrementUnread = false,
  }) {
    final contact = getContact(deviceId);
    if (contact == null) return;
    contact.lastMessagePreview = preview;
    contact.lastMessageAt = messageAt;
    if (incrementUnread) contact.unreadCount++;
    _objectBox.contactBox.put(contact);
  }

  void resetUnreadCount(String deviceId) {
    final contact = getContact(deviceId);
    if (contact == null) return;
    contact.unreadCount = 0;
    _objectBox.contactBox.put(contact);
  }

  // ─── User ─────────────────────────────────────────────────────────────────
  M2CUser? getUser(String deviceId) {
    return _objectBox.userBox
        .query(M2CUser_.deviceId.equals(deviceId))
        .build()
        .findFirst();
  }
}
