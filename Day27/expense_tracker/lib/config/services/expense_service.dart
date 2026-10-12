import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/expense.dart';

/// CRUD operations on the `expenses` table through the Supabase API.
class ExpenseService {
  static const String _table = 'expenses';

  final SupabaseClient _client;

  ExpenseService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  // Read
  Future<List<Expense>> fetchExpenses() async {
    final data = await _client
        .from(_table)
        .select()
        .order('date', ascending: false)
        .order('created_at', ascending: false);
    return data.map(Expense.fromMap).toList();
  }

  // Create
  Future<Expense> addExpense(Expense expense) async {
    final data =
        await _client.from(_table).insert(expense.toMap()).select().single();
    return Expense.fromMap(data);
  }

  // Update
  Future<Expense> updateExpense(Expense expense) async {
    final data = await _client
        .from(_table)
        .update(expense.toMap())
        .eq('id', expense.id)
        .select()
        .single();
    return Expense.fromMap(data);
  }

  // Delete
  Future<void> deleteExpense(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
