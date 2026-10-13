import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Light / dark / system theme, remembered between app launches.
class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_mode';

  final SharedPreferences? _prefs;
  ThemeMode _mode;

  ThemeProvider({SharedPreferences? prefs})
      : _prefs = prefs,
        _mode = _decode(prefs?.getString(_key));

  ThemeMode get mode => _mode;

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    try {
      await _prefs?.setString(_key, mode.name);
    } catch (_) {
      // Saving the preference is best effort; the theme still changes now.
    }
  }

  static ThemeMode _decode(String? value) {
    return ThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
