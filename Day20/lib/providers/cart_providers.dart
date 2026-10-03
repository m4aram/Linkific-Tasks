import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import 'auth_providers.dart';

/// Provider = read-only value that never changes (the product list).
final productCatalogProvider = Provider<List<Product>>((ref) => kProducts);

class CartLine {
  final Product product;
  final int quantity;

  const CartLine(this.product, this.quantity);

  double get total => product.price * quantity;

  CartLine copyWith({int? quantity}) => CartLine(product, quantity ?? this.quantity);
}

/// NotifierProvider with a Map state (product id -> line). Every change creates a new Map.
class CartNotifier extends Notifier<Map<int, CartLine>> {
  @override
  Map<int, CartLine> build() => const {};

  void add(Product product) {
    final line = state[product.id];
    state = {
      ...state,
      product.id: line == null ? CartLine(product, 1) : line.copyWith(quantity: line.quantity + 1),
    };
  }

  void decrease(int productId) {
    final line = state[productId];
    if (line == null) return;
    if (line.quantity > 1) {
      state = {...state, productId: line.copyWith(quantity: line.quantity - 1)};
    } else {
      remove(productId);
    }
  }

  void remove(int productId) {
    final next = {...state};
    next.remove(productId);
    state = next;
  }

  void clear() => state = {};
}

final cartProvider = NotifierProvider<CartNotifier, Map<int, CartLine>>(CartNotifier.new);

/// Provider = derived list for the UI.
final cartLinesProvider = Provider<List<CartLine>>((ref) {
  return ref.watch(cartProvider).values.toList();
});

/// Provider = derived number (the badge). Widgets rebuild only when the count changes.
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).values.fold(0, (sum, line) => sum + line.quantity);
});

class CartSummary {
  static const double memberDiscountRate = 0.10;
  static const double freeShippingFrom = 100.0;
  static const double shippingFee = 5.0;

  final int itemCount;
  final double subtotal;
  final double discount;
  final double shipping;
  final bool isMember;

  const CartSummary({
    required this.itemCount,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.isMember,
  });

  double get total => subtotal - discount + shipping;

  @override
  bool operator ==(Object other) =>
      other is CartSummary &&
      other.itemCount == itemCount &&
      other.subtotal == subtotal &&
      other.discount == discount &&
      other.shipping == shipping &&
      other.isMember == isMember;

  @override
  int get hashCode => Object.hash(itemCount, subtotal, discount, shipping, isMember);
}

/// Provider that depends on TWO other providers (cart + login state).
/// Log in -> isMemberProvider changes -> this recalculates -> the cart screen updates.
/// No glue code is needed: Riverpod tracks the dependencies from ref.watch.
final cartSummaryProvider = Provider<CartSummary>((ref) {
  final lines = ref.watch(cartProvider).values;
  final isMember = ref.watch(isMemberProvider);

  final subtotal = lines.fold(0.0, (sum, line) => sum + line.total);
  final itemCount = lines.fold(0, (sum, line) => sum + line.quantity);
  final discount = isMember ? subtotal * CartSummary.memberDiscountRate : 0.0;
  final shipping = (subtotal == 0 || subtotal >= CartSummary.freeShippingFrom)
      ? 0.0
      : CartSummary.shippingFee;

  return CartSummary(
    itemCount: itemCount,
    subtotal: subtotal,
    discount: discount,
    shipping: shipping,
    isMember: isMember,
  );
});
