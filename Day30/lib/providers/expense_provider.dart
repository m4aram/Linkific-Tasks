import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import '../utils/error_messages.dart';

enum ExpenseSort {
  newest('Newest first'),
  oldest('Oldest first'),
  highest('Highest amount'),
  lowest('Lowest amount');

  const ExpenseSort(this.label);
  final String label;
}

enum ExpensePeriod {
  all('All time'),
  thisMonth('This month'),
  lastMonth('Last month');

  const ExpensePeriod(this.label);
  final String label;
}

/// Total spent in one category and its share (0–1) of the visible total.
class CategoryTotal {
  final String category;
  final double amount;
  final double share;

  const CategoryTotal(this.category, this.amount, this.share);
}

/// App state for expenses: the list loaded from Supabase, the current
/// search / filters / sort, and derived totals for the summary card.
///
/// Every server call has a 20 s timeout and turns errors into friendly
/// messages ([loadError], [actionError]) instead of throwing.
class ExpenseProvider extends ChangeNotifier {
  static const Duration _timeout = Duration(seconds: 20);

  final ExpenseService _service;
  final DateTime Function() _now;

  ExpenseProvider(this._service, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  List<Expense> _expenses = [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  bool _isSaving = false;
  String? _loadError;
  String? _actionError;

  String _query = '';
  String? _category;
  ExpensePeriod _period = ExpensePeriod.all;
  ExpenseSort _sort = ExpenseSort.newest;

  // Derived data is computed once per change instead of on every build.
  List<Expense> _visible = const [];
  double _visibleTotal = 0;
  List<CategoryTotal> _categoryTotals = const [];

  List<Expense> get expenses => List.unmodifiable(_expenses);
  List<Expense> get visibleExpenses => _visible;
  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  bool get isSaving => _isSaving;
  String? get loadError => _loadError;
  String? get actionError => _actionError;

  String get query => _query;
  String? get category => _category;
  ExpensePeriod get period => _period;
  ExpenseSort get sort => _sort;
  bool get hasActiveFilters =>
      _query.isNotEmpty || _category != null || _period != ExpensePeriod.all;

  double get total => _expenses.fold(0, (sum, e) => sum + e.amount);
  double get visibleTotal => _visibleTotal;
  List<CategoryTotal> get categoryTotals => _categoryTotals;

  double get thisMonthTotal {
    final now = _now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0, (sum, e) => sum + e.amount);
  }

  Expense? findById(String id) {
    for (final e in _expenses) {
      if (e.id == id) return e;
    }
    return null;
  }

  /// Returns false when loading failed. A failed refresh keeps the
  /// expenses that are already on screen.
  Future<bool> loadExpenses() async {
    if (_isLoading) return false;
    _isLoading = true;
    _loadError = null;
    notifyListeners();
    try {
      _expenses = await _service.fetchExpenses().timeout(_timeout);
      _hasLoaded = true;
      _recompute();
      return true;
    } catch (e) {
      _loadError = friendlyError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addExpense(Expense expense) {
    return _save(() async {
      final created = await _service.addExpense(expense).timeout(_timeout);
      _expenses.insert(0, created);
    });
  }

  Future<bool> updateExpense(Expense expense) {
    return _save(() async {
      final updated = await _service.updateExpense(expense).timeout(_timeout);
      final index = _expenses.indexWhere((e) => e.id == updated.id);
      if (index != -1) _expenses[index] = updated;
    });
  }

  /// Optimistic delete: the expense disappears right away and comes back
  /// in the same place if the server call fails.
  Future<bool> deleteExpense(String id) async {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return false;

    final removed = _expenses.removeAt(index);
    _actionError = null;
    _recompute();
    notifyListeners();

    try {
      await _service.deleteExpense(id).timeout(_timeout);
      return true;
    } catch (e) {
      _expenses.insert(math.min(index, _expenses.length), removed);
      _actionError = friendlyError(e);
      _recompute();
      notifyListeners();
      return false;
    }
  }

  /// Used by the "Undo" action after a delete.
  Future<bool> restoreExpense(Expense expense) => addExpense(expense);

  void setQuery(String value) {
    final next = value.trim();
    if (next == _query) return;
    _query = next;
    _refreshView();
  }

  void setCategory(String? value) {
    if (value == _category) return;
    _category = value;
    _refreshView();
  }

  void setPeriod(ExpensePeriod value) {
    if (value == _period) return;
    _period = value;
    _refreshView();
  }

  void setSort(ExpenseSort value) {
    if (value == _sort) return;
    _sort = value;
    _refreshView();
  }

  void clearFilters() {
    if (!hasActiveFilters) return;
    _query = '';
    _category = null;
    _period = ExpensePeriod.all;
    _refreshView();
  }

  /// Called on logout so the next user does not see old data.
  void clear() {
    if (_expenses.isEmpty && !_hasLoaded && _loadError == null) return;
    _expenses = [];
    _hasLoaded = false;
    _loadError = null;
    _actionError = null;
    _query = '';
    _category = null;
    _period = ExpensePeriod.all;
    _sort = ExpenseSort.newest;
    _refreshView();
  }

  Future<bool> _save(Future<void> Function() action) async {
    if (_isSaving) return false;
    _isSaving = true;
    _actionError = null;
    notifyListeners();
    try {
      await action();
      _recompute();
      return true;
    } catch (e) {
      _actionError = friendlyError(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void _refreshView() {
    _recompute();
    notifyListeners();
  }

  void _recompute() {
    final now = _now();
    final query = _query.toLowerCase();

    final filtered = <Expense>[];
    for (final e in _expenses) {
      if (_category != null && e.category != _category) continue;
      if (!_inPeriod(e.date, now)) continue;
      if (query.isNotEmpty &&
          !e.title.toLowerCase().contains(query) &&
          !e.category.toLowerCase().contains(query)) {
        continue;
      }
      filtered.add(e);
    }

    _visible = List.unmodifiable(_stableSort(filtered));
    _visibleTotal = _visible.fold(0, (sum, e) => sum + e.amount);

    final byCategory = <String, double>{};
    for (final e in _visible) {
      byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
    }
    final totals = byCategory.entries
        .map(
          (entry) => CategoryTotal(
            entry.key,
            entry.value,
            _visibleTotal == 0 ? 0 : entry.value / _visibleTotal,
          ),
        )
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    _categoryTotals = List.unmodifiable(totals);
  }

  bool _inPeriod(DateTime date, DateTime now) {
    switch (_period) {
      case ExpensePeriod.all:
        return true;
      case ExpensePeriod.thisMonth:
        return date.year == now.year && date.month == now.month;
      case ExpensePeriod.lastMonth:
        final last = DateTime(now.year, now.month - 1);
        return date.year == last.year && date.month == last.month;
    }
  }

  /// Sorts while keeping the server order for ties (Dart's sort is not stable).
  List<Expense> _stableSort(List<Expense> items) {
    final indexed = items.indexed.toList();
    int compare((int, Expense) a, (int, Expense) b) {
      final result = switch (_sort) {
        ExpenseSort.newest => b.$2.date.compareTo(a.$2.date),
        ExpenseSort.oldest => a.$2.date.compareTo(b.$2.date),
        ExpenseSort.highest => b.$2.amount.compareTo(a.$2.amount),
        ExpenseSort.lowest => a.$2.amount.compareTo(b.$2.amount),
      };
      return result != 0 ? result : a.$1.compareTo(b.$1);
    }

    indexed.sort(compare);
    return [for (final (_, expense) in indexed) expense];
  }
}
