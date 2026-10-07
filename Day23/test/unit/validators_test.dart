import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/form/validators.dart';

void main() {
  group('Validators.validateEmail', () {
    test('returns error when email is null', () {
      expect(Validators.validateEmail(null), 'Email is required');
    });

    test('returns error when email is empty', () {
      expect(Validators.validateEmail(''), 'Email is required');
      expect(Validators.validateEmail('   '), 'Email is required');
    });

    test('returns error when email format is invalid', () {
      expect(Validators.validateEmail('user'), 'Enter a valid email');
      expect(Validators.validateEmail('user@'), 'Enter a valid email');
      expect(Validators.validateEmail('user@mail'), 'Enter a valid email');
    });

    test('returns null when email is valid', () {
      expect(Validators.validateEmail('user@mail.com'), isNull);
    });
  });

  group('Validators.validatePassword', () {
    test('returns error when password is null', () {
      expect(Validators.validatePassword(null), 'Password is required');
    });

    test('returns error when password is empty', () {
      expect(Validators.validatePassword(''), 'Password is required');
    });

    test('returns error when password is shorter than 6 characters', () {
      expect(
        Validators.validatePassword('12345'),
        'Password must be at least 6 characters',
      );
    });

    test('returns null when password is valid', () {
      expect(Validators.validatePassword('123456'), isNull);
    });
  });
}
