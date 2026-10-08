import 'package:flutter_test/flutter_test.dart';
import 'package:shoplite/features/products/data/product_model.dart';

void main() {
  group('Product.fromJson', () {
    test('parses a complete product', () {
      final product = Product.fromJson(const <String, dynamic>{
        'id': 7,
        'title': 'Phone',
        'description': 'A phone',
        'category': 'smartphones',
        'brand': 'Acme',
        'price': 199, // the API sends ints and doubles for prices
        'discountPercentage': 12.5,
        'rating': 4.36,
        'stock': 3,
        'thumbnail': 'https://example.com/t.png',
        'images': ['https://example.com/1.png', 42, null],
      });

      expect(product.id, 7);
      expect(product.price, 199.0);
      expect(product.priceLabel, r'$199.00');
      expect(product.ratingLabel, '4.4');
      expect(product.hasDiscount, isTrue);
      expect(product.inStock, isTrue);
      // Non-string entries are dropped instead of crashing.
      expect(product.images, ['https://example.com/1.png']);
    });

    test('survives missing and wrongly-typed fields', () {
      final product = Product.fromJson(const <String, dynamic>{
        'id': '7',
        'price': 'free',
        'images': 'none',
      });

      expect(product.id, 0);
      expect(product.title, '');
      expect(product.brand, isNull);
      expect(product.price, 0);
      expect(product.images, isEmpty);
      expect(product.inStock, isFalse);
      expect(product.galleryImages, ['']);
    });
  });

  test('database round trip keeps the data', () {
    const original = Product(
      id: 1,
      title: 'Phone',
      description: 'A phone',
      category: 'smartphones',
      price: 9.99,
      rating: 4.5,
      thumbnail: 'https://example.com/t.png',
      stock: 2,
    );

    final restored = Product.fromDb(original.toDb(addedAt: 123));

    expect(restored, original);
    expect(restored.title, original.title);
    expect(restored.price, original.price);
    expect(restored.stock, original.stock);
  });
}