import 'package:flutter/material.dart';

import 'navigation/bottom_navigation_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';
import 'screens/details_screen.dart';

void main() {
  runApp(const NavigationApp());
}

class NavigationApp extends StatelessWidget {
  const NavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Demo',
      // الصفحة الرئيسية
      initialRoute: '/',

      // Named Routes
      routes: {
        // مهم: نبدأ بـ BottomNavigationScreen
        '/': (context) => const BottomNavigationScreen(),

        '/profile': (context) => const ProfileScreen(),

        '/settings': (context) => const SettingsScreen(),

        '/about': (context) => const AboutScreen(),
      },

      // Details + Passing Arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final data = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(data: data);
            },
          );
        }

        return null;
      },
    );
  }
}
