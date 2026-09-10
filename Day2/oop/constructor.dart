class Product {
  String name;
  double price;

  Product({
    required this.name,
    required this.price,
  });
}

void main() {
  final product = Product(
    name: 'Laptop',
    price: 800,
  );

  print(product.name);
  print(product.price);
}