import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/utils/error_messages.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  final now = DateTime(2026, 10, 13);

  late FakeExpenseService service;
  late ExpenseProvider provider;

  setUp(() {
    service = FakeExpenseService(
      initial: [
        sampleExpense(id: '1', title: 'Coffee', amount: 4.5, date: DateTime(2026, 10, 12)),
        sampleExpense(id: '2', title: 'Bus pass', amount: 30, category: 'Transport', date: DateTime(2026, 10, 2)),
        sampleExpense(id: '3', title: 'Groceries', amount: 80, date: DateTime(2026, 9, 20)),
      ],
    );
    provider = ExpenseProvider(service, now: () => now);
  });

  test('loads expenses and computes totals', () async {
    expect(await provider.loadExpenses(), isTrue);
    expect(provider.hasLoaded, isTrue);
    expect(provider.expenses, hasLength(3));
    expect(provider.total, 114.5);
    expect(provider.thisMonthTotal, 34.5);
  });

  test('a failed first load sets a friendly error', () async {
    service.failFetch = true;
    expect(await provider.loadExpenses(), isFalse);
    expect(provider.hasLoaded, isFalse);
    expect(provider.loadError, offlineErrorMessage);
  });

  test('a failed refresh keeps the current list', () async {
    await provider.loadExpenses();
    service.failFetch = true;
    expect(await provider.loadExpenses(), isFalse);
    expect(provider.expenses, hasLength(3));
  });

  test('search, category and period filters', () async {
    await provider.loadExpenses();

    provider.setQuery('  cof ');
    expect(provider.visibleExpenses.map((e) => e.id), ['1']);

    provider.setQuery('');
    provider.setCategory('Food');
    expect(provider.visibleExpenses.map((e) => e.id), ['1', '3']);

    provider.setPeriod(ExpensePeriod.lastMonth);
    expect(provider.visibleExpenses.map((e) => e.id), ['3']);
    expect(provider.visibleTotal, 80);
    expect(provider.hasActiveFilters, isTrue);

    provider.clearFilters();
    expect(provider.visibleExpenses, hasLength(3));
    expect(provider.hasActiveFilters, isFalse);
  });

  test('sorting', () async {
    await provider.loadExpenses();
    provider.setSort(ExpenseSort.highest);
    expect(provider.visibleExpenses.map((e) => e.id), ['3', '2', '1']);
    provider.setSort(ExpenseSort.oldest);
    expect(provider.visibleExpenses.map((e) => e.id), ['3', '2', '1']);
    provider.setSort(ExpenseSort.lowest);
    expect(provider.visibleExpenses.map((e) => e.id), ['1', '2', '3']);
  });

  test('category breakdown shares add up to 1', () async {
    await provider.loadExpenses();
    final shares = provider.categoryTotals.map((c) => c.share);
    expect(shares.reduce((a, b) => a + b), closeTo(1, 0.0001));
    expect(provider.categoryTotals.first.category, 'Food');
  });

  test('add, update and delete', () async {
    await provider.loadExpenses();

    expect(await provider.addExpense(sampleExpense(id: '', title: 'Lunch', date: now)), isTrue);
    expect(provider.expenses, hasLength(4));
    final added = provider.visibleExpenses.first;
    expect(added.title, 'Lunch');

    expect(await provider.updateExpense(added.copyWith(amount: 12)), isTrue);
    expect(provider.findById(added.id)!.amount, 12);

    expect(await provider.deleteExpense(added.id), isTrue);
    expect(provider.findById(added.id), isNull);
  });

  test('failed delete puts the expense back in the same place', () async {
    await provider.loadExpenses();
    service.failDelete = true;
    expect(await provider.deleteExpense('2'), isFalse);
    expect(provider.expenses.map((e) => e.id), ['1', '2', '3']);
    expect(provider.actionError, offlineErrorMessage);
  });

  test('undo restores a deleted expense', () async {
    await provider.loadExpenses();
    final coffee = provider.findById('1')!;
    await provider.deleteExpense('1');
    expect(await provider.restoreExpense(coffee), isTrue);
    expect(provider.expenses.any((e) => e.title == 'Coffee'), isTrue);
  });

  test('clear removes data and filters on logout', () async {
    await provider.loadExpenses();
    provider.setCategory('Food');
    provider.clear();
    expect(provider.expenses, isEmpty);
    expect(provider.hasLoaded, isFalse);
    expect(provider.hasActiveFilters, isFalse);
  });
}
