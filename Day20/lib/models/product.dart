class Product {
  final int id;
  final String name;
  final String emoji;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
  });
}

const List<Product> kProducts = [
  Product(id: 1, name: 'Wireless Headphones', emoji: '🎧', price: 59.99),
  Product(id: 2, name: 'Smart Watch', emoji: '⌚', price: 129.00),
  Product(id: 3, name: 'Backpack', emoji: '🎒', price: 39.50),
  Product(id: 4, name: 'Coffee Mug', emoji: '☕', price: 12.00),
  Product(id: 5, name: 'Keyboard', emoji: '⌨️', price: 74.90),
  Product(id: 6, name: 'Desk Lamp', emoji: '💡', price: 24.99),
];
