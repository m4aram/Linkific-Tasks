import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/features/favorites/data/favorites_repository.dart';
import 'package:shoplite/features/products/data/product_model.dart';

class FavoritesController extends StateNotifier<AsyncValue<List<Product>>> {
  FavoritesController(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  final FavoritesRepository _repository;

  Future<void> load() async {
    try {
      final items = await _repository.getAll();
      if (mounted) state = AsyncValue.data(items);
    } catch (error, stackTrace) {
      if (mounted) state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Adds or removes [product]. Returns false if the database write
  /// failed, so the UI can tell the user.
  Future<bool> toggle(Product product) async {
    final wasFavorite = _current.any((item) => item.id == product.id);
    try {
      if (wasFavorite) {
        await _repository.remove(product.id);
      } else {
        await _repository.add(product);
      }
      if (!mounted) return true;

      // Re-read the list: it may have changed while the write was running.
      final others = _current.where((item) => item.id != product.id);
      state = AsyncValue.data(
        wasFavorite ? others.toList() : [product, ...others],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  List<Product> get _current => state.valueOrNull ?? const <Product>[];
}

final favoritesControllerProvider = StateNotifierProvider<FavoritesController,
    AsyncValue<List<Product>>>((ref) {
  return FavoritesController(ref.watch(favoritesRepositoryProvider));
});

/// Ids of all favourites, for O(1) lookups.
final favoriteIdsProvider = Provider<Set<int>>((ref) {
  final items = ref.watch(favoritesControllerProvider).valueOrNull;
  return {for (final item in items ?? const <Product>[]) item.id};
});

/// Whether one product is a favourite. A heart button watches only its
/// own flag, so toggling one product rebuilds one button, not the list.
final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  return ref.watch(
    favoriteIdsProvider.select((ids) => ids.contains(productId)),
  );
});
