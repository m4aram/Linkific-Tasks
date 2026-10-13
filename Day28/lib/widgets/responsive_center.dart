import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Keeps content readable on wide screens (tablet, desktop, web)
/// by centering it with a maximum width.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
  });

  /// Side padding that centers a scrolling list of [maxWidth] while keeping
  /// the scroll area (and scrollbar) full width.
  static double sidePadding(
    BuildContext context, {
    double maxWidth = AppSpacing.maxContentWidth,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final extra = (width - maxWidth) / 2;
    return extra > AppSpacing.lg ? extra : AppSpacing.lg;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
