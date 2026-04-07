// ════════════════════════════════════════════════════════════════════════════
// ⚡ SUPABASE CONFIGURATION
// ════════════════════════════════════════════════════════════════════════════
//
// ⚠️ PENTING: GANTI 2 VALUE INI SEBELUM RUN APP!
//
// Cara dapat:
// 1. Buka https://supabase.com/dashboard
// 2. Pilih project kamu
// 3. Settings (⚙️) → API
// 4. Copy Project URL & anon/public key
// ════════════════════════════════════════════════════════════════════════════

/// Supabase Configuration
abstract final class SupabaseConfig {
  /// ⚡ Supabase Project URL
  ///
  /// ⚠️ GANTI dengan URL project kamu!
  /// Contoh: 'https://xxxxxxxxxxxxx.supabase.co'
  static const String url = 'https://YOUR_PROJECT_ID.supabase.co';

  /// ⚡ Supabase Anon/Public Key
  ///
  /// ⚠️ GANTI dengan anon key kamu!
  /// Contoh: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
  static const String anonKey = 'YOUR_ANON_KEY';
}
