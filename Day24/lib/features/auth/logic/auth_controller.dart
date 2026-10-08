import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/network/api_exception.dart';
import 'package:shoplite/features/auth/data/auth_repository.dart';
import 'package:shoplite/features/auth/data/user_model.dart';

enum AuthStatus {
  /// Still checking the device for a saved session.
  unknown,
  authenticated,
  unauthenticated,
}

@immutable
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isSubmitting = false,
    this.error,
  });

  final AuthStatus status;

  /// Null while signed in offline (token present, profile not loaded).
  final AppUser? user;
  final bool isSubmitting;
  final String? error;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState()) {
    restoreSession();
  }

  final AuthRepository _repository;

  static const AuthState _signedOut = AuthState(
    status: AuthStatus.unauthenticated,
  );

  // The notifier can be disposed while a request is in flight.
  void _emit(AuthState next) {
    if (mounted) state = next;
  }

  /// Runs once at startup: decides between the login screen and the app.
  Future<void> restoreSession() async {
    try {
      if (!await _repository.hasSession()) {
        _emit(_signedOut);
        return;
      }
      await _loadUser();
    } catch (_) {
      _emit(_signedOut);
    }
  }

  /// Re-fetches the profile (used by the profile screen's retry).
  Future<void> refreshUser() => _loadUser();

  Future<void> _loadUser() async {
    try {
      final user = await _repository.fetchCurrentUser();
      _emit(AuthState(status: AuthStatus.authenticated, user: user));
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        // The token expired or was revoked: drop it and ask to sign in.
        await _repository.logout();
        _emit(_signedOut);
      } else {
        // Offline or server trouble: keep the session, show what we can.
        _emit(AuthState(status: AuthStatus.authenticated, user: state.user));
      }
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    _emit(
      const AuthState(status: AuthStatus.unauthenticated, isSubmitting: true),
    );
    try {
      final user = await _repository.login(
        username: username,
        password: password,
      );
      _emit(AuthState(status: AuthStatus.authenticated, user: user));
    } on ApiException catch (e) {
      _emit(AuthState(status: AuthStatus.unauthenticated, error: e.message));
    } catch (_) {
      _emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: AppStrings.errorUnexpected,
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      _emit(_signedOut);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
