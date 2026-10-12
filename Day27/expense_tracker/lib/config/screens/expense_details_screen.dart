import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../utils/formatters.dart';
import 'expense_form_screen.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final String expenseId;

  const ExpenseDetailsScreen({super.key, required this.expenseId});

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete expense'),
        content: const Text('This expense will be deleted permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final provider = context.read<ExpenseProvider>();
    final ok = await provider.deleteExpense(expenseId);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Expense deleted' : provider.error ?? 'Delete failed'),
      ),
    );
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final expense = provider.findById(expenseId);

    if (expense == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Expense not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: provider.isSaving
                ? null
                : () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ExpenseFormScreen(expense: expense),
                      ),
                    ),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: provider.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
            onPressed: provider.isSaving ? null : () => _delete(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(expense.title,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            formatAmount(expense.amount),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Category'),
            subtitle: Text(expense.category),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Date'),
            subtitle: Text(formatDate(expense.date)),
          ),
        ],
      ),
    );
  }
}
