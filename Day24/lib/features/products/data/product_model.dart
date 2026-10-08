import 'package:flutter/foundation.dart';
import 'package:shoplite/core/database/app_database.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.thumbnail,
    this.brand,
    this.discountPercentage = 0,
    this.stock = 0,
    this.images = const [],
  });

  /// Builds a product from API JSON. Every field is read defensively, so
  /// a missing or wrongly-typed value becomes a default, never a crash.
  factory Product.fromJson(Map<String, dynamic> json) {
    final images = json['images'];
    return Product(
      id: _int(json['id']),
      title: _string(json['title']),
      description: _string(json['description']),
      category: _string(json['category']),
      brand: _nullableString(json['brand']),
      price: _double(json['price']),
      discountPercentage: _double(json['discountPercentage']),
      rating: _double(json['rating']),
      stock: _int(json['stock']),
      thumbnail: _string(json['thumbnail']),
      images: images is List
          ? images.whereType<String>().toList(growable: false)
          : const [],
    );
  }

  /// Builds a product from a row of the local favourites table.
  factory Product.fromDb(Map<String, Object?> row) {
    return Product(
      id: _int(row[FavoritesTable.id]),
      title: _string(row[FavoritesTable.title]),
      description: _string(row[FavoritesTable.description]),
      category: _string(row[FavoritesTable.category]),
      brand: _nullableString(row[FavoritesTable.brand]),
      price: _double(row[FavoritesTable.price]),
      discountPercentage: _double(row[FavoritesTable.discount]),
      rating: _double(row[FavoritesTable.rating]),
      stock: _int(row[FavoritesTable.stock]),
      thumbnail: _string(row[FavoritesTable.thumbnail]),
    );
  }

  final int id;
  final String title;
  final String description;
  final String category;
  final String? brand;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final List<String> images;

  String get priceLabel => '\$${price.toStringAsFixed(2)}';
  String get ratingLabel => rating.toStringAsFixed(1);
  bool get hasDiscount => discountPercentage >= 1;
  bool get inStock => stock > 0;

  /// Images for the gallery; falls back to the thumbnail.
  List<String> get galleryImages => images.isEmpty ? [thumbnail] : images;

  /// Column -> value map for the favourites table. Values are passed to
  /// SQLite as bound parameters, never concatenated into SQL.
  Map<String, Object?> toDb({required int addedAt}) {
    return {
      FavoritesTable.id: id,
      FavoritesTable.title: title,
      FavoritesTable.description: description,
      FavoritesTable.category: category,
      FavoritesTable.brand: brand,
      FavoritesTable.price: price,
      FavoritesTable.discount: discountPercentage,
      FavoritesTable.rating: rating,
      FavoritesTable.stock: stock,
      FavoritesTable.thumbnail: thumbnail,
      FavoritesTable.addedAt: addedAt,
    };
  }

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;

  static int _int(Object? value) => value is num ? value.toInt() : 0;

  static double _double(Object? value) => value is num ? value.toDouble() : 0;

  static String _string(Object? value) => value is String ? value : '';

  static String? _nullableString(Object? value) {
    return value is String && value.isNotEmpty ? value : null;
  }
}

/// One page of results plus the total number of matches on the server.
@immutable
class ProductPage {
  const ProductPage({required this.items, required this.total});

  final List<Product> items;
  final int total;
}
