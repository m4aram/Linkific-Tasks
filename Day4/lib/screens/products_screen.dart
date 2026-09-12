import 'package:flutter/material.dart';
class ProductsScreen extends StatelessWidget
{ const ProductsScreen({super.key});
  @override Widget build(BuildContext context)
{ final products =
[ {'name': 'Laptop', 'price': '\$999', 'icon': Icons.laptop},
  {'name': 'Phone', 'price': '\$699', 'icon': Icons.phone_android},
  {'name': 'Headphones', 'price': '\$199', 'icon': Icons.headphones},
  {'name': 'Watch', 'price': '\$299', 'icon': Icons.watch},
  {'name': 'Camera', 'price': '\$799', 'icon': Icons.camera_alt},
  {'name': 'Tablet', 'price': '\$499', 'icon': Icons.tablet},
  {'name': 'Keyboard', 'price': '\$89', 'icon': Icons.keyboard},
  {'name': 'Mouse', 'price': '\$49', 'icon': Icons.mouse}, ];
return Scaffold(
    appBar: AppBar(
      title: const Text('E-commerce Products'),
    ),
    body: LayoutBuilder(
    builder: (context, constraints) {
  final isWide = constraints.maxWidth > 700;

  return SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.all(16),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text(
  'Categories',
  style: TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  ),
  ),

  const SizedBox(height: 12),

  SizedBox(
  height: 120,
  child: GridView.count(
  crossAxisCount: 4,
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  physics: const NeverScrollableScrollPhysics(),
  children: const [
  CategoryItem(
  icon: Icons.devices,
  title: 'Devices',
  ),
  CategoryItem(
  icon: Icons.shopping_bag,
  title: 'Bags',
  ),
  CategoryItem(
  icon: Icons.watch,
  title: 'Watches',
  ),
  CategoryItem(
  icon: Icons.headphones,
  title: 'Audio',
  ),
  ],
  ),
  ),

  const SizedBox(height: 24),

  const Text(
  'Products',
  style: TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  ),
  ),

  const SizedBox(height: 12),

  GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: 30,
  gridDelegate:
  SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: isWide ? 4 : 2,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 0.8,
  ),
  itemBuilder: (context, index) {
  final product = products[index % products.length];

  return Card(
  child: Padding(
  padding: const EdgeInsets.all(12),
  child: Column(
  children: [
  Expanded(
  child: Center(
  child: Icon(
  product['icon'] as IconData,
  size: 60,
  ),
  ),
  ),
  Text(
  product['name'] as String,
  style: const TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 6),
  Text(
  product['price'] as String,
  style: const TextStyle(
    fontSize: 16,
  ),
  ),
    const SizedBox(height: 8),
    ElevatedButton(
      onPressed: () {},
      child: const Text('Add'),
    ),
  ],
  ),
  ),
  );
  },
  ),
  ],
  ),
      ),
  );
    },
    ),
);
} }
class CategoryItem extends StatelessWidget
{ final IconData icon; final String title;
const CategoryItem({ super.key, required this.icon, required this.title, });
@override Widget build(BuildContext context) {
    return Column( mainAxisAlignment: MainAxisAlignment.center,
      children: [ Icon(icon, size: 28), const SizedBox(height: 5),
        Text( title, textAlign: TextAlign.center, style:
        const TextStyle(fontSize: 12), ), ], ); } }