import 'package:fittrack/core/utils/bmi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculateBmi divides weight by height squared', () {
    final bmi = calculateBmi(weightKg: 60, heightCm: 165);
    expect(bmi, closeTo(22.04, 0.01));
  });

  test('bmiCategory uses the standard ranges', () {
    expect(bmiCategory(17), 'Underweight');
    expect(bmiCategory(18.5), 'Normal weight');
    expect(bmiCategory(24.9), 'Normal weight');
    expect(bmiCategory(25), 'Overweight');
    expect(bmiCategory(30), 'Obese');
  });
}
