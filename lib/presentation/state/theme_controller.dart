import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController() {
    _loadSettings();
  }

  ThemeMode _themeMode = ThemeMode.dark;
  Color _seedColor = const Color(0xFF6C63FF);
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;
  bool get isInitialized => _isInitialized;

  static const String _keyThemeMode = 'app_theme_mode';
  static const String _keySeedColor = 'app_seed_color';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final modeIndex = prefs.getInt(_keyThemeMode);
    if (modeIndex != null) {
      _themeMode = ThemeMode.values[modeIndex];
    }

    final colorValue = prefs.getInt(_keySeedColor);
    if (colorValue != null) {
      _seedColor = Color(colorValue);
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  Future<void> setSeedColor(Color color) async {
    if (_seedColor == color) return;
    _seedColor = color;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySeedColor, color.value);
  }
}
