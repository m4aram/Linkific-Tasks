import 'package:flutter/foundation.dart';

enum AuthStatus { loggedOut, loading, loggedIn }

class AppUser {
  final String email;
  final String name;
  const AppUser({required this.email, required this.name});
}

/// Authentication state shared by the whole app.
/// The login here is simulated (1 second delay) so the demo works without a backend.
/// To use a real backend (for example Supabase) only the body of login()/logout() changes;
/// the screens that listen to this provider stay exactly the same.
class AuthProvider extends ChangeNotifier {
  static const String demoEmail = 'demo@example.com';
  static const String demoPassword = '123456';

  AuthStatus _status = AuthStatus.loggedOut;
  AppUser? _user;
  String? _error;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get error => _error;
  bool get isLoggedIn => _status == AuthStatus.loggedIn;
  bool get isLoading => _status == AuthStatus.loading;

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 1)); // fake network call

    final ok = email.trim().toLowerCase() == demoEmail && password == demoPassword;
    if (ok) {
      _user = AppUser(email: email.trim().toLowerCase(), name: 'Demo User');
      _status = AuthStatus.loggedIn;
    } else {
      _user = null;
      _status = AuthStatus.loggedOut;
      _error = 'Wrong email or password.';
    }
    notifyListeners();
    return ok;
  }

  void logout() {
    _user = null;
    _error = null;
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }
}
