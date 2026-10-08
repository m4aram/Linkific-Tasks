import 'package:flutter/material.dart';

/// Brand colours. Everything else is derived from [seed] through
/// `ColorScheme.fromSeed`, so light and dark themes stay consistent.
abstract final class AppColors {
  static const Color seed = Color(0xFF1B7F5C);
  static const Color rating = Color(0xFFF5A623);
}

/// Spacing scale (logical pixels).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Corner radii.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}
