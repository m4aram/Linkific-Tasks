import 'package:flutter/material.dart';
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/theme/app_theme.dart';
import 'package:shoplite/features/auth/presentation/auth_gate.dart';

class ShopLiteApp extends StatelessWidget {
  const ShopLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}
