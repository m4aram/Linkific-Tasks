import 'package:flutter/material.dart';

/// Fades and slides its child in once, the first time it appears.
/// Turned off when the user asked the system to reduce motion.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final Duration delay;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    const duration = Duration(milliseconds: 320);
    final total = duration + delay;
    final start = delay.inMilliseconds / total.inMilliseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
