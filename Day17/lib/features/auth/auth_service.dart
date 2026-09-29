import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase;

  AuthService(this.supabase);

  // =========================
  // إنشاء حساب
  // =========================
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // =========================
  // تسجيل الدخول
  // =========================
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // =========================
  // Magic Link
  // =========================
  Future<void> sendMagicLink(String email) async {
    await supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.flutter://login-callback/',
    );
  }

  // =========================
  // تسجيل الدخول بواسطة Google
  // =========================
  Future<bool> signInWithGoogle() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback/',
    );
  }

  // =========================
  // تسجيل الخروج
  // =========================
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // =========================
  // المستخدم الحالي
  // =========================
  User? get currentUser {
    return supabase.auth.currentUser;
  }

  // =========================
  // الجلسة الحالية
  // =========================
  Session? get currentSession {
    return supabase.auth.currentSession;
  }

  // =========================
  // هل المستخدم مسجل دخول؟
  // =========================
  bool get isLoggedIn {
    return supabase.auth.currentSession != null;
  }
}