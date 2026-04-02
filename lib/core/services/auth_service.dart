// ════════════════════════════════════════════════════════════════════════════
// 🔐 AUTH SERVICE — JWT Authentication with Secure Storage
// ════════════════════════════════════════════════════════════════════════════
//
// Handles:
// - JWT token storage (flutter_secure_storage)
// - Token refresh logic
// - Session management
//
// Blueprint: NestJS API Gateway with JWT authentication
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure authentication service for managing JWT tokens.
///
/// Uses flutter_secure_storage for encrypted token storage:
/// - Android: EncryptedSharedPreferences
/// - iOS: Keychain
class AuthService {
  final FlutterSecureStorage _storage;

  /// Keys for secure storage
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  AuthService() : _storage = const FlutterSecureStorage();

  /// Save authentication tokens after successful login.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    if (userId != null) {
      await _storage.write(key: _userIdKey, value: userId);
    }
  }

  /// Get the access token for API requests.
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get the refresh token for token renewal.
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Get the stored user ID.
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Check if user is authenticated (has valid tokens).
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Clear all tokens (logout).
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }

  /// Delete a specific key (for testing/debugging).
  Future<void> deleteKey(String key) async {
    await _storage.delete(key: key);
  }

  /// Check if token is expired (basic check).
  ///
  /// For production: decode JWT and check 'exp' claim.
  bool isTokenExpired(String token) {
    // TODO: Implement proper JWT decoding and expiration check
    // For now, assume tokens are valid if they exist
    return false;
  }

  /// Decode JWT token to extract payload (user info, expiration).
  ///
  /// TODO: Implement proper JWT decoding using dart_jsonwebtoken
  Map<String, dynamic>? decodeToken(String token) {
    // Placeholder - implement with dart_jsonwebtoken package
    return null;
  }
}

/// Singleton instance for global access.
final authService = AuthService();
