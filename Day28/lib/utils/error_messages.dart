import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

const String genericErrorMessage = 'Something went wrong. Please try again.';
const String offlineErrorMessage =
    'No internet connection. Check your network and try again.';

/// Turns any error into a short message a user can act on.
String friendlyError(Object error) {
  if (_isNetworkError(error)) return offlineErrorMessage;

  if (error is AuthException) {
    final message = error.message.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return 'Incorrect email or password.';
    }
    if (message.contains('email not confirmed')) {
      return 'Please confirm your email before logging in.';
    }
    if (message.contains('already registered')) {
      return 'An account with this email already exists.';
    }
    if (message.contains('rate limit') || error.statusCode == '429') {
      return 'Too many attempts. Please wait a minute and try again.';
    }
    return error.message.isEmpty ? genericErrorMessage : error.message;
  }

  if (error is PostgrestException) {
    if (error.code == '42501') {
      return 'You do not have permission to change this expense.';
    }
    return 'The server could not complete the request. Please try again.';
  }

  return genericErrorMessage;
}

bool _isNetworkError(Object error) {
  if (error is TimeoutException) return true;
  if (error is AuthRetryableFetchException) return true;
  // Checked by name so this file also compiles for the web,
  // where `dart:io` (SocketException) is not available.
  final type = error.runtimeType.toString();
  return type.contains('SocketException') ||
      type.contains('ClientException') ||
      type.contains('HandshakeException');
}
