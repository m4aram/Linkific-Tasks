import 'package:flutter_test/flutter_test.dart';
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/utils/validators.dart';

void main() {
  group('Validators.username', () {
    test('accepts a normal username', () {
      expect(Validators.username('emilys'), isNull);
      expect(Validators.username('  john.doe_99  '), isNull);
    });

    test('rejects empty input', () {
      expect(Validators.username(null), AppStrings.usernameRequired);
      expect(Validators.username('   '), AppStrings.usernameRequired);
    });

    test('rejects too short, too long and unsafe characters', () {
      expect(Validators.username('ab'), AppStrings.usernameInvalid);
      expect(Validators.username('a' * 31), AppStrings.usernameInvalid);
      expect(Validators.username("bob'; DROP"), AppStrings.usernameInvalid);
      expect(Validators.username('<script>'), AppStrings.usernameInvalid);
    });
  });

  group('Validators.password', () {
    test('accepts a valid password', () {
      expect(Validators.password('emilyspass'), isNull);
    });

    test('rejects empty, short and oversized passwords', () {
      expect(Validators.password(''), AppStrings.passwordRequired);
      expect(Validators.password('12345'), AppStrings.passwordTooShort);
      expect(Validators.password('x' * 65), AppStrings.passwordTooLong);
    });
  });

  group('Validators.sanitizeSearch', () {
    test('trims and collapses whitespace', () {
      expect(Validators.sanitizeSearch('  red   phone '), 'red phone');
    });

    test('removes control characters', () {
      expect(Validators.sanitizeSearch('pho\u0000ne\n\tcase'), 'pho ne case');
    });

    test('caps the length', () {
      final result = Validators.sanitizeSearch('a' * 500);
      expect(result.length, AppConstants.maxSearchLength);
    });
  });

  group('Validators.isHttpsUrl', () {
    test('accepts https only', () {
      expect(Validators.isHttpsUrl('https://cdn.dummyjson.com/a.png'), isTrue);
      expect(Validators.isHttpsUrl('http://cdn.dummyjson.com/a.png'), isFalse);
      expect(Validators.isHttpsUrl('file:///etc/passwd'), isFalse);
      expect(Validators.isHttpsUrl(''), isFalse);
      expect(Validators.isHttpsUrl(null), isFalse);
    });
  });
}
