import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth_gate.dart';
import 'services/auth_service.dart';
import 'services/expense_service.dart';
import 'theme/app_theme.dart';
import 'widgets/empty_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (_) {
    // The app still works without a saved theme preference.
  }

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.anonKey,
    );
  } catch (_) {
    runApp(const StartupErrorApp());
    return;
  }

  runApp(ExpenseTrackerApp(prefs: prefs));
}

class ExpenseTrackerApp extends StatelessWidget {
  final SharedPreferences? prefs;

  const ExpenseTrackerApp({super.key, this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs: prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(ExpenseService()),
        ),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: context.select<ThemeProvider, ThemeMode>((t) => t.mode),
          home: const AuthGate(),
        ),
      ),
    );
  }
}

/// Shown only if Supabase could not be initialized (for example a wrong
/// project URL in `supabase_config.dart`), instead of a blank screen.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const Scaffold(
        body: Center(
          child: EmptyState(
            icon: Icons.cloud_off_outlined,
            title: 'Could not start Expense Tracker',
            message: 'The app could not connect to its server. '
                'Close the app and open it again.',
            isError: true,
          ),
        ),
      ),
    );
  }
}
