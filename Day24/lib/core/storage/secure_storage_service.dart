import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoplite/core/constants/app_constants.dart';

/// Stores secrets (the auth token) encrypted with a key held in the
/// Android Keystore. Secrets never go into SharedPreferences or SQLite.
class SecureStorageService {
  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) {
    return _storage.write(key: StorageKeys.authToken, value: token);
  }

  /// Returns null when there is no token or when the stored value can no
  /// longer be decrypted (for example after a device restore).
  Future<String?> readToken() async {
    try {
      final token = await _storage.read(key: StorageKeys.authToken);
      return (token == null || token.isEmpty) ? null : token;
    } on PlatformException {
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } on PlatformException {
      // Nothing useful can be done; the next write overwrites the entry.
    }
  }
}

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
