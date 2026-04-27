// ════════════════════════════════════════════════════════════════════════════
// 🔐 AUTH REPOSITORY — Supabase Authentication
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/user_model.dart' as app_models;
import '../../../../core/providers/supabase_provider.dart';

/// Authentication repository for Supabase.
class AuthRepository {
  final supabase.SupabaseClient _supabase;

  AuthRepository(this._supabase);

  /// Login with email and password.
  Future<app_models.UserModel> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed - no user returned');
      }

      // Fetch profile data
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return app_models.UserModel.fromJson(profileData);
    } catch (e) {
      debugPrint('[AuthRepository] Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  /// Register a new user.
  Future<app_models.UserModel> register({
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
        },
      );

      if (response.user == null) {
        throw Exception('Registration failed - no user returned');
      }

      // 2. Update profile table directly with additional data
      // This ensures data is saved even if the trigger doesn't handle metadata
      await _supabase.from('profiles').update({
        'school_name': schoolName,
        'grade_level': gradeLevel,
      }).eq('id', response.user!.id);

      // Fetch the final profile
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return app_models.UserModel.fromJson(profileData);
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
  Future<app_models.UserModel> getProfile() async {
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

      return app_models.UserModel.fromJson(profileData);
    } catch (e) {
      debugPrint('[AuthRepository] Get profile error: $e');
      throw Exception('Failed to load profile: $e');
    }
  }

  /// Update user profile.
  Future<app_models.UserModel> updateProfile({
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
      await _supabase.auth.updateUser(
        supabase.UserAttributes(password: newPassword),
      );
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
  Stream<supabase.AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;
}

/// Provider for the authentication repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});
