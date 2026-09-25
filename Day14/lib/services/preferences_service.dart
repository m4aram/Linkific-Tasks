import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String isLoggedInKey = 'isLoggedIn';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notificationsEnabled';
  static const String firstLaunchKey = 'firstLaunch';
  static const String usernameKey = 'username';
  static const String ageKey = 'age';
  static const String ratingKey = 'rating';
  static const String tagsKey = 'tags';

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // STRING
  Future<void> setUsername(String value) async {
    final prefs = await _prefs;
    await prefs.setString(usernameKey, value);
  }

  String? getUsername(SharedPreferences prefs) {
    return prefs.getString(usernameKey);
  }

  // INT
  Future<void> setAge(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(ageKey, value);
  }

  int getAge(SharedPreferences prefs) {
    return prefs.getInt(ageKey) ?? 0;
  }

  // BOOL
  Future<void> setLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(isLoggedInKey, value);
  }

  bool isLoggedIn(SharedPreferences prefs) {
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  // DOUBLE
  Future<void> setRating(double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(ratingKey, value);
  }

  double getRating(SharedPreferences prefs) {
    return prefs.getDouble(ratingKey) ?? 0.0;
  }

  // STRING LIST
  Future<void> setTags(List<String> value) async {
    final prefs = await _prefs;
    await prefs.setStringList(tagsKey, value);
  }

  List<String> getTags(SharedPreferences prefs) {
    return prefs.getStringList(tagsKey) ?? [];
  }

  // THEME
  Future<void> setTheme(String value) async {
    final prefs = await _prefs;
    await prefs.setString(themeKey, value);
  }

  String getTheme(SharedPreferences prefs) {
    return prefs.getString(themeKey) ?? 'light';
  }

  // LANGUAGE
  Future<void> setLanguage(String value) async {
    final prefs = await _prefs;
    await prefs.setString(languageKey, value);
  }

  String getLanguage(SharedPreferences prefs) {
    return prefs.getString(languageKey) ?? 'English';
  }

  // NOTIFICATIONS
  Future<void> setNotifications(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(notificationsKey, value);
  }

  bool getNotifications(SharedPreferences prefs) {
    return prefs.getBool(notificationsKey) ?? true;
  }

  // FIRST LAUNCH
  Future<void> setFirstLaunch(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(firstLaunchKey, value);
  }

  bool isFirstLaunch(SharedPreferences prefs) {
    return prefs.getBool(firstLaunchKey) ?? true;
  }

  // REMOVE
  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  // CLEAR
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
