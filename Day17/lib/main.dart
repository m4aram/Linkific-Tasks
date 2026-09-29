
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/login_page.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mlbbrvumnchhclbaffjt.supabase.co',
    anonKey: 'sb_publishable_Afbr0x24iJauTJSXSuce_w_AnHqneya',);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Flutter App',
      home: const AuthGate(),);
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}