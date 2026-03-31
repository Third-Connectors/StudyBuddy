// ════════════════════════════════════════════════════════════
// Auth Domain Models
// Contains: LoginCredentials, AuthStatus, AuthState
// ════════════════════════════════════════════════════════════

/// Holds the credentials submitted by the user on the login screen.
class LoginCredentials {
  final String email;
  final String password;

  const LoginCredentials({required this.email, required this.password});

  @override
  String toString() => 'LoginCredentials(email: $email)';
}

// ─────────────────────────────────────────────────────────────
// AuthStatus enum
// ─────────────────────────────────────────────────────────────

/// Represents every possible state the authentication flow can be in.
enum AuthStatus {
  /// App just launched — no action taken yet.
  initial,

  /// An async auth operation (login / logout / refresh) is in progress.
  loading,

  /// User has successfully authenticated and holds a valid token.
  authenticated,

  /// User is explicitly logged out or no token exists.
  unauthenticated,

  /// An error occurred during the last auth operation.
  error,
}

// ─────────────────────────────────────────────────────────────
// AuthState
// ─────────────────────────────────────────────────────────────

/// Immutable state object managed by [AuthNotifier].
///
/// Use [copyWith] to produce a new instance with modified fields.
class AuthState {
  final AuthStatus status;

  /// Non-null only when [status] == [AuthStatus.error].
  final String? errorMessage;

  const AuthState({this.status = AuthStatus.initial, this.errorMessage});

  // ── Convenience getters ───────────────────────────────────────────────────

  /// `true` while an async auth operation is running.
  bool get isLoading => status == AuthStatus.loading;

  /// `true` when the user holds a valid session.
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// `true` when the user has no active session.
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// `true` when the last auth operation failed.
  bool get hasError => status == AuthStatus.error;

  // ── copyWith ──────────────────────────────────────────────────────────────

  /// Returns a new [AuthState] with the given fields replaced.
  ///
  /// Pass `clearError: true` to explicitly set [errorMessage] to `null`
  /// (useful when transitioning away from the error state).
  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  // ── Equality & debug ──────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => status.hashCode ^ errorMessage.hashCode;

  @override
  String toString() =>
      'AuthState(status: $status, errorMessage: $errorMessage)';
}
