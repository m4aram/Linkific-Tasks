import 'package:flutter/material.dart';

/// Icon and color for each expense category, used in lists, chips and charts.
class CategoryStyle {
  final IconData icon;
  final Color color;

  const CategoryStyle(this.icon, this.color);

  static CategoryStyle of(String category) {
    return switch (category) {
      'Food' =>
        const CategoryStyle(Icons.restaurant_outlined, Color(0xFFE07A5F)),
      'Transport' =>
        const CategoryStyle(Icons.directions_car_outlined, Color(0xFF3D85C6)),
      'Shopping' =>
        const CategoryStyle(Icons.shopping_bag_outlined, Color(0xFF9C6ADE)),
      'Bills' =>
        const CategoryStyle(Icons.receipt_long_outlined, Color(0xFFD9A21B)),
      'Health' =>
        const CategoryStyle(Icons.favorite_border, Color(0xFF2E9E6B)),
      _ => const CategoryStyle(Icons.category_outlined, Color(0xFF7A8A99)),
    };
  }
}
