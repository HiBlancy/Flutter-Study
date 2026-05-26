
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notifications_coordinator.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('es');
  static const String _localeKey = 'app_locale';

  LocaleProvider() {
    _loadLocale();
  }

  Locale get locale => _locale;

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);

    if (languageCode != null && languageCode.isNotEmpty) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    NotificationsCoordinator.refresh();
  }

  void setSpanish() async {
    _locale = const Locale('es');
    await _saveLocale(_locale);
    notifyListeners();
  }

  void setEnglish() async {
    _locale = const Locale('en');
    await _saveLocale(_locale);
    notifyListeners();
  }

  void setRussian() async {
    _locale = const Locale('ru');
    await _saveLocale(_locale);
    notifyListeners();
  }

  void setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    await _saveLocale(_locale);
    notifyListeners();
  }
}