import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../utils/category_style.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_list_skeleton.dart';
import '../widgets/expense_tile.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/responsive_center.dart';
import '../widgets/summary_card.dart';
import 'expense_actions.dart';
import 'expense_details_screen.dart';
import 'expense_form_screen.dart';

/// Main screen: monthly summary, search / filter / sort bar and the
/// expense list (tap for details, swipe left to delete with Undo).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ExpenseProvider>().loadExpenses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final provider = context.read<ExpenseProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await provider.loadExpenses();
    // A failed first load shows the error screen; a failed refresh keeps
    // the list on screen and explains what happened.
    if (!ok && provider.loadError != null && provider.hasLoaded) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(provider.loadError!)));
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You can log back in at any time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await auth.signOut();
    // On success AuthGate shows the Login screen and clears the data.
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Could not log out.')),
      );
    }
  }

  void _clearFilters() {
    _searchController.clear();
    context.read<ExpenseProvider>().clearFilters();
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

  void _deleteBySwipe(Expense expense) {
    deleteExpenseWithUndo(
      provider: context.read<ExpenseProvider>(),
      messenger: ScaffoldMessenger.of(context),
      expense: expense,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        actions: [
          _AppMenu(onLogout: _logout),
        ],
      ),
      floatingActionButton: provider.hasLoaded
          ? FloatingActionButton.extended(
              onPressed: _openForm,
              icon: const Icon(Icons.add),
              label: const Text('Add Expense'),
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(ExpenseProvider provider) {
    if (!provider.hasLoaded && provider.loadError == null) {
      return const ExpenseListSkeleton(key: ValueKey('loading'));
    }

    if (!provider.hasLoaded) {
      return Center(
        key: const ValueKey('error'),
        child: SingleChildScrollView(
          child: EmptyState(
            icon: Icons.cloud_off_outlined,
            title: 'Could not load your expenses',
            message: provider.loadError!,
            actionLabel: provider.isLoading ? null : 'Try again',
            onAction: _refresh,
            isError: true,
          ),
        ),
      );
    }

    final visible = provider.visibleExpenses;
    final side = ResponsiveCenter.sidePadding(context);
    final header = <Widget>[
      SummaryCard(
        month: DateTime.now(),
        monthTotal: provider.thisMonthTotal,
        allTimeTotal: provider.total,
        count: provider.expenses.length,
        breakdownLabel: provider.period.label,
        breakdown: provider.categoryTotals,
      ),
      if (provider.expenses.isNotEmpty)
        _FilterBar(
          provider: provider,
          searchController: _searchController,
        ),
      if (provider.hasActiveFilters)
        _ResultsHeader(
          count: visible.length,
          total: provider.visibleTotal,
          onClear: _clearFilters,
        ),
    ];

    final Widget? emptyState = provider.expenses.isEmpty
        ? EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No expenses yet',
            message: 'Add your first expense to start tracking '
                'where your money goes.',
            actionLabel: 'Add expense',
            onAction: _openForm,
          )
        : visible.isEmpty
            ? EmptyState(
                icon: Icons.search_off_outlined,
                title: 'No matching expenses',
                message: 'Try a different search or clear the filters.',
                actionLabel: 'Clear filters',
                onAction: _clearFilters,
              )
            : null;

    final itemCount = header.length + (emptyState != null ? 1 : visible.length);

    return RefreshIndicator(
      key: const ValueKey('content'),
      onRefresh: _refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(side, AppSpacing.lg, side, 104),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index < header.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: header[index],
            );
          }
          if (emptyState != null) return emptyState;

          final position = index - header.length;
          final expense = visible[position];
          final tile = Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _SwipeToDelete(
              expense: expense,
              onDelete: () => _deleteBySwipe(expense),
              child: ExpenseTile(
                expense: expense,
                onTap: () => _openDetails(expense),
              ),
            ),
          );
          // Only the first screenful gets the entrance animation.
          return position < 10
              ? FadeSlideIn(
                  key: ValueKey('anim-${expense.id}'),
                  delay: Duration(milliseconds: 30 * position),
                  child: tile,
                )
              : tile;
        },
      ),
    );
  }
}

class _AppMenu extends StatelessWidget {
  final VoidCallback onLogout;

  const _AppMenu({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final email = context.select<AuthProvider, String>(
      (a) => a.user?.email ?? '',
    );

    return PopupMenuButton<Object>(
      tooltip: 'Menu',
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value is ThemeMode) themeProvider.setMode(value);
        if (value == 'logout') onLogout();
      },
      itemBuilder: (context) => [
        if (email.isNotEmpty)
          PopupMenuItem<Object>(
            enabled: false,
            child: Text(email, overflow: TextOverflow.ellipsis),
          ),
        const PopupMenuDivider(),
        for (final (mode, label) in const [
          (ThemeMode.system, 'System theme'),
          (ThemeMode.light, 'Light theme'),
          (ThemeMode.dark, 'Dark theme'),
        ])
          CheckedPopupMenuItem<Object>(
            value: mode,
            checked: themeProvider.mode == mode,
            child: Text(label),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem<Object>(
          value: 'logout',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout),
            title: Text('Log out'),
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  final ExpenseProvider provider;
  final TextEditingController searchController;

  const _FilterBar({required this.provider, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: searchController,
                builder: (context, value, _) => TextField(
                  controller: searchController,
                  onChanged: provider.setQuery,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search expenses',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    suffixIcon: value.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              provider.setQuery('');
                            },
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            PopupMenuButton<ExpenseSort>(
              tooltip: 'Sort',
              initialValue: provider.sort,
              onSelected: provider.setSort,
              icon: const Icon(Icons.sort),
              itemBuilder: (context) => [
                for (final sort in ExpenseSort.values)
                  CheckedPopupMenuItem(
                    value: sort,
                    checked: provider.sort == sort,
                    child: Text(sort.label),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _ChipRow(
          children: [
            for (final period in ExpensePeriod.values)
              ChoiceChip(
                label: Text(period.label),
                selected: provider.period == period,
                onSelected: (_) => provider.setPeriod(period),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _ChipRow(
          children: [
            FilterChip(
              label: const Text('All categories'),
              selected: provider.category == null,
              onSelected: (_) => provider.setCategory(null),
            ),
            for (final category in Expense.categories)
              FilterChip(
                avatar: Icon(
                  CategoryStyle.of(category).icon,
                  size: 18,
                  color: CategoryStyle.of(category).color,
                ),
                label: Text(category),
                selected: provider.category == category,
                showCheckmark: false,
                onSelected: (selected) =>
                    provider.setCategory(selected ? category : null),
              ),
          ],
        ),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  final List<Widget> children;

  const _ChipRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  final int count;
  final double total;
  final VoidCallback onClear;

  const _ResultsHeader({
    required this.count,
    required this.total,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final noun = count == 1 ? 'expense' : 'expenses';
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count $noun · ${formatAmount(total)}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        TextButton(onPressed: onClear, child: const Text('Clear filters')),
      ],
    );
  }
}

class _SwipeToDelete extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  final Widget child;

  const _SwipeToDelete({
    required this.expense,
    required this.onDelete,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey('dismiss-${expense.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Icon(
          Icons.delete_outline,
          color: scheme.onErrorContainer,
          semanticLabel: 'Delete',
        ),
      ),
      child: child,
    );
  }
}
