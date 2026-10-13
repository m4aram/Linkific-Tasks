import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import '../utils/error_messages.dart';

class AuthProvider extends ChangeNotifier {
  static const Duration _timeout = Duration(seconds: 20);

  final AuthService _service;
  StreamSubscription<AuthState>? _subscription;

  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._service) {
    _user = _service.currentUser;
    _subscription = _service.authStateChanges.listen(
      (state) {
        final next = state.session?.user;
        final changed = next?.id != _user?.id;
        _user = next;
        // Token refreshes fire often; only rebuild when the user changes.
        if (changed) notifyListeners();
      },
      onError: (Object _) {},
    );
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> signIn(String email, String password) {
    return _run(() async {
      final response = await _service
          .signIn(email: _normalize(email), password: password)
          .timeout(_timeout);
      _user = response.user ?? _user;
    });
  }

  /// Returns true on success. When "Confirm email" is enabled in Supabase,
  /// the user is not logged in until the email is confirmed.
  Future<bool> signUp(String email, String password) {
    return _run(() async {
      final response = await _service
          .signUp(email: _normalize(email), password: password)
          .timeout(_timeout);
      // With "Confirm email" on, Supabase hides duplicate sign-ups by
      // returning a user with no identities instead of an error.
      final identities = response.user?.identities;
      if (identities != null && identities.isEmpty) {
        throw const AuthException('User already registered');
      }
      if (response.session != null) _user = response.user;
    });
  }

  Future<bool> sendPasswordReset(String email) {
    return _run(
      () => _service.sendPasswordReset(_normalize(email)).timeout(_timeout),
    );
  }

  Future<bool> signOut() {
    return _run(() async {
      await _service.signOut().timeout(_timeout);
      _user = null;
    });
  }

  Future<bool> _run(Future<void> Function() action) async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _error = friendlyError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _normalize(String email) => email.trim().toLowerCase();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
