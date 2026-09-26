import 'package:dio/dio.dart';

import 'secure_storage_service.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService storage;
  late final Dio dio;

  ApiService(this.storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.requestOptions.extra['retried'] != true) {
            final refreshToken = await storage.getRefreshToken();

            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: baseUrl,
                    headers: {
                      'Accept': 'application/json',
                      'Content-Type': 'application/json',
                    },
                  ),
                );

                final response = await refreshDio.post(
                  '/refresh',
                  data: {'refresh_token': refreshToken},
                );

                final newAccessToken = response.data['access_token'];

                final newRefreshToken =
                    response.data['refresh_token'] ?? refreshToken;

                await storage.saveTokens(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                );

                final requestOptions = error.requestOptions;

                requestOptions.extra['retried'] = true;

                requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                final retryResponse = await dio.fetch(requestOptions);

                return handler.resolve(retryResponse);
              } catch (_) {
                await storage.clearTokens();
              }
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await dio.post(
      '/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  Future<Response> refreshToken(String refreshToken) async {
    return await dio.post('/refresh', data: {'refresh_token': refreshToken});
  }

  Future<Response> logout() async {
    return await dio.post('/logout');
  }

  Future<Response> getCurrentUser() async {
    return await dio.get('/me');
  }
}
