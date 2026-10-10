import 'package:flutter/material.dart';

/// Splash screen: shown while Firebase checks for a saved session.
/// No manual navigation here: the router moves the user (see app_router.dart).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 96, color: scheme.onPrimary),
            const SizedBox(height: 16),
            Text(
              'Mahami',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: scheme.onPrimary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.6, color: scheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
