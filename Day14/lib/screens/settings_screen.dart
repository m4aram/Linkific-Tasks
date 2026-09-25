import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final VoidCallback onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.prefs,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService service = PreferencesService();
  late bool notificationsEnabled;
  late bool isLoggedIn;
  late String language;

  @override
  void initState() {
    super.initState();
    notificationsEnabled = service.getNotifications(widget.prefs);

    isLoggedIn = service.isLoggedIn(widget.prefs);

    language = service.getLanguage(widget.prefs);
  }

  Future<void> toggleNotifications(bool value) async {
    await service.setNotifications(value);
    setState(() {
      notificationsEnabled = value;
    });
  }

  Future<void> toggleLogin(bool value) async {
    await service.setLoggedIn(value);
    setState(() {
      isLoggedIn = value;
    });
  }

  Future<void> changeLanguage(String? value) async {
    if (value == null) return;
    await service.setLanguage(value);

    setState(() {
      language = value;
    });
  }

  Future<void> changeTheme(bool dark) async {
    await service.setTheme(dark ? 'dark' : 'light');
    widget.onThemeChanged();
  }
  Future<void> removeLanguage() async {
    await service.remove(
      PreferencesService.languageKey,
    );

    setState(() {
      language = 'English';
    });
  }
  Future<void> clearPreferences() async {
    await service.clear();
    setState(() {
      notificationsEnabled = true;
      isLoggedIn = false;
      language = 'English';
    });

    widget.onThemeChanged();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = service.getTheme(widget.prefs) == 'dark';
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: isDark,
            onChanged: changeTheme,
          ),

          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: language,
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
              ],
              onChanged: changeLanguage,
            ),
          ),
          ListTile(
            title: const Text('Remove Language'),
            trailing: const Icon(Icons.delete_outline),

            onTap: removeLanguage,
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: notificationsEnabled,
            onChanged: toggleNotifications,
          ),

          SwitchListTile(
            title: const Text('Login State'),
            value: isLoggedIn,
            onChanged: toggleLogin,
          ),

          ListTile(
            title: const Text('Clear Preferences'),
            onTap: clearPreferences,
          ),
        ],
      ),
    );
  }
}
