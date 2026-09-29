import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient supabase;

  ProfileService(this.supabase);

  Future<void> createProfile({
    required String username,
    required String fullName,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await supabase.from('profiles').insert({
      'id': user.id,
      'username': username,
      'full_name': fullName,
    });
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return response;
  }

  Future<void> updateProfile({
    required String username,
    required String fullName,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase
        .from('profiles')
        .update({'username': username, 'full_name': fullName})
        .eq('id', user.id);
  }
}
