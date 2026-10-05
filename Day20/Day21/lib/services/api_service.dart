import 'dart:io';

import 'package:dio/dio.dart';

import '../models/product.dart';

class ApiService {
  ApiService()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://dummyjson.com',
            connectTimeout: const Duration(seconds: 8),
            receiveTimeout: const Duration(seconds: 8),
            sendTimeout: const Duration(seconds: 8),
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-Demo-App'] = 'Flutter-Package-Explorer';
          handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) => handler.next(error),
      ),
    );
  }

  final Dio dio;

  Future<List<Product>> fetchProducts({CancelToken? cancelToken}) async {
    final response = await dio.get<dynamic>(
      '/products?limit=5',
      cancelToken: cancelToken,
    );

    final body = Map<String, dynamic>.from(response.data as Map);
    final rawProducts = body['products'] as List<dynamic>? ?? const [];

    return rawProducts
        .map(
          (item) => Product.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> downloadDemoFile(String path) async {
    await dio.download(
      'https://dummyjson.com/image/150',
      path,
    );
  }

  String exampleFilePath() {
    return '${Directory.systemTemp.path}${Platform.pathSeparator}flutter_package_explorer_demo.jpg';
  }

  void dispose() => dio.close(force: true);
}
