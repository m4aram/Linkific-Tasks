class Person {
  String _name = '';

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}

void main() {
  final person = Person();

  person.name = 'Maram';

  print(person.name);
}