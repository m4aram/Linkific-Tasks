void main() {
  List<int> numbers = [1, 2, 3, 4, 5];

  final doubled = numbers.map((number) => number * 2).toList();
  final evenNumbers = numbers.where((number) => number.isEven).toList();
  final total = numbers.reduce((a, b) => a + b);

  print(doubled);
  print(evenNumbers);
  print(total);
}