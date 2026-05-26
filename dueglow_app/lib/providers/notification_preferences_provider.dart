import 'package:flutter/foundation.dart';
import '../services/notification_preferences_service.dart';
import '../services/notification_scheduler.dart';
import '../services/notification_service.dart';

class NotificationPreferencesProvider extends ChangeNotifier {
  final NotificationPreferencesService _prefsService =
      NotificationPreferencesService();

  NotificationSettings _settings = NotificationSettings.defaults();
  bool _loaded = false;

  NotificationSettings get settings => _settings;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    _settings = await _prefsService.load();
    _loaded = true;
    notifyListeners();
  }

  Future<void> setMasterEnabled(bool value) async {
    if (value) {
      final granted = await NotificationService.instance.requestPermission();
      if (!granted) return;
    } else {
      await NotificationService.instance.cancelAll();
    }

    _settings = NotificationSettings(
      masterEnabled: value,
      expirationEnabled: _settings.expirationEnabled,
      routinesEnabled: _settings.routinesEnabled,
      weeklyDigestEnabled: _settings.weeklyDigestEnabled,
    );
    await _persistAndSync();
  }

  Future<void> setExpirationEnabled(bool value) async {
    _settings = NotificationSettings(
      masterEnabled: _settings.masterEnabled,
      expirationEnabled: value,
      routinesEnabled: _settings.routinesEnabled,
      weeklyDigestEnabled: _settings.weeklyDigestEnabled,
    );
    await _persistAndSync();
  }

  Future<void> setRoutinesEnabled(bool value) async {
    _settings = NotificationSettings(
      masterEnabled: _settings.masterEnabled,
      expirationEnabled: _settings.expirationEnabled,
      routinesEnabled: value,
      weeklyDigestEnabled: _settings.weeklyDigestEnabled,
    );
    await _persistAndSync();
  }

  Future<void> setWeeklyDigestEnabled(bool value) async {
    _settings = NotificationSettings(
      masterEnabled: _settings.masterEnabled,
      expirationEnabled: _settings.expirationEnabled,
      routinesEnabled: _settings.routinesEnabled,
      weeklyDigestEnabled: value,
    );
    await _persistAndSync();
  }

  Future<void> _persistAndSync() async {
    await _prefsService.save(_settings);
    notifyListeners();
    if (_settings.masterEnabled) {
      await NotificationScheduler.instance.syncAll();
    }
  }
}
