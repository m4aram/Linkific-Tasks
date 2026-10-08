import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/features/favorites/logic/favorites_controller.dart';
import 'package:shoplite/features/products/data/product_model.dart';

/// Heart toggle. Rebuilds only when THIS product's favourite flag flips.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(product.id));

    return IconButton(
      // The tooltip doubles as the screen-reader label.
      tooltip:
          isFavorite ? AppStrings.removeFavorite : AppStrings.addFavorite,
      isSelected: isFavorite,
      icon: const Icon(Icons.favorite_border),
      selectedIcon: Icon(
        Icons.favorite,
        color: Theme.of(context).colorScheme.error,
      ),
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        final saved = await ref
            .read(favoritesControllerProvider.notifier)
            .toggle(product);
        if (!saved) {
          messenger.showSnackBar(
            const SnackBar(content: Text(AppStrings.errorFavorite)),
          );
        }
      },
    );
  }
}
