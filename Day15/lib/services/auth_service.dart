import 'package:dio/dio.dart';
import 'api_service.dart';
import 'secure_storage_service.dart';

class AuthService {
  final ApiService api;
  final SecureStorageService storage;

  AuthService({required this.api, required this.storage});

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.login(email: email, password: password);
      final data = response.data as Map<String, dynamic>;

      final accessToken = data['access_token'] ?? data['token'];
      final refreshToken = data['refresh_token'];

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      await storage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
      );

      return true;
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: password,
      );
      final data = response.data as Map<String, dynamic>;

      final accessToken = data['access_token'] ?? data['token'];
      final refreshToken = data['refresh_token'];

      if (accessToken != null) {
        await storage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken ?? '',
        );

        return true;
      }

      // If registration does not return a token,
      // automatically login after registration.
      return await login(email: email, password: password);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    try {
      await api.logout();
    } catch (_) {
      // Continue clearing local tokens
      // even if the API logout fails.
    }
    await storage.clearTokens();
  }

  String _getErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }

    if (error.response?.statusCode == 401) {
      return 'Invalid email or password.';
    }

    if (error.response?.statusCode == 422) {
      return 'Please check your entered data.';
    }

    return 'Something went wrong. Please try again.';
  }
}