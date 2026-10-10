import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/tasks/tasks_screen.dart';

/// Listens to the auth state and notifies the router on every change.
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    // Keep the splash visible briefly even if Firebase answers instantly
    final minSplash = Future<void>.delayed(const Duration(milliseconds: 1200));
    _sub = FirebaseAuth.instance.authStateChanges().listen((u) async {
      user = u;
      if (!ready) {
        await minSplash;
        ready = true;
      }
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _sub;
  User? user;
  bool ready = false; // false = still checking the saved session (splash)

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final AuthNotifier authNotifier = AuthNotifier();

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: authNotifier, // re-run redirect when auth state changes
  redirect: (context, state) {
    final loc = state.matchedLocation;

    // 1. Auth state not known yet -> splash
    if (!authNotifier.ready) return loc == '/splash' ? null : '/splash';

    final loggedIn = authNotifier.user != null;
    final onPublic = loc == '/login' || loc == '/register';

    // 2. Signed out and opening a protected route -> login
    if (!loggedIn) return onPublic ? null : '/login';

    // 3. Signed in but on a public route or splash -> home
    if (onPublic || loc == '/splash') return '/home';

    return null; // stay where we are
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

    // Protected routes: bottom bar with three tabs, each tab keeps its own state
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/tasks', builder: (_, __) => const TasksScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ]),
      ],
    ),
  ],
);
