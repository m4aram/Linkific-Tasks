import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../utils/category_style.dart';
import '../utils/formatters.dart';
import 'animated_amount.dart';

/// Top card on the home screen: this month's spending, totals and a
/// category breakdown of the expenses currently shown.
class SummaryCard extends StatelessWidget {
  final DateTime month;
  final double monthTotal;
  final double allTimeTotal;
  final int count;
  final String breakdownLabel;
  final List<CategoryTotal> breakdown;

  const SummaryCard({
    super.key,
    required this.month,
    required this.monthTotal,
    required this.allTimeTotal,
    required this.count,
    required this.breakdownLabel,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final onCard = scheme.onPrimaryContainer;

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spent in ${formatMonth(month)}',
              style: textTheme.labelLarge?.copyWith(
                color: onCard.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AnimatedAmount(
              value: monthTotal,
              style: textTheme.headlineLarge?.copyWith(
                color: onCard,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.sm,
              children: [
                _Stat(label: 'All time', value: formatAmount(allTimeTotal)),
                _Stat(
                  label: 'Expenses',
                  value: '$count',
                ),
              ],
            ),
            if (breakdown.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Breakdown · $breakdownLabel',
                style: textTheme.labelMedium?.copyWith(
                  color: onCard.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _CategoryBar(breakdown: breakdown),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final item in breakdown.take(4))
                    _Legend(item: item, color: onCard),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onCard = Theme.of(context).colorScheme.onPrimaryContainer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: onCard.withValues(alpha: 0.75),
            letterSpacing: 0.6,
          ),
        ),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: onCard,
            fontWeight: FontWeight.w600,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final List<CategoryTotal> breakdown;

  const _CategoryBar({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Spending by category',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 10,
          child: Row(
            children: [
              for (final item in breakdown)
                Expanded(
                  flex: math.max(1, (item.share * 1000).round()),
                  child: ColoredBox(color: CategoryStyle.of(item.category).color),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final CategoryTotal item;
  final Color color;

  const _Legend({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    final percent = (item.share * 100).round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: CategoryStyle.of(item.category).color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${item.category} $percent%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
