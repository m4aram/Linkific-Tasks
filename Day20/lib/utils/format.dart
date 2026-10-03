String money(double value) => '\$${value.toStringAsFixed(2)}';

String two(int n) => n.toString().padLeft(2, '0');
