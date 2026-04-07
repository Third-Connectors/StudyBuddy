// ════════════════════════════════════════════════════════════════════════════
// ⚡ SUPABASE SERVICE — Backend-as-a-Service Integration
// ════════════════════════════════════════════════════════════════════════════
//
// This service provides a singleton for Supabase client.
// Use this instead of direct Supabase.instance.client for better testability.
//
// Features:
// - Authentication (Email/Password, OAuth)
// - Database queries (PostgreSQL)
// - Realtime subscriptions
// - Storage (file uploads)
// ════════════════════════════════════════════════════════════════════════════

import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Service singleton.
///
/// Usage:
/// ```dart
/// final supabase = SupabaseService.client;
///
/// // Auth
/// await supabase.auth.signInWithPassword(...);
///
/// // Database
/// final users = await supabase.from('profiles').select();
///
/// // Realtime
/// supabase.from('leaderboard').stream(...);
/// ```
class SupabaseService {
  SupabaseService._();

  /// Get Supabase client instance.
  ///
  /// Make sure Supabase is initialized first:
  /// ```dart
  /// await Supabase.initialize(...);
  /// ```
  static SupabaseClient get client => Supabase.instance.client;

  /// Check if Supabase is initialized.
  static bool get isInitialized =>
      Supabase.instance.client.auth.currentUser != null;

  /// Get current user.
  static User? get currentUser => Supabase.instance.client.auth.currentUser;

  /// Get current session.
  static Session? get currentSession =>
      Supabase.instance.client.auth.currentSession;

  /// Check if user is authenticated.
  static bool get isAuthenticated => currentUser != null;

  /// Get user ID.
  static String? get userId => currentUser?.id;

  /// Get user email.
  static String? get userEmail => currentUser?.email;
}
