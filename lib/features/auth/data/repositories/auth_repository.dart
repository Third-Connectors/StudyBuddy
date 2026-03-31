import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';

/// Authentication repository for handling user auth operations.
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// Login with email and password.
  ///
  /// ⚠️ TODO: Implement actual API call
  /// Replace the placeholder with:
  /// ```dart
  /// final response = await _apiClient.post(
  ///   ApiEndpoints.login,
  ///   {'email': email, 'password': password},
  /// );
  /// return User.fromJson(response['user']);
  /// ```
  Future<User> login(String email, String password) async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Mock user for testing
    return User(
      id: 'user_123',
      email: email,
      name: 'Test User',
      role: UserRole.student,
      schoolName: 'SMA Negeri 1 Example',
      gradeLevel: '11',
      createdAt: DateTime.now(),
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      ApiEndpoints.login,
      {'email': email, 'password': password},
    );
    return User.fromJson(response['user']);
    */
  }

  /// Register a new user.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? schoolName,
    String? gradeLevel,
  }) async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    return User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      role: UserRole.student,
      schoolName: schoolName,
      gradeLevel: gradeLevel,
      createdAt: DateTime.now(),
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      ApiEndpoints.register,
      {
        'name': name,
        'email': email,
        'password': password,
        'schoolName': schoolName,
        'gradeLevel': gradeLevel,
      },
    );
    return User.fromJson(response['user']);
    */
  }

  /// Logout the current user.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<void> logout() async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Uncomment when backend is ready
    /*
    await _apiClient.post(ApiEndpoints.logout, null);
    */
  }

  /// Get current user profile.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<User> getProfile() async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock user
    return User(
      id: 'user_123',
      email: 'user@studybuddy.id',
      name: 'Current User',
      role: UserRole.student,
      schoolName: 'SMA Negeri 1 Example',
      gradeLevel: '11',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(ApiEndpoints.profile);
    return User.fromJson(response['user']);
    */
  }

  /// Update user profile.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<User> updateProfile({
    String? name,
    String? schoolName,
    String? gradeLevel,
    String? profileImageUrl,
  }) async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock updated user
    return User(
      id: 'user_123',
      email: 'user@studybuddy.id',
      name: name ?? 'Current User',
      role: UserRole.student,
      schoolName: schoolName ?? 'SMA Negeri 1 Example',
      gradeLevel: gradeLevel ?? '11',
      profileImageUrl: profileImageUrl,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.put(
      ApiEndpoints.updateProfile,
      {
        'name': name,
        'schoolName': schoolName,
        'gradeLevel': gradeLevel,
        'profileImageUrl': profileImageUrl,
      },
    );
    return User.fromJson(response['user']);
    */
  }

  /// Forgot password - trigger password reset email.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<void> forgotPassword(String email) async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Uncomment when backend is ready
    /*
    await _apiClient.post(
      ApiEndpoints.forgotPassword,
      {'email': email},
    );
    */
  }
}

/// Provider for the authentication repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});
