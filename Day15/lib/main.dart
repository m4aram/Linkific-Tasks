import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/secure_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = SecureStorageService();

  final api = ApiService(storage);

  final authService = AuthService(api: api, storage: storage);

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JWT Authentication',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: SplashScreen(authService: authService),
    );
  }
}
