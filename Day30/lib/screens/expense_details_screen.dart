import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/category_avatar.dart';
import '../widgets/empty_state.dart';
import '../widgets/responsive_center.dart';
import 'expense_actions.dart';
import 'expense_form_screen.dart';

/// Shows one expense with Edit and Delete actions.
///
/// Looks the expense up by id on every build, so it always shows the
/// latest data after an edit and handles the expense being deleted.
class ExpenseDetailsScreen extends StatelessWidget {
  final String expenseId;

  const ExpenseDetailsScreen({super.key, required this.expenseId});

  Future<void> _delete(BuildContext context) async {
    final provider = context.read<ExpenseProvider>();
    final expense = provider.findById(expenseId);
    if (expense == null) return;

    final confirmed = await confirmDelete(context, expense);
    if (!confirmed || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    await deleteExpenseWithUndo(
      provider: provider,
      messenger: messenger,
      expense: expense,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final expense = provider.findById(expenseId);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    if (expense == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: EmptyState(
            icon: Icons.search_off_outlined,
            title: 'Expense not found',
            message: 'It may have been deleted on another device.',
            actionLabel: 'Back to expenses',
            onAction: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }

    final friendlyDate = formatFriendlyDate(expense.date);
    final isoDate = formatDate(expense.date);

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ResponsiveCenter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: CategoryAvatar(
                    category: expense.category,
                    size: 72,
                    heroTag: 'expense-icon-${expense.id}',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  expense.title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  formatAmount(expense.amount),
                  textAlign: TextAlign.center,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.category_outlined),
                        title: const Text('Category'),
                        subtitle: Text(expense.category),
                      ),
                      const Divider(height: 1, indent: AppSpacing.lg),
                      ListTile(
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: const Text('Date'),
                        subtitle: Text(
                          friendlyDate == isoDate
                              ? isoDate
                              : '$friendlyDate · $isoDate',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: provider.isSaving
                            ? null
                            : () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ExpenseFormScreen(expense: expense),
                                  ),
                                ),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          backgroundColor: scheme.errorContainer,
                          foregroundColor: scheme.onErrorContainer,
                        ),
                        onPressed:
                            provider.isSaving ? null : () => _delete(context),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
