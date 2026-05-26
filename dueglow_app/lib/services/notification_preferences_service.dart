import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class NotificationSettings {
  final bool masterEnabled;
  final bool expirationEnabled;
  final bool routinesEnabled;
  final bool weeklyDigestEnabled;

  const NotificationSettings({
    required this.masterEnabled,
    required this.expirationEnabled,
    required this.routinesEnabled,
    required this.weeklyDigestEnabled,
  });

  factory NotificationSettings.defaults() => const NotificationSettings(
        masterEnabled: true,
        expirationEnabled: true,
        routinesEnabled: true,
        weeklyDigestEnabled: true,
      );
}

class NotificationPreferencesService {
  Future<NotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final defaults = NotificationSettings.defaults();
    return NotificationSettings(
      masterEnabled:
          prefs.getBool(AppConstants.prefNotificationsEnabled) ?? defaults.masterEnabled,
      expirationEnabled:
          prefs.getBool(AppConstants.prefNotifExpiration) ?? defaults.expirationEnabled,
      routinesEnabled:
          prefs.getBool(AppConstants.prefNotifRoutines) ?? defaults.routinesEnabled,
      weeklyDigestEnabled: prefs.getBool(AppConstants.prefNotifWeeklyDigest) ??
          defaults.weeklyDigestEnabled,
    );
  }

  Future<void> save(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefNotificationsEnabled, settings.masterEnabled);
    await prefs.setBool(AppConstants.prefNotifExpiration, settings.expirationEnabled);
    await prefs.setBool(AppConstants.prefNotifRoutines, settings.routinesEnabled);
    await prefs.setBool(
      AppConstants.prefNotifWeeklyDigest,
      settings.weeklyDigestEnabled,
    );
  }

  Future<String> getLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('app_locale') ?? 'es';
  }
}
