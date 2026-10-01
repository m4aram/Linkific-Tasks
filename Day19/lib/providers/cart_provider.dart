import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  bool _isMember = false;

  List<CartItem> get items => _items.values.toList(growable: false);
  bool get isEmpty => _items.isEmpty;
  bool get isMember => _isMember;
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.values.fold(0.0, (sum, item) => sum + item.total);

  int quantityOf(int productId) => _items[productId]?.quantity ?? 0;

  void add(Product product) {
    final existing = _items[product.id];
    if (existing == null) {
      _items[product.id] = CartItem(product: product);
    } else {
      existing.quantity++;
    }
    notifyListeners();
  }

  void decrease(int productId) {
    final existing = _items[productId];
    if (existing == null) return;
    if (existing.quantity > 1) {
      existing.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Called by ChangeNotifierProxyProvider every time AuthProvider changes.
  void updateMembership(bool value) {
    if (_isMember == value) return;
    _isMember = value;
    notifyListeners();
  }
}

/// A read-only snapshot calculated from the cart (created by ProxyProvider).
/// The UI reads totals from here instead of repeating the maths in every screen.
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

  factory CartSummary.fromCart(CartProvider cart) {
    final subtotal = cart.subtotal;
    final discount = cart.isMember ? subtotal * memberDiscountRate : 0.0;
    final shipping = (subtotal == 0 || subtotal >= freeShippingFrom) ? 0.0 : shippingFee;
    return CartSummary(
      itemCount: cart.itemCount,
      subtotal: subtotal,
      discount: discount,
      shipping: shipping,
      isMember: cart.isMember,
    );
  }

  double get total => subtotal - discount + shipping;
}
