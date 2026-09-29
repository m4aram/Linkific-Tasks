import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final SupabaseClient supabase;

  ChatService(this.supabase);

  Future<List<Map<String, dynamic>>> getMessages() async {
    final response = await supabase
        .from('messages')
        .select()
        .order('created_at');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> sendMessage(String text) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await supabase.from('messages').insert({
      'user_id': user.id,
      'message': text,
    });
  }
}
