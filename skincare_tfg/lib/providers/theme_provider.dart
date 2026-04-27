
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const String _themeKey = 'theme_mode';

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {

    return _themeMode == ThemeMode.dark;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeKey);

    if (themeModeIndex != null && themeModeIndex >= 0 && themeModeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeModeIndex];
      notifyListeners();
    }
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  void setLightMode() async {
    _themeMode = ThemeMode.light;
    await _saveTheme(_themeMode);
    notifyListeners();
  }

  void setDarkMode() async {
    _themeMode = ThemeMode.dark;
    await _saveTheme(_themeMode);
    notifyListeners();
  }

  void setSystemMode() async {
    _themeMode = ThemeMode.system;
    await _saveTheme(_themeMode);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setDarkMode();
    } else if (_themeMode == ThemeMode.dark) {
      setLightMode();
    } else {


      setDarkMode();
    }
  }
}