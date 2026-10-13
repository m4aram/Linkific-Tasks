import 'dart:async';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/auth_service.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// In-memory replacement for the Supabase expense table.
class FakeExpenseService extends ExpenseService {
  FakeExpenseService({List<Expense>? initial, this.failFetch = false})
      : items = [...?initial];

  final List<Expense> items;
  bool failFetch;
  bool failDelete = false;
  int _nextId = 100;

  @override
  Future<List<Expense>> fetchExpenses() async {
    if (failFetch) throw TimeoutException('offline');
    return [...items];
  }

  @override
  Future<Expense> addExpense(Expense expense) async {
    final created = expense.copyWith(id: '${_nextId++}');
    items.insert(0, created);
    return created;
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    final index = items.indexWhere((e) => e.id == expense.id);
    items[index] = expense;
    return expense;
  }

  @override
  Future<void> deleteExpense(String id) async {
    if (failDelete) throw TimeoutException('offline');
    items.removeWhere((e) => e.id == id);
  }
}

/// Logged-out auth service that never talks to Supabase.
class FakeAuthService extends AuthService {
  @override
  User? get currentUser => null;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();
}

Expense sampleExpense({
  String id = '1',
  String title = 'Coffee',
  double amount = 4.5,
  String category = 'Food',
  DateTime? date,
}) {
  return Expense(
    id: id,
    title: title,
    amount: amount,
    category: category,
    date: date ?? DateTime(2026, 10, 10),
  );
}
