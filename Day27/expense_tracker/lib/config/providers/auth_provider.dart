import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  late final StreamSubscription<AuthState> _subscription;

  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._service) {
    _user = _service.currentUser;
    _subscription = _service.authStateChanges.listen((state) {
      _user = state.session?.user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> signIn(String email, String password) {
    return _run(() => _service.signIn(email: email, password: password));
  }

  /// Returns true on success. When "Confirm email" is enabled in Supabase,
  /// the user is not logged in until the email is confirmed.
  Future<bool> signUp(String email, String password) {
    return _run(() => _service.signUp(email: email, password: password));
  }

  Future<void> signOut() async {
    await _service.signOut();
  }

  Future<bool> _run(Future<AuthResponse> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await action();
      // Update right away instead of waiting for the auth stream event.
      if (response.session != null) _user = response.user;
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
