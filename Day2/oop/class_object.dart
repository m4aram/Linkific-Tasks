class User {
  String name;
  int age;

  User(this.name, this.age);
}

void main() {
  final user = User('Maram', 22);

  print(user.name);
  print(user.age);
}