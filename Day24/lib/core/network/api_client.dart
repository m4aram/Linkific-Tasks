import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/storage/secure_storage_service.dart';

/// Builds the one [Dio] instance shared by every repository (a single
/// connection pool instead of one client per feature).
Dio createDio(SecureStorageService storage) {
  final baseUri = Uri.parse(AppConstants.apiBaseUrl);
  if (baseUri.scheme != 'https' || baseUri.host.isEmpty) {
    // Fail fast: a misconfigured build must never talk plain HTTP.
    throw StateError('API_BASE_URL must be an absolute https:// URL.');
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      contentType: Headers.jsonContentType,
      headers: <String, dynamic>{'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final uri = options.uri;

        // HTTPS only. Dart's HTTP stack does not read Android's
        // network-security-config, so the rule is enforced here as well.
        if (uri.scheme != 'https') {
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badCertificate,
              error: 'Blocked non-HTTPS request',
            ),
          );
        }

        // The token is attached only for our own API host, never leaked
        // to a third-party URL.
        if (uri.host == baseUri.host) {
          final token = await storage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
}

final dioProvider = Provider<Dio>((ref) {
  final dio = createDio(ref.watch(secureStorageProvider));
  ref.onDispose(() => dio.close());
  return dio;
});
