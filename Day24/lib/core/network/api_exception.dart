import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoplite/core/constants/app_strings.dart';

/// The only error type that leaves the data layer. It always carries a
/// message that is safe to show to the user (no stack traces, no URLs).
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  /// Maps any [DioException] to a friendly message.
  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(AppStrings.errorTimeout);
      case DioExceptionType.connectionError:
        return const ApiException(AppStrings.errorNoInternet);
      case DioExceptionType.badCertificate:
        return const ApiException(AppStrings.errorInsecure);
      case DioExceptionType.cancel:
        return const ApiException(AppStrings.errorCancelled);
      case DioExceptionType.badResponse:
        return ApiException(
          _messageForResponse(error.response),
          statusCode: statusCode,
        );
      default:
        if (error.type.name.endsWith('Timeout')) {
          return const ApiException(AppStrings.errorTimeout);
        }
        if (error.error is SocketException) {
          return const ApiException(AppStrings.errorNoInternet);
        }
        return ApiException(AppStrings.errorUnexpected, statusCode: statusCode);
    }
  }

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401 || statusCode == 403;

  static String _messageForResponse(Response<dynamic>? response) {
    final status = response?.statusCode ?? 0;
    if (status >= 500) return AppStrings.errorServer;

    // The body can be a Map, a String, or null - never assume its shape.
    final data = response?.data;
    if (data is Map) {
      final serverMessage = data['message'];
      if (serverMessage is String && serverMessage.trim().isNotEmpty) {
        return serverMessage.trim();
      }
    }
    if (status == 401 || status == 403) return AppStrings.errorSessionExpired;
    return AppStrings.errorUnexpected;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
