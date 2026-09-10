Future<String> fetchUser() async {
  await Future.delayed(const Duration(seconds: 1));

  return 'Maram';
}

void main() async {
  print('Loading...');

  final user = await fetchUser();

  print(user);
}