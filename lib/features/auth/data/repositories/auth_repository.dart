// ════════════════════════════════════════════════════════════════════════════
// 🔐 AUTH REPOSITORY — Supabase Authentication
// ════════════════════════════════════════════════════════════════════════════
//
// Handles authentication with Supabase:
// - Email/Password login & registration
// - Profile management
// - Session management
// - Password reset
//
// Backend: Supabase Auth (PostgreSQL + Auto-generated APIs)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../../../../core/providers/supabase_provider.dart';

/// Authentication repository for Supabase.
class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  /// Login with email and password.
  ///
  /// Supabase: POST /auth/v1/token
  Future<User> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw const AuthException('Login failed - no user returned');
      }

      // Fetch profile data
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return User.fromJson(profileData);
    } on AuthException catch (e) {
      debugPrint('[AuthRepository] Login error: ${e.message}');
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      debugPrint('[AuthRepository] Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  /// Register a new user.
  ///
  /// Supabase: POST /auth/v1/signup
  /// Auto-creates profile via trigger
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? schoolName,
    String? gradeLevel,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'name': name,
          'school_name': schoolName,
          'grade_level': gradeLevel,
        },
      );

      if (response.user == null) {
        throw const AuthException('Registration failed - no user returned');
      }

      // Wait a moment for trigger to create profile
      await Future.delayed(const Duration(milliseconds: 500));

      // Fetch profile
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return User.fromJson(profileData);
    } on AuthException catch (e) {
      debugPrint('[AuthRepository] Register error: ${e.message}');
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      debugPrint('[AuthRepository] Register error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  /// Logout the current user.
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      debugPrint('[AuthRepository] Logout error: $e');
    }
  }

  /// Get current user profile.
  Future<User> getProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return User.fromJson(profileData);
    } catch (e) {
      debugPrint('[AuthRepository] Get profile error: $e');
      throw Exception('Failed to load profile: $e');
    }
  }

  /// Update user profile.
  Future<User> updateProfile({
    String? name,
    String? schoolName,
    String? gradeLevel,
    String? profileImageUrl,
    String? learningStyle,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final updates = <String, dynamic>{
        if (name != null) 'name': name,
        if (schoolName != null) 'school_name': schoolName,
        if (gradeLevel != null) 'grade_level': gradeLevel,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
        if (learningStyle != null) 'learning_style': learningStyle,
      };

      if (updates.isNotEmpty) {
        await _supabase.from('profiles').update(updates).eq('id', user.id);
      }

      return await getProfile();
    } catch (e) {
      debugPrint('[AuthRepository] Update profile error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Forgot password - send password reset email.
  Future<void> forgotPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: 'https://your-app.com/reset-password',
      );
    } catch (e) {
      debugPrint('[AuthRepository] Forgot password error: $e');
      throw Exception('Failed to send reset email: $e');
    }
  }

  /// Update password.
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      debugPrint('[AuthRepository] Update password error: $e');
      throw Exception('Failed to update password: $e');
    }
  }

  /// Check if user is authenticated.
  Future<bool> isAuthenticated() async {
    return _supabase.auth.currentUser != null;
  }

  /// Get current user ID.
  String? getUserId() {
    return _supabase.auth.currentUser?.id;
  }

  /// Get current user email.
  String? getUserEmail() {
    return _supabase.auth.currentUser?.email;
  }

  /// Listen to auth state changes.
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}

/// Provider for the authentication repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});
