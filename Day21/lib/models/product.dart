import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required double price,
    @Default('') String description,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
sealed class ProductResult with _$ProductResult {
  const factory ProductResult.loading() = ProductLoading;
  const factory ProductResult.success(List<Product> products) = ProductSuccess;
  const factory ProductResult.error(String message) = ProductError;
}
