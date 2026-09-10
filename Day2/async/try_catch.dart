Future<void> loadData() async {
  try {
    throw Exception('Something went wrong');
  } catch (error) {
    print(error);
  }
}

void main() async {
  await loadData();
}