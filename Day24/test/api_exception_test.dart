import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/network/api_exception.dart';

DioException _error(
  DioExceptionType type, {
  int? statusCode,
  Object? data,
}) {
  final options = RequestOptions(path: '/test');
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response<dynamic>(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
  );
}

void main() {
  test('timeouts and connection errors get friendly messages', () {
    expect(
      ApiException.fromDio(_error(DioExceptionType.receiveTimeout)).message,
      AppStrings.errorTimeout,
    );
    expect(
      ApiException.fromDio(_error(DioExceptionType.connectionError)).message,
      AppStrings.errorNoInternet,
    );
  });

  test('uses the server message for 4xx responses', () {
    final exception = ApiException.fromDio(
      _error(
        DioExceptionType.badResponse,
        statusCode: 400,
        data: <String, dynamic>{'message': 'Invalid credentials'},
      ),
    );
    expect(exception.message, 'Invalid credentials');
    expect(exception.statusCode, 400);
    expect(exception.isUnauthorized, isFalse);
  });

  test('does not crash on a non-JSON error body', () {
    final exception = ApiException.fromDio(
      _error(
        DioExceptionType.badResponse,
        statusCode: 401,
        data: '<html>Unauthorized</html>',
      ),
    );
    expect(exception.message, AppStrings.errorSessionExpired);
    expect(exception.isUnauthorized, isTrue);
  });

  test('hides server details on 5xx', () {
    final exception = ApiException.fromDio(
      _error(
        DioExceptionType.badResponse,
        statusCode: 500,
        data: <String, dynamic>{'message': 'SQLSTATE[42S02] stack trace...'},
      ),
    );
    expect(exception.message, AppStrings.errorServer);
  });
}
