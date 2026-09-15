import 'package:flutter/material.dart';

import ' screens/dashboard_screen.dart';
import ' screens/form_screen.dart';
import ' screens/login_screen.dart';
import ' screens/register_screen.dart';



void main() {
  runApp(const MaterialDesignApp());
}

class MaterialDesignApp extends StatelessWidget {
  const MaterialDesignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material Design App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/form': (context) => const FormScreen(),
      },
    );
  }
}
