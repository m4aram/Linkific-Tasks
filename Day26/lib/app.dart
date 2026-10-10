import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MahamiApp extends StatelessWidget {
  const MahamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds whenever the theme mode (light/dark) changes
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp.router(
          title: 'Mahami',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          // Switch to Locale('ar') to get an RTL layout automatically
          locale: const Locale('en'),
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: appRouter,
        );
      },
    );
  }
}
