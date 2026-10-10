import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'user_repository.dart';

/// Everything related to Firebase Auth in one place.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;

  Future<void> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  /// Creates the account, then stores the user profile in Firestore.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user!;
    await userRepository.createUser(uid: user.uid, name: name.trim(), email: email.trim());
    await user.updateDisplayName(name.trim());
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() => _auth.signOut();

  /// Maps Firebase error codes to readable messages.
  static String messageFor(Object error) {
    debugPrint('Auth error: $error'); // full details in the Run console
    if (error is! FirebaseAuthException) return 'Something went wrong, please try again';
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts, please wait and try again';
      case 'network-request-failed':
        return 'Check your internet connection';
      default:
        return 'Could not complete the operation (${error.code})';
    }
  }
}

final AuthService authService = AuthService();
