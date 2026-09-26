import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await storage.write(key: accessTokenKey, value: accessToken);
    await storage.write(key: refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
  }
}
