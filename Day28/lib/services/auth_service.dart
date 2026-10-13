import 'package:supabase_flutter/supabase_flutter.dart';

/// Talks to Supabase Auth.
class AuthService {
  final SupabaseClient? _injectedClient;

  AuthService({SupabaseClient? client}) : _injectedClient = client;

  // Resolved lazily so tests can subclass this service without
  // initializing Supabase.
  SupabaseClient get _client => _injectedClient ?? Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> sendPasswordReset(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() => _client.auth.signOut();
}
