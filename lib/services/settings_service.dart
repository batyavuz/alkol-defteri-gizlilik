import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles theme, typography scale and backup preferences.
class SettingsService extends ChangeNotifier {
  static const _themeKey = 'mindmirror_theme';
  static const _fontScaleKey = 'mindmirror_font_scale';
  static const _backupKey = 'mindmirror_backup';

  ThemeMode _themeMode = ThemeMode.system;
  double _fontScale = 1.0;
  bool _backupEnabled = false;

  ThemeMode get themeMode => _themeMode;
  double get fontScale => _fontScale;
  bool get backupEnabled => _backupEnabled;

  /// Hydrates state from local preferences.
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeValue = prefs.getString(_themeKey);
    switch (themeValue) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    _fontScale = prefs.getDouble(_fontScaleKey) ?? 1.0;
    _backupEnabled = prefs.getBool(_backupKey) ?? false;
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await prefs.setString(_themeKey, value);
    notifyListeners();
  }

  Future<void> updateFontScale(double scale) async {
    _fontScale = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontScaleKey, scale);
    notifyListeners();
  }

  Future<void> updateBackup(bool enabled) async {
    _backupEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backupKey, enabled);
    notifyListeners();
  }
}
