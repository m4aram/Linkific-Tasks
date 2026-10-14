/// Supabase project credentials.
/// Get them from: Supabase Dashboard > Project Settings > API.
///
/// The publishable (anon) key is designed to ship inside client apps.
/// Data is protected by the Row Level Security policies in
/// `supabase/schema.sql`, not by keeping this key secret.
/// Never put the `service_role` / secret key in the app.
class SupabaseConfig {
  static const String url = 'https://ypdtabwozmnhacbjthje.supabase.co';
  static const String anonKey =
      'sb_publishable_zRSYddsot8UTuBW_CmK4JA_IrO-eWl3';
}
