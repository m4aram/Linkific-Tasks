import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import ' theme/app_theme.dart';
import ' theme/theme_provider.dart';
import 'screens/home_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final themeProvider = ThemeProvider(preferences);
  runApp(ThemeProviderScope(themeProvider: themeProvider));
}

class ThemeProviderScope extends InheritedNotifier<ThemeProvider> {
  final ThemeProvider themeProvider;

  const ThemeProviderScope({super.key, required this.themeProvider})
    : super(notifier: themeProvider, child: const ThemingApp());

  static ThemeProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ThemeProviderScope>()!
        .themeProvider;
  }
}

class ThemingApp extends StatelessWidget {
  const ThemingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProviderScope.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Theming App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const HomeScreen(),
    );
  }
}
