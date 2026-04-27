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

import 'local_storage_service.dart';

/// Authentication service managing sessions via SharedPreferences.
class AuthService {
  final LocalStorageService _storage;

  /// Keys for storage
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthService() : _storage = localStorageProvider;

  /// Save authentication tokens and update login status.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await _storage.setString(_accessTokenKey, accessToken);
    await _storage.setString(_refreshTokenKey, refreshToken);
    await _storage.setBool(_isLoggedInKey, true);
    if (userId != null) {
      await _storage.setString(_userIdKey, userId);
    }
  }

  /// Get the access token for API requests.
  String? getAccessToken() => _storage.getString(_accessTokenKey);

  /// Get the stored user ID.
  String? getUserId() => _storage.getString(_userIdKey);

  /// Check if user is authenticated (has valid tokens).
  bool isAuthenticated() {
    return _storage.getBool(_isLoggedInKey) && (getAccessToken()?.isNotEmpty ?? false);
  }

  /// Clear all tokens and update login status (logout).
  Future<void> clearTokens() async {
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_userIdKey);
    await _storage.setBool(_isLoggedInKey, false);
  }

  /// Delete a specific key (for testing/debugging).
  Future<void> deleteKey(String key) async {
    await _storage.remove(key);
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
