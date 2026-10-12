import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _service;

  ExpenseProvider(this._service);

  List<Expense> _expenses = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  double get total => _expenses.fold(0, (sum, e) => sum + e.amount);

  Expense? findById(String id) {
    for (final e in _expenses) {
      if (e.id == id) return e;
    }
    return null;
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _expenses = await _service.fetchExpenses();
    } catch (e) {
      _error = _message(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addExpense(Expense expense) {
    return _save(() async {
      final created = await _service.addExpense(expense);
      _expenses.insert(0, created);
    });
  }

  Future<bool> updateExpense(Expense expense) {
    return _save(() async {
      final updated = await _service.updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == updated.id);
      if (index != -1) _expenses[index] = updated;
    });
  }

  Future<bool> deleteExpense(String id) {
    return _save(() async {
      await _service.deleteExpense(id);
      _expenses.removeWhere((e) => e.id == id);
    });
  }

  /// Called on logout so the next user does not see old data.
  void clear() {
    _expenses = [];
    _error = null;
    notifyListeners();
  }

  Future<bool> _save(Future<void> Function() action) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _error = _message(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  String _message(Object e) {
    if (e is PostgrestException) return e.message;
    return 'Something went wrong. Please try again.';
  }
}
