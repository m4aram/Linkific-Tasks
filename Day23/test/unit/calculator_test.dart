import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/calculator/calculator.dart';

void main() {
  late Calculator calculator;

  // Runs before every test: each test gets a fresh Calculator.
  setUp(() {
    calculator = Calculator();
  });

  group('Calculator', () {
    test('add returns the sum of two numbers', () {
      expect(calculator.add(2, 3), 5);
      expect(calculator.add(-2, 3), 1);
    });

    test('subtract returns the difference of two numbers', () {
      expect(calculator.subtract(5, 3), 2);
      expect(calculator.subtract(3, 5), -2);
    });

    test('multiply returns the product of two numbers', () {
      expect(calculator.multiply(4, 3), 12);
      expect(calculator.multiply(4, 0), 0);
    });

    test('divide returns the quotient of two numbers', () {
      expect(calculator.divide(10, 2), 5);
      expect(calculator.divide(1, 3), closeTo(0.333, 0.001));
    });

    test('divide throws ArgumentError when dividing by zero', () {
      expect(() => calculator.divide(10, 0), throwsArgumentError);
    });
  });
}
