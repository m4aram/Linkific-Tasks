import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/settings_screen.dart';
import 'services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final service = PreferencesService();
  // First Launch if (service.isFirstLaunch(prefs)) { await service.setFirstLaunch(false); }
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PreferencesService service = PreferencesService();
  bool darkTheme = false;

  @override
  void initState() {
    super.initState();
    darkTheme = service.getTheme(widget.prefs) == 'dark';
  }

  void refreshTheme() {
    setState(() {
      darkTheme = service.getTheme(widget.prefs) == 'dark';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SharedPreferences App',

      theme: ThemeData.light(),

      darkTheme: ThemeData.dark(),

      themeMode: darkTheme ? ThemeMode.dark : ThemeMode.light,

      home: SettingsScreen(prefs: widget.prefs, onThemeChanged: refreshTheme),
    );
  }
}
