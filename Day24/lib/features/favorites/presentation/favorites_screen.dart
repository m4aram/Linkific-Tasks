import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_assets.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/theme/app_colors.dart';
import 'package:shoplite/core/widgets/loading_view.dart';
import 'package:shoplite/core/widgets/status_view.dart';
import 'package:shoplite/features/favorites/logic/favorites_controller.dart';
import 'package:shoplite/features/products/presentation/widgets/product_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.favoritesTitle)),
      // Every async state is handled: loading, error and data.
      body: favorites.when(
        loading: () => const LoadingView(),
        error: (error, stackTrace) => StatusView(
          asset: AppAssets.errorCloud,
          title: AppStrings.errorTitle,
          message: AppStrings.errorFavoritesLoad,
          actionLabel: AppStrings.retry,
          onAction: ref.read(favoritesControllerProvider.notifier).load,
        ),
        data: (items) {
          if (items.isEmpty) {
            return const StatusView(
              asset: AppAssets.emptyHeart,
              title: AppStrings.noFavoritesTitle,
              message: AppStrings.noFavoritesMessage,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return ProductCard(
                key: ValueKey<int>(product.id),
                product: product,
              );
            },
          );
        },
      ),
    );
  }
}
