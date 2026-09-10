class Calculator {
  int add(int a, int b) {
    return a + b;
  }

  int multiply(int a, int b) {
    return a * b;
  }
}

void main() {
  final calculator = Calculator();

  print(calculator.add(5, 3));
  print(calculator.multiply(5, 3));
}