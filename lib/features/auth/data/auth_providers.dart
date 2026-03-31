import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/models/auth_model.dart';
import 'auth_repository.dart';

// ════════════════════════════════════════════════════════════
// ApiClient Provider
// ════════════════════════════════════════════════════════════

/// Provides a single [ApiClient] instance shared across all repositories.
///
/// The [ApiClient] is constructed with [ApiConstants.baseUrl].
/// 🔌 PLACEHOLDER — Replace [ApiConstants.baseUrl] with the real backend URL
/// before going to production. See lib/core/constants/api_constants.dart.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConstants.baseUrl);
});

// ════════════════════════════════════════════════════════════
// AuthRepository Provider
// ════════════════════════════════════════════════════════════

/// Provides a single [AuthRepository] wired up to the shared [ApiClient].
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(apiClient: ref.watch(apiClientProvider));
});

// ════════════════════════════════════════════════════════════
// AuthNotifier
// ════════════════════════════════════════════════════════════

/// Business-logic layer for authentication.
///
/// Owns the mutable [AuthState] and exposes [login] / [logout] actions
/// that delegate to [AuthRepository].
///
/// Consumers:
/// ```dart
/// // Read state
/// final authState = ref.watch(authProvider);
///
/// // Trigger login
/// ref.read(authProvider.notifier).login(email, password);
/// ```
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const AuthState());

  final AuthRepository _repo;

  // ── Actions ───────────────────────────────────────────────────────────────

  /// Attempts to sign in with [email] and [password].
  ///
  /// Transitions:
  ///   initial / unauthenticated / error  →  loading  →  authenticated | error
  Future<void> login(String email, String password) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _repo.login(LoginCredentials(email: email, password: password));
      state = const AuthState(status: AuthStatus.authenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  /// Signs the current user out and clears all session data.
  ///
  /// Transitions:
  ///   authenticated  →  unauthenticated
  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Triggers a password-reset e-mail for [email].
  ///
  /// Does NOT change the auth status — callers should handle UI feedback
  /// by catching errors via `ref.listen`.
  Future<void> forgotPassword(String email) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _repo.forgotPassword(email);
      // Return to unauthenticated (still not logged in) after successful request.
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  /// Resets the state back to [AuthStatus.initial].
  ///
  /// Useful for clearing a stale error before re-attempting an action.
  void reset() {
    state = const AuthState();
  }
}

// ════════════════════════════════════════════════════════════
// authProvider — main entry-point for UI consumers
// ════════════════════════════════════════════════════════════

/// The primary Riverpod provider that exposes [AuthState] to the widget tree.
///
/// Use [authProvider.notifier] to access [AuthNotifier] actions:
/// ```dart
/// ref.read(authProvider.notifier).login(email, password);
/// ```
///
/// Use [ref.watch] / [ref.listen] to react to state changes:
/// ```dart
/// ref.listen<AuthState>(authProvider, (prev, next) {
///   if (next.status == AuthStatus.authenticated) {
///     Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
///   }
/// });
/// ```
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
