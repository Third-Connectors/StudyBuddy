// ════════════════════════════════════════════════════════════
// 🔌 PLACEHOLDER — API Constants
// Ganti baseUrl dengan URL backend yang sebenarnya setelah
// backend tersedia.
// ════════════════════════════════════════════════════════════

/// Centralized registry of every API endpoint used by Study Buddy.
///
/// All paths are relative to [baseUrl] and should be passed directly
/// to [ApiClient] methods, e.g.:
/// ```dart
/// apiClient.post(ApiConstants.login, body);
/// ```
abstract final class ApiConstants {
  // ── Base ──────────────────────────────────────────────────────────────────

  /// 🔌 PLACEHOLDER — Ganti dengan URL backend kamu
  static const String baseUrl = 'https://your-api.studybuddy.id/v1';

  // ── Auth ──────────────────────────────────────────────────────────────────

  /// POST /auth/login — Authenticate user with email & password.
  static const String login = '/auth/login';

  /// POST /auth/register — Create a new user account.
  static const String register = '/auth/register';

  /// POST /auth/logout — Invalidate the current session / token.
  static const String logout = '/auth/logout';

  /// POST /auth/forgot-password — Trigger password-reset email.
  static const String forgotPassword = '/auth/forgot-password';

  /// POST /auth/refresh — Exchange a refresh token for a new access token.
  static const String refreshToken = '/auth/refresh';

  // ── User ──────────────────────────────────────────────────────────────────

  /// GET /user/profile — Fetch the authenticated user's profile.
  static const String profile = '/user/profile';

  /// PUT /user/profile — Update the authenticated user's profile.
  static const String updateProfile = '/user/profile';

  // ── VAK (Learning-Style Assessment) ───────────────────────────────────────

  /// POST /vak/submit — Submit VAK quiz answers and receive a style result.
  static const String vakSubmit = '/vak/submit';

  // ── AI Tutor ──────────────────────────────────────────────────────────────

  /// POST /tutor/chat — Send a message to the AI tutor and receive a reply.
  static const String tutorChat = '/tutor/chat';

  // ── Scanner ───────────────────────────────────────────────────────────────

  /// POST /scanner/upload — Upload an image for OCR / content extraction.
  static const String scannerUpload = '/scanner/upload';

  // ── Quiz ──────────────────────────────────────────────────────────────────

  /// GET /quiz — Retrieve the list of available quizzes.
  static const String quizList = '/quiz';

  /// POST /quiz/submit — Submit user answers for a completed quiz.
  static const String submitAnswer = '/quiz/submit';

  // ── Leaderboard ───────────────────────────────────────────────────────────

  /// GET /leaderboard — Fetch the current XP-ranked leaderboard.
  static const String leaderboard = '/leaderboard';

  // ── Schedule ──────────────────────────────────────────────────────────────

  /// GET/POST /schedule — Retrieve or create study schedule entries.
  static const String schedule = '/schedule';
}
