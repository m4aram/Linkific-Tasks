import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_assets.dart';
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/theme/app_colors.dart';
import 'package:shoplite/core/utils/debouncer.dart';
import 'package:shoplite/core/utils/validators.dart';
import 'package:shoplite/core/widgets/loading_view.dart';
import 'package:shoplite/core/widgets/status_view.dart';
import 'package:shoplite/features/products/logic/products_controller.dart';
import 'package:shoplite/features/products/presentation/widgets/product_card.dart';

/// Catalogue with search and infinite scrolling.
///
/// This widget does NOT watch the product state: only [_ProductList]
/// does. New data therefore rebuilds the list, not the app bar or the
/// search field (and the keyboard never loses focus while typing).
class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _debouncer = Debouncer(delay: AppConstants.searchDebounce);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  /// Lazy loading: ask for the next page shortly before the end.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >=
        position.maxScrollExtent - AppConstants.loadMoreThreshold) {
      ref.read(productsControllerProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String rawText) {
    _debouncer.run(() {
      if (!mounted) return;
      final query = Validators.sanitizeSearch(rawText);
      if (query == ref.read(productsControllerProvider).query) return;
      ref.read(productsControllerProvider.notifier).loadFirstPage(query: query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.productsTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              inputFormatters: [
                LengthLimitingTextInputFormatter(AppConstants.maxSearchLength),
              ],
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search),
                // Only this small builder rebuilds as the text changes.
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      tooltip: AppStrings.clearSearch,
                      icon: const Icon(Icons.close),
                      onPressed: _clearSearch,
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(child: _ProductList(scrollController: _scrollController)),
        ],
      ),
    );
  }
}

class _ProductList extends ConsumerWidget {
  const _ProductList({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productsControllerProvider);
    final controller = ref.read(productsControllerProvider.notifier);
    final error = state.error;

    if (state.isLoading) return const LoadingView();

    final Widget content;
    if (state.items.isEmpty && error != null) {
      content = StatusView(
        asset: AppAssets.errorCloud,
        title: AppStrings.errorTitle,
        message: error,
        actionLabel: AppStrings.retry,
        onAction: controller.loadFirstPage,
      );
    } else if (state.items.isEmpty) {
      content = const StatusView(
        asset: AppAssets.emptyBox,
        title: AppStrings.noProductsTitle,
        message: AppStrings.noProductsMessage,
      );
    } else {
      // ListView.builder builds only the rows that are on screen (plus a
      // small cache), no matter how many products have been loaded.
      content = ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: state.items.length + 1,
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            return _ListFooter(
              isLoading: state.isLoadingMore,
              hasMore: state.hasMore,
              error: error,
              onRetry: () => controller.loadMore(retry: true),
            );
          }
          final product = state.items[index];
          return ProductCard(key: ValueKey<int>(product.id), product: product);
        },
      );
    }

    return RefreshIndicator(onRefresh: controller.refresh, child: content);
  }
}

/// Last row of the list: spinner, retry, or "end of list".
class _ListFooter extends StatelessWidget {
  const _ListFooter({
    required this.isLoading,
    required this.hasMore,
    required this.error,
    required this.onRetry,
  });

  final bool isLoading;
  final bool hasMore;
  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final error = this.error;

    final Widget child;
    if (isLoading) {
      child = const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          semanticsLabel: AppStrings.loading,
        ),
      );
    } else if (error != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            error,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text(AppStrings.retry)),
        ],
      );
    } else if (!hasMore) {
      child = Text(
        AppStrings.endOfList,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    } else {
      child = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(child: child),
    );
  }
}
