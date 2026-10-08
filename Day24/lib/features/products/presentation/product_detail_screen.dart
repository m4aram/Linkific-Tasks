import 'package:flutter/material.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/theme/app_colors.dart';
import 'package:shoplite/core/widgets/app_network_image.dart';
import 'package:shoplite/features/products/data/product_model.dart';
import 'package:shoplite/features/products/presentation/widgets/favorite_button.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brand = product.brand;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productDetails),
        actions: [
          FavoriteButton(product: product),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _Gallery(product: product),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand == null
                        ? product.category
                        : '$brand  •  ${product.category}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(product.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Text(
                        product.priceLabel,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: AppSpacing.md),
                        _Badge(
                          label:
                              '-${product.discountPercentage.round()}%',
                          background: scheme.errorContainer,
                          foreground: scheme.onErrorContainer,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: AppColors.rating,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        product.ratingLabel,
                        style: theme.textTheme.bodyMedium,
                        semanticsLabel:
                            'Rated ${product.ratingLabel} out of 5',
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      _Badge(
                        label: product.inStock
                            ? AppStrings.inStock
                            : AppStrings.outOfStock,
                        background: product.inStock
                            ? scheme.secondaryContainer
                            : scheme.surfaceContainerHighest,
                        foreground: product.inStock
                            ? scheme.onSecondaryContainer
                            : scheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    AppStrings.description,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Swipeable gallery. `PageView.builder` creates a page (and downloads
/// its image) only when the user actually swipes to it.
class _Gallery extends StatelessWidget {
  const _Gallery({required this.product});

  final Product product;

  static const double _height = 300;

  @override
  Widget build(BuildContext context) {
    final images = product.galleryImages;

    return SizedBox(
      height: _height,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return AppNetworkImage(
            url: images[index],
            height: _height,
            fit: BoxFit.contain,
            semanticLabel:
                '${product.title}, image ${index + 1} of ${images.length}',
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
