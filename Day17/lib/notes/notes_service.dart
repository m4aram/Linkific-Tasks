import 'package:supabase_flutter/supabase_flutter.dart';

class NotesService {
  final SupabaseClient supabase;

  NotesService(this.supabase);

  Future<List<Map<String, dynamic>>> getNotes() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await supabase
        .from('notes')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addNote({required String title, required String content}) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await supabase.from('notes').insert({
      'user_id': user.id,
      'title': title,
      'content': content,
    });
  }

  Future<void> updateNote({
    required int id,
    required String title,
    required String content,
  }) async {
    await supabase
        .from('notes')
        .update({'title': title, 'content': content})
        .eq('id', id);
  }

  Future<void> deleteNote(int id) async {
    await supabase.from('notes').delete().eq('id', id);
  }
}
