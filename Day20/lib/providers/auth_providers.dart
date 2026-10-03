import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { loggedOut, loading, loggedIn }

class AppUser {
  final String email;
  final String name;
  const AppUser({required this.email, required this.name});
}

/// The whole auth state in one immutable object.
class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? error;

  const AuthState({this.status = AuthStatus.loggedOut, this.user, this.error});

  bool get isLoggedIn => status == AuthStatus.loggedIn;
  bool get isLoading => status == AuthStatus.loading;
}

/// Notifier = the modern Riverpod 3 way (replaces StateNotifier).
/// build() returns the initial state, and `state` can be read and assigned inside the class.
/// The login is simulated (1 second) so the demo works without a backend.
class AuthNotifier extends Notifier<AuthState> {
  static const String demoEmail = 'demo@example.com';
  static const String demoPassword = '123456';

  @override
  AuthState build() => const AuthState();

  Future<bool> login(String email, String password) async {
    state = const AuthState(status: AuthStatus.loading);

    await Future<void>.delayed(const Duration(seconds: 1)); // fake network call

    final ok = email.trim().toLowerCase() == demoEmail && password == demoPassword;
    if (ok) {
      state = AuthState(
        status: AuthStatus.loggedIn,
        user: AppUser(email: email.trim().toLowerCase(), name: 'Demo User'),
      );
    } else {
      state = const AuthState(error: 'Wrong email or password.');
    }
    return ok;
  }

  void logout() => state = const AuthState();
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Provider<bool> = a small derived value. Widgets that watch it rebuild
/// only when it flips between true and false, not on every auth change (loading, error...).
final isMemberProvider = Provider<bool>((ref) => ref.watch(authProvider).isLoggedIn);
