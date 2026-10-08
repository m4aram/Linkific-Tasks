import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/network/api_client.dart';
import 'package:shoplite/core/network/api_exception.dart';
import 'package:shoplite/features/products/data/product_model.dart';

/// Fetches products page by page. Throws only [ApiException].
class ProductsRepository {
  ProductsRepository(this._dio);

  final Dio _dio;

  // Ask the server only for the fields the app shows: smaller responses.
  static const String _fields =
      'id,title,description,category,brand,price,discountPercentage,'
      'rating,stock,thumbnail,images';

  Future<ProductPage> fetchProducts({
    required int skip,
    int limit = AppConstants.pageSize,
    String query = '',
    CancelToken? cancelToken,
  }) async {
    try {
      final isSearch = query.isNotEmpty;
      final response = await _dio.get<Map<String, dynamic>>(
        isSearch ? ApiEndpoints.productSearch : ApiEndpoints.products,
        // Passed as query parameters, so Dio URL-encodes the user's text.
        queryParameters: <String, dynamic>{
          'limit': limit,
          'skip': skip,
          'select': _fields,
          if (isSearch) 'q': query,
        },
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data == null) throw const ApiException(AppStrings.errorUnexpected);

      final rawItems = data['products'];
      final items = rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(Product.fromJson)
              .toList(growable: false)
          : const <Product>[];
      final total = data['total'];

      return ProductPage(
        items: items,
        total: total is num ? total.toInt() : items.length,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepository(ref.watch(dioProvider));
});
