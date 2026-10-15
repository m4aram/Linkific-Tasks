import 'package:flutter/material.dart';

import '../utils/formatters.dart';

/// Shows a money value that counts smoothly to its new value when it changes.
class AnimatedAmount extends StatelessWidget {
  final double value;
  final TextStyle? style;

  const AnimatedAmount({super.key, required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value),
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) => Text(
        formatAmount(animated),
        style: style?.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        semanticsLabel: formatAmount(value),
      ),
    );
  }
}
