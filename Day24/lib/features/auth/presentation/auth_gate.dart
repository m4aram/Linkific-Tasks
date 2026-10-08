import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoplite/core/constants/app_assets.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/features/auth/logic/auth_controller.dart';
import 'package:shoplite/features/auth/presentation/login_screen.dart';
import 'package:shoplite/features/home/presentation/home_shell.dart';

/// First widget of the app: shows the login screen or the app depending
/// on the session. Screens never navigate after login/logout themselves;
/// they change the auth state and this gate reacts.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `select`: rebuild only when the status changes, not on every field.
    final status = ref.watch(
      authControllerProvider.select((state) => state.status),
    );

    final Widget child;
    switch (status) {
      case AuthStatus.unknown:
        child = const _StartupView(key: ValueKey('startup'));
      case AuthStatus.authenticated:
        child = const HomeShell(key: ValueKey('home'));
      case AuthStatus.unauthenticated:
        child = const LoginScreen(key: ValueKey('login'));
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}

class _StartupView extends StatelessWidget {
  const _StartupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.logo,
              width: 96,
              height: 96,
              semanticsLabel: AppStrings.logoLabel,
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                semanticsLabel: AppStrings.loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
