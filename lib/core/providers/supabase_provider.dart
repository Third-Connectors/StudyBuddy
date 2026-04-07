// ════════════════════════════════════════════════════════════════════════════
// 🔌 SUPABASE PROVIDER — Riverpod Integration
// ════════════════════════════════════════════════════════════════════════════
//
// Provides Supabase client via Riverpod providers.
// Use these providers instead of direct Supabase.instance.client.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for Supabase client.
///
/// Usage:
/// ```dart
/// final supabase = ref.watch(supabaseClientProvider);
///
/// // Auth
/// await supabase.auth.signInWithPassword(...);
///
/// // Database
/// final data = await supabase.from('table').select();
/// ```
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for current user.
///
/// Usage:
/// ```dart
/// final user = ref.watch(currentUserProvider);
/// ```
final currentUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

/// Provider for authentication state.
///
/// Usage:
/// ```dart
/// final session = ref.watch(authStateProvider);
/// ```
final authStateProvider = Provider<Session?>((ref) {
  return Supabase.instance.client.auth.currentSession;
});

/// Provider to check if user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return Supabase.instance.client.auth.currentUser != null;
});
