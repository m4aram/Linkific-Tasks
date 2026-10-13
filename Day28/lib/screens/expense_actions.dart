import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

/// Deletes an expense and offers "Undo" in a snackbar.
///
/// Takes the provider and messenger directly (instead of a BuildContext)
/// so it keeps working after the calling screen has closed.
Future<void> deleteExpenseWithUndo({
  required ExpenseProvider provider,
  required ScaffoldMessengerState messenger,
  required Expense expense,
}) async {
  final ok = await provider.deleteExpense(expense.id);
  messenger.hideCurrentSnackBar();

  if (!ok) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(provider.actionError ?? 'Could not delete the expense.'),
      ),
    );
    return;
  }

  messenger.showSnackBar(
    SnackBar(
      content: Text('Deleted "${expense.title}"'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          final restored = await provider.restoreExpense(expense);
          if (restored) return;
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                provider.actionError ?? 'Could not restore the expense.',
              ),
            ),
          );
        },
      ),
    ),
  );
}

/// Asks before deleting. Returns true when the user confirms.
Future<bool> confirmDelete(BuildContext context, Expense expense) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete expense?'),
      content: Text('"${expense.title}" will be removed from your expenses.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
            foregroundColor: Theme.of(dialogContext).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed == true;
}
