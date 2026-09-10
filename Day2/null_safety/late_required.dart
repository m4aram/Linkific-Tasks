class User {
  late String name;

  User({required String userName}) {
    name = userName;
  }
}

void main() {
  final user = User(userName: 'Maram');

  print(user.name);
}