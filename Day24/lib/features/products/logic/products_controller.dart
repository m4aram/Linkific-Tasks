import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/network/api_exception.dart';
import 'package:shoplite/features/products/data/product_model.dart';
import 'package:shoplite/features/products/data/products_repository.dart';

@immutable
class ProductsState {
  const ProductsState({
    this.items = const [],
    this.query = '',
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  final List<Product> items;
  final String query;

  /// First page is loading (nothing to show yet).
  final bool isLoading;

  /// A further page is loading (the list stays visible).
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
}

/// Holds the product list and loads it lazily, one page at a time.
class ProductsController extends StateNotifier<ProductsState> {
  ProductsController(this._repository) : super(const ProductsState()) {
    loadFirstPage();
  }

  final ProductsRepository _repository;

  /// Cancels the in-flight request when a newer one replaces it (typing
  /// in the search box) or when the controller is disposed.
  CancelToken? _cancelToken;

  /// Loads page one for [query] (or for the current query).
  Future<void> loadFirstPage({String? query}) {
    return _loadFirst(query ?? state.query, keepItems: false);
  }

  /// Pull-to-refresh: reloads page one but keeps the list on screen.
  Future<void> refresh() => _loadFirst(state.query, keepItems: true);

  Future<void> _loadFirst(String query, {required bool keepItems}) async {
    _cancelToken?.cancel();
    final token = CancelToken();
    _cancelToken = token;

    final previousItems = keepItems ? state.items : const <Product>[];
    state = ProductsState(
      items: previousItems,
      query: query,
      isLoading: !keepItems,
    );

    try {
      final page = await _repository.fetchProducts(
        skip: 0,
        query: query,
        cancelToken: token,
      );
      if (!mounted || token.isCancelled) return;
      state = ProductsState(
        items: page.items,
        query: query,
        hasMore: page.items.isNotEmpty && page.items.length < page.total,
      );
    } on ApiException catch (e) {
      if (!mounted || token.isCancelled) return;
      state = ProductsState(
        items: previousItems,
        query: query,
        error: e.message,
      );
    } catch (_) {
      if (!mounted || token.isCancelled) return;
      state = ProductsState(
        items: previousItems,
        query: query,
        error: AppStrings.errorUnexpected,
      );
    }
  }

  /// Loads the next page. Called automatically while scrolling; pass
  /// [retry] = true from the "Try again" button after a failure.
  Future<void> loadMore({bool retry = false}) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    // After a failure, wait for an explicit retry instead of hammering
    // the server on every scroll event.
    if (state.error != null && !retry) return;

    final token = _cancelToken ??= CancelToken();
    final current = state;
    state = ProductsState(
      items: current.items,
      query: current.query,
      isLoadingMore: true,
    );

    try {
      final page = await _repository.fetchProducts(
        skip: current.items.length,
        query: current.query,
        cancelToken: token,
      );
      if (!mounted || token.isCancelled) return;
      final items = [...current.items, ...page.items];
      state = ProductsState(
        items: items,
        query: current.query,
        hasMore: page.items.isNotEmpty && items.length < page.total,
      );
    } on ApiException catch (e) {
      if (!mounted || token.isCancelled) return;
      state = ProductsState(
        items: current.items,
        query: current.query,
        error: e.message,
      );
    } catch (_) {
      if (!mounted || token.isCancelled) return;
      state = ProductsState(
        items: current.items,
        query: current.query,
        error: AppStrings.errorUnexpected,
      );
    }
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }
}

final productsControllerProvider =
    StateNotifierProvider<ProductsController, ProductsState>((ref) {
  return ProductsController(ref.watch(productsRepositoryProvider));
});
