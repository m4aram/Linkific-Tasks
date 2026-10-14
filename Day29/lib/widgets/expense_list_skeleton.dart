import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'responsive_center.dart';

/// Placeholder shown while expenses load for the first time. It has the same
/// shape as the real screen, so nothing jumps when the data arrives.
class ExpenseListSkeleton extends StatefulWidget {
  const ExpenseListSkeleton({super.key});

  @override
  State<ExpenseListSkeleton> createState() => _ExpenseListSkeletonState();
}

class _ExpenseListSkeletonState extends State<ExpenseListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    final side = ResponsiveCenter.sidePadding(context);

    Widget block(double height, {double? width, double radius = 8}) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Semantics(
      label: 'Loading expenses',
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding:
              EdgeInsets.fromLTRB(side, AppSpacing.lg, side, AppSpacing.lg),
          children: [
            block(170, radius: AppRadius.lg),
            const SizedBox(height: AppSpacing.lg),
            block(48, radius: AppRadius.sm),
            const SizedBox(height: AppSpacing.lg),
            for (var i = 0; i < 5; i++) ...[
              Row(
                children: [
                  block(44, width: 44, radius: 22),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        block(14, width: 160),
                        const SizedBox(height: AppSpacing.sm),
                        block(12, width: 100),
                      ],
                    ),
                  ),
                  block(16, width: 64),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ],
        ),
      ),
    );
  }
}
