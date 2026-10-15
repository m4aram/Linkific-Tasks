import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/expense.dart';

/// CRUD operations on the `expenses` table through the Supabase API.
class ExpenseService {
  static const String _table = 'expenses';

  final SupabaseClient? _injectedClient;

  ExpenseService({SupabaseClient? client}) : _injectedClient = client;

  // Resolved lazily so tests can subclass this service without
  // initializing Supabase.
  SupabaseClient get _client => _injectedClient ?? Supabase.instance.client;

  Future<List<Expense>> fetchExpenses() async {
    final data = await _client
        .from(_table)
        .select('id, title, amount, category, date')
        .order('date', ascending: false)
        .order('created_at', ascending: false);
    return data.map(Expense.fromMap).toList();
  }

  Future<Expense> addExpense(Expense expense) async {
    final data =
        await _client.from(_table).insert(expense.toMap()).select().single();
    return Expense.fromMap(data);
  }

  Future<Expense> updateExpense(Expense expense) async {
    final data = await _client
        .from(_table)
        .update(expense.toMap())
        .eq('id', expense.id)
        .select()
        .single();
    return Expense.fromMap(data);
  }

  Future<void> deleteExpense(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
