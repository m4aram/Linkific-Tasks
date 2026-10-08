import 'package:flutter/material.dart';
import 'package:shoplite/core/theme/app_colors.dart';
import 'package:shoplite/core/widgets/app_network_image.dart';
import 'package:shoplite/features/products/data/product_model.dart';
import 'package:shoplite/features/products/presentation/product_detail_screen.dart';
import 'package:shoplite/features/products/presentation/widgets/favorite_button.dart';

/// One row of a product list. Reused by the catalogue and the favourites
/// screen. It is a `const` widget, so an unchanged card is not rebuilt.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },
                // One clear announcement for screen readers instead of
                // five separate fragments.
                child: Semantics(
                  button: true,
                  excludeSemantics: true,
                  label: '${product.title}, ${product.priceLabel}, '
                      'rated ${product.ratingLabel} out of 5',
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        AppNetworkImage(
                          url: product.thumbnail,
                          width: 88,
                          height: 88,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                product.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: [
                                  Text(
                                    product.priceLabel,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: AppColors.rating,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    product.ratingLabel,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            FavoriteButton(product: product),
            const SizedBox(width: AppSpacing.xs),
          ],
        ),
      ),
    );
  }
}
