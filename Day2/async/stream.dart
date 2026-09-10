Stream<int> numbers() async* {
  for (int i = 1; i <= 5; i++) {
    yield i;
  }
}

void main() async {
  await for (final number in numbers()) {
    print(number);
  }
}