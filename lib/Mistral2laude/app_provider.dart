import 'package:flutter/foundation.dart';

import 'contact.dart';
import 'contact_service.dart';
import 'objectbox_service.dart';
import 'user.dart';

/// Provider central de l'application Mistral2laude
class AppProvider extends ChangeNotifier {
  final ObjectBoxService objectBox;
  final ContactService contactService;

  M2CUser _currentUser;

  AppProvider(this.objectBox, M2CUser initialUser)
    : contactService = ContactService(objectBox),
      _currentUser = initialUser;

  // ─── User ─────────────────────────────────────────────────────────────────
  M2CUser get currentUser => _currentUser;

  void updatePseudo(String pseudo) {
    _currentUser = _currentUser.copyWith(pseudo: pseudo);
    objectBox.userBox.put(_currentUser);
    notifyListeners();
  }

  void updateLastSeen() {
    _currentUser = _currentUser.copyWith(lastSeen: DateTime.now());
    objectBox.userBox.put(_currentUser);
  }

  void addCoins(int amount) {
    _currentUser = _currentUser.copyWith(coins: _currentUser.coins + amount);
    objectBox.userBox.put(_currentUser);
    notifyListeners();
  }

  // ─── Contacts ─────────────────────────────────────────────────────────────
  Stream<List<M2CContact>> get contactsStream => contactService.watchContacts();
}
