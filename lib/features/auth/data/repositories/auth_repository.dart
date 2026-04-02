// ════════════════════════════════════════════════════════════════════════════
// 🔐 AUTH REPOSITORY — NestJS API Gateway Integration
// ════════════════════════════════════════════════════════════════════════════
//
// Handles authentication with NestJS backend:
// - Login/Register with JWT tokens
// - Profile management
// - Token refresh
// - Password reset
//
// Backend: NestJS API Gateway with PostgreSQL
// Security: JWT tokens, bcrypt password hashing
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/services/auth_service.dart';

/// Authentication repository for handling user auth operations.
///
/// Communicates with NestJS API Gateway for:
/// - User registration and login
/// - Profile management
/// - Token refresh and logout
class AuthRepository {
  final ApiClient _apiClient;
  final AuthService _authService;

  AuthRepository(this._apiClient, AuthService? authService)
    : _authService = authService ?? AuthService();

  /// Login with email and password.
  ///
  /// Returns [User] object and saves JWT tokens to secure storage.
  ///
  /// Backend: POST /auth/login
  /// Response: { user: {...}, accessToken: "...", refreshToken: "..." }
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      // Extract tokens and user data
      final accessToken = response['accessToken'] as String?;
      final refreshToken = response['refreshToken'] as String?;
      final userData = response['user'] as Map<String, dynamic>?;

      if (accessToken == null || userData == null) {
        throw ApiException(
          message: 'Invalid response from server',
          details: 'Missing accessToken or user data',
        );
      }

      // Save tokens to secure storage
      await _authService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        userId: userData['id'] as String?,
      );

      // Update API client with new token
      _apiClient.setAuthToken(accessToken);

      return User.fromJson(userData);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] Login error: $e');
      throw ApiException(
        message: 'Login failed. Please check your credentials.',
        details: e.toString(),
      );
    }
  }

  /// Register a new user.
  ///
  /// Backend: POST /auth/register
  /// Response: { user: {...}, accessToken: "...", refreshToken: "..." }
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? schoolName,
    String? gradeLevel,
  }) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.register, {
        'name': name,
        'email': email,
        'password': password,
        'schoolName': schoolName,
        'gradeLevel': gradeLevel,
      });

      final accessToken = response['accessToken'] as String?;
      final refreshToken = response['refreshToken'] as String?;
      final userData = response['user'] as Map<String, dynamic>?;

      if (accessToken == null || userData == null) {
        throw ApiException(
          message: 'Invalid response from server',
          details: 'Missing accessToken or user data',
        );
      }

      await _authService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        userId: userData['id'] as String?,
      );

      _apiClient.setAuthToken(accessToken);

      return User.fromJson(userData);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] Register error: $e');
      throw ApiException(
        message: 'Registration failed. Please try again.',
        details: e.toString(),
      );
    }
  }

  /// Logout the current user.
  ///
  /// Backend: POST /auth/logout
  /// Clears tokens from secure storage.
  Future<void> logout() async {
    try {
      // Call backend to invalidate token
      await _apiClient.post(ApiEndpoints.logout, null);
    } catch (e) {
      debugPrint('[AuthRepository] Logout backend error: $e');
      // Continue with local logout even if backend fails
    } finally {
      // Always clear local tokens
      await _authService.clearTokens();
      _apiClient.clearAuthToken();
    }
  }

  /// Get current user profile.
  ///
  /// Backend: GET /user/profile
  /// Requires valid JWT token.
  Future<User> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      final userData = response['user'] as Map<String, dynamic>?;

      if (userData == null) {
        throw ApiException(
          message: 'Profile not found',
          details: 'User data is null',
        );
      }

      return User.fromJson(userData);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] Get profile error: $e');
      throw ApiException(
        message: 'Failed to load profile',
        details: e.toString(),
      );
    }
  }

  /// Update user profile.
  ///
  /// Backend: PUT /user/profile
  Future<User> updateProfile({
    String? name,
    String? schoolName,
    String? gradeLevel,
    String? profileImageUrl,
  }) async {
    try {
      final response = await _apiClient.put(ApiEndpoints.updateProfile, {
        if (name != null) 'name': name,
        if (schoolName != null) 'schoolName': schoolName,
        if (gradeLevel != null) 'gradeLevel': gradeLevel,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      });

      final userData = response['user'] as Map<String, dynamic>?;

      if (userData == null) {
        throw ApiException(
          message: 'Invalid response from server',
          details: 'User data is null after update',
        );
      }

      return User.fromJson(userData);
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] Update profile error: $e');
      throw ApiException(
        message: 'Failed to update profile',
        details: e.toString(),
      );
    }
  }

  /// Forgot password - trigger password reset email.
  ///
  /// Backend: POST /auth/forgot-password
  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.post(ApiEndpoints.forgotPassword, {'email': email});
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] Forgot password error: $e');
      throw ApiException(
        message: 'Failed to send password reset email',
        details: e.toString(),
      );
    }
  }

  /// Refresh the access token using refresh token.
  ///
  /// Called automatically by ApiClient interceptor when 401 is received.
  ///
  /// Backend: POST /auth/refresh
  Future<String> refreshToken() async {
    try {
      final refreshToken = await _authService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw ApiException(
          message: 'No refresh token available',
          details: 'User needs to log in again',
        );
      }

      final response = await _apiClient.post(ApiEndpoints.refreshToken, {
        'refreshToken': refreshToken,
      });

      final newAccessToken = response['accessToken'] as String?;
      final newRefreshToken = response['refreshToken'] as String?;

      if (newAccessToken == null) {
        throw ApiException(
          message: 'Invalid refresh response',
          details: 'Missing accessToken',
        );
      }

      // Save new tokens
      await _authService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? refreshToken,
      );

      _apiClient.setAuthToken(newAccessToken);

      return newAccessToken;
    } on ApiException {
      // Clear tokens on refresh failure (session expired)
      await _authService.clearTokens();
      _apiClient.clearAuthToken();
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] Refresh token error: $e');
      throw ApiException(
        message: 'Session expired. Please log in again.',
        details: e.toString(),
      );
    }
  }

  /// Check if user is currently authenticated.
  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }

  /// Get stored user ID.
  Future<String?> getUserId() async {
    return await _authService.getUserId();
  }

  /// Get current access token (for API calls).
  Future<String?> getAccessToken() async {
    return await _authService.getAccessToken();
  }
}

/// Provider for the authentication repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider), authService);
});
