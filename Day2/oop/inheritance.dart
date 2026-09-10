class Animal {
  void eat() {
    print('Eating');
  }
}

class Cat extends Animal {
  void meow() {
    print('Meow');
  }
}

void main() {
  final cat = Cat();

  cat.eat();
  cat.meow();
}