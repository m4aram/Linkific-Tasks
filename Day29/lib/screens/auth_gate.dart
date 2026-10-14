import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Shows the Home screen when logged in, otherwise the Login screen.
///
/// When the user is logged out (by the button or because the session
/// expired) it closes any open screens and clears the previous user's data.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool? _wasLoggedIn;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((a) => a.isLoggedIn);

    if (_wasLoggedIn == true && !isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.read<ExpenseProvider>().clear();
      });
    }
    _wasLoggedIn = isLoggedIn;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isLoggedIn
          ? const HomeScreen(key: ValueKey('home'))
          : const LoginScreen(key: ValueKey('login')),
    );
  }
}
