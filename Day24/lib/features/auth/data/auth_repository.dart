import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/network/api_client.dart';
import 'package:shoplite/core/network/api_exception.dart';
import 'package:shoplite/core/storage/secure_storage_service.dart';
import 'package:shoplite/features/auth/data/user_model.dart';

/// Talks to the auth endpoints and owns the stored token. Throws only
/// [ApiException].
class AuthRepository {
  AuthRepository(this._dio, this._storage);

  final Dio _dio;
  final SecureStorageService _storage;

  Future<bool> hasSession() async => await _storage.readToken() != null;

  Future<AppUser> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: <String, dynamic>{
          'username': username,
          'password': password,
          'expiresInMins': AppConstants.sessionMinutes,
        },
      );

      final data = response.data;
      final token = data?['accessToken'];
      if (data == null || token is! String || token.isEmpty) {
        throw const ApiException(AppStrings.errorUnexpected);
      }

      await _storage.saveToken(token);
      return AppUser.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<AppUser> fetchCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.currentUser,
      );
      final data = response.data;
      if (data == null) throw const ApiException(AppStrings.errorUnexpected);
      return AppUser.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Removes the token from the device.
  Future<void> logout() => _storage.clear();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
});
