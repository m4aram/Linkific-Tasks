import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../utils/formatters.dart';
import 'expense_details_screen.dart';
import 'expense_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().loadExpenses();
    });
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    context.read<ExpenseProvider>().clear();
    await context.read<AuthProvider>().signOut();
  }

  void _openForm() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ExpenseFormScreen()),
    );
  }

  void _openDetails(Expense expense) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExpenseDetailsScreen(expenseId: expense.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final email = context.watch<AuthProvider>().user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      body: _buildBody(provider, email),
    );
  }

  Widget _buildBody(ExpenseProvider provider, String email) {
    // Loading state (first load)
    if (provider.isLoading && provider.expenses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (provider.error != null && provider.expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(provider.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: provider.loadExpenses,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadExpenses,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(email, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  const Text('Total spent'),
                  Text(
                    formatAmount(provider.total),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (provider.expenses.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: Center(
                child: Text('No expenses yet. Tap "Add Expense" to start.'),
              ),
            )
          else
            ...provider.expenses.map(
              (expense) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(expense.category[0]),
                  ),
                  title: Text(expense.title),
                  subtitle: Text(
                    '${expense.category} • ${formatDate(expense.date)}',
                  ),
                  trailing: Text(
                    formatAmount(expense.amount),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _openDetails(expense),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
