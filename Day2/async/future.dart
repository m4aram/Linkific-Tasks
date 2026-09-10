Future<String> getData() {
  return Future.value('Data loaded');
}

void main() async {
  final result = await getData();

  print(result);
}