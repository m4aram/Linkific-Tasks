class OrderItem {
  const OrderItem(this.name, this.price, this.quantity);

  final String name;
  final double price;
  final int quantity;

  double get subtotal => price * quantity;
}

/// Practice for BREAKPOINTS. The buggy version returns the wrong total.
class OrderCalculator {
  /// BUG (intentional): the loop starts at 1, so the first item is skipped.
  /// Find it by putting a breakpoint on the `total +=` line and watching `i` and `total`.
  static double buggyTotal(List<OrderItem> items, {double discountPercent = 0}) {
    var total = 0.0;
    for (var i = 1; i < items.length; i++) {
      total += items[i].subtotal;
    }
    return total - total * discountPercent / 100;
  }

  static double total(List<OrderItem> items, {double discountPercent = 0}) {
    var total = 0.0;
    for (final item in items) {
      total += item.subtotal;
    }
    return total - total * discountPercent / 100;
  }
}
