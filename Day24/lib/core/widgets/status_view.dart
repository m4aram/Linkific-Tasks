import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoplite/core/theme/app_colors.dart';

/// Illustration + title + message (+ optional action). One widget covers
/// both the "empty" and the "error" state of every screen.
///
/// It is scrollable on purpose, so pull-to-refresh keeps working when it
/// replaces a list.
class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.asset,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String asset;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionLabel = this.actionLabel;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decorative: the text below already says everything.
                    SvgPicture.asset(
                      asset,
                      width: 160,
                      height: 120,
                      excludeFromSemantics: true,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (actionLabel != null && onAction != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton.tonal(
                        onPressed: onAction,
                        child: Text(actionLabel),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
