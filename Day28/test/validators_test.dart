import 'package:expense_tracker/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.amount', () {
    test('accepts normal amounts', () {
      expect(Validators.amount('12'), isNull);
      expect(Validators.amount('12.5'), isNull);
      expect(Validators.amount('12,50'), isNull);
      expect(Validators.amount('1,250.00'), isNull);
      expect(Validators.amount('.5'), isNull);
      expect(Validators.amount(' 7 '), isNull);
    });

    test('rejects empty, zero and negative values', () {
      expect(Validators.amount(''), 'Amount is required');
      expect(Validators.amount('   '), 'Amount is required');
      expect(Validators.amount('0'), 'Amount must be greater than 0');
      expect(Validators.amount('-3'), 'Amount must be greater than 0');
    });

    test('rejects values double.tryParse would accept', () {
      expect(Validators.amount('NaN'), 'Enter a valid number');
      expect(Validators.amount('Infinity'), 'Enter a valid number');
      expect(Validators.amount('1e5'), 'Enter a valid number');
      expect(Validators.amount('abc'), 'Enter a valid number');
      expect(Validators.amount('1.2.3'), 'Enter a valid number');
    });

    test('rejects too many decimals and huge amounts', () {
      expect(Validators.amount('1.234'), 'Use at most 2 decimal places');
      expect(Validators.amount('1000000.01'), 'Amount must be 1,000,000 or less');
      expect(Validators.amount('1000000'), isNull);
    });
  });

  group('Validators.parseAmount', () {
    test('parses decimal comma and thousands separator', () {
      expect(Validators.parseAmount('12,50'), 12.5);
      expect(Validators.parseAmount('12,500'), 12500);
      expect(Validators.parseAmount('1,250.75'), 1250.75);
      expect(Validators.parseAmount('5.'), 5);
      expect(Validators.parseAmount('.25'), 0.25);
    });

    test('returns null for invalid input', () {
      expect(Validators.parseAmount(null), isNull);
      expect(Validators.parseAmount('NaN'), isNull);
      expect(Validators.parseAmount('-1'), isNull);
    });
  });

  group('Validators.title', () {
    test('requires text and limits length', () {
      expect(Validators.title(''), 'Title is required');
      expect(Validators.title('   '), 'Title is required');
      expect(Validators.title('Lunch'), isNull);
      expect(
        Validators.title('a' * (Validators.titleMaxLength + 1)),
        'Title must be at most ${Validators.titleMaxLength} characters',
      );
    });
  });

  group('Validators.email and password', () {
    test('email', () {
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email('maram'), 'Enter a valid email');
      expect(Validators.email(' maram@test.com '), isNull);
    });

    test('password', () {
      expect(Validators.password(''), 'Password is required');
      expect(Validators.password('123'),
          'Password must be at least 6 characters');
      expect(Validators.password(' secret1'),
          'Password cannot start or end with a space');
      expect(Validators.password('a' * 73),
          'Password must be at most 72 characters');
      expect(Validators.password('secret1'), isNull);
    });

    test('confirm password', () {
      expect(Validators.confirmPassword('', 'abc123'),
          'Please confirm your password');
      expect(Validators.confirmPassword('abc124', 'abc123'),
          'Passwords do not match');
      expect(Validators.confirmPassword('abc123', 'abc123'), isNull);
    });
  });
}
