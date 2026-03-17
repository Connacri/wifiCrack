import 'package:flutter/material.dart';
import '../../data/sources/local_storage.dart';

class LocaleProvider extends ChangeNotifier {
  final LocalStorageDataSource _storage;
  Locale? _locale;

  LocaleProvider(this._storage) {
    _loadLocale();
  }

  Locale? get locale => _locale;

  void _loadLocale() {
    final languageCode = _storage.getLocale();
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _storage.setLocale(locale.languageCode);
    notifyListeners();
  }
}
