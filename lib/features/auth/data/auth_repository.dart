// ════════════════════════════════════════════════════════════════════════════
// Auth Repository — PLACEHOLDER IMPLEMENTATION
//
// Semua method di sini menggunakan mock delay untuk mensimulasikan jaringan.
// Ganti setiap blok PLACEHOLDER dengan pemanggilan ApiClient yang sebenarnya
// setelah backend tersedia.
//
// Lihat juga:
//   - lib/core/constants/api_constants.dart  ← endpoint paths
//   - lib/core/network/api_client.dart        ← HTTP client interface
// ════════════════════════════════════════════════════════════════════════════

import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/models/auth_model.dart';

/// Repository that owns all authentication-related data operations.
///
/// Obtain via Riverpod:
/// ```dart
/// final repo = ref.watch(authRepositoryProvider);
/// ```
class AuthRepository {
  final ApiClient _apiClient;

  const AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  // ── Login ──────────────────────────────────────────────────────────────────

  /// Authenticates the user with [creds] and persists the returned token.
  ///
  /// Throws on invalid credentials or network failure.
  Future<void> login(LoginCredentials creds) async {
    // ════════════════════════════════════════════════════════════
    // 🔌 PLACEHOLDER — Ganti dengan implementasi nyata
    // Endpoint : POST /auth/login
    // Headers  : {'Content-Type': 'application/json'}
    // Body     : {"email": "...", "password": "..."}
    // Response : {"access_token": "...", "refresh_token": "...", "user": {...}}
    // TODO: Hapus mock di bawah & panggil ApiClient.post() setelah
    //       backend tersedia. Lihat lib/core/network/api_client.dart
    //
    // Contoh implementasi nyata:
    //   final response = await _apiClient.post(
    //     ApiConstants.login,
    //     {'email': creds.email, 'password': creds.password},
    //     headers: {'Content-Type': 'application/json'},
    //   );
    //   final token = response['access_token'] as String;
    //   await _secureStorage.write(key: 'access_token', value: token);
    // ════════════════════════════════════════════════════════════
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network

    // Referensi ke _apiClient dan ApiConstants supaya analyzer tidak komplain
    // ignore: unused_local_variable
    final _ = _apiClient; // wired up — will be used once backend is ready
    // ignore: unused_local_variable
    const endpoint = ApiConstants.login;

    // Mock validation — remove when real API is connected
    if (creds.email.isEmpty || creds.password.isEmpty) {
      throw Exception('Email dan password tidak boleh kosong.');
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  /// Invalidates the current session on the server and clears local tokens.
  Future<void> logout() async {
    // ════════════════════════════════════════════════════════════
    // 🔌 PLACEHOLDER — Ganti dengan implementasi nyata
    // Endpoint : POST /auth/logout
    // Headers  : {'Authorization': 'Bearer <access_token>',
    //             'Content-Type': 'application/json'}
    // Body     : {} (kosong)
    // Response : {"message": "Logged out successfully"}
    // TODO: Hapus mock di bawah & panggil ApiClient.post() setelah
    //       backend tersedia. Lihat lib/core/network/api_client.dart
    //
    // Contoh implementasi nyata:
    //   final token = await _secureStorage.read(key: 'access_token');
    //   await _apiClient.post(
    //     ApiConstants.logout,
    //     {},
    //     headers: {'Authorization': 'Bearer $token'},
    //   );
    //   await _secureStorage.deleteAll();
    // ════════════════════════════════════════════════════════════
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network

    // ignore: unused_local_variable
    const endpoint = ApiConstants.logout;
  }

  // ── Forgot Password ────────────────────────────────────────────────────────

  /// Triggers a password-reset email to be sent to [email].
  ///
  /// Does not throw if the email is not found in the system (security best
  /// practice — always respond with a generic success message).
  Future<void> forgotPassword(String email) async {
    // ════════════════════════════════════════════════════════════
    // 🔌 PLACEHOLDER — Ganti dengan implementasi nyata
    // Endpoint : POST /auth/forgot-password
    // Headers  : {'Content-Type': 'application/json'}
    // Body     : {"email": "..."}
    // Response : {"message": "If that email exists, a reset link has been sent."}
    // TODO: Hapus mock di bawah & panggil ApiClient.post() setelah
    //       backend tersedia. Lihat lib/core/network/api_client.dart
    //
    // Contoh implementasi nyata:
    //   await _apiClient.post(
    //     ApiConstants.forgotPassword,
    //     {'email': email},
    //     headers: {'Content-Type': 'application/json'},
    //   );
    // ════════════════════════════════════════════════════════════
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network

    // ignore: unused_local_variable
    const endpoint = ApiConstants.forgotPassword;

    if (email.isEmpty) {
      throw Exception('Alamat email tidak boleh kosong.');
    }
  }
}
