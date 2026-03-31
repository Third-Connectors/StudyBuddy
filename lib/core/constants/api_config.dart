// ════════════════════════════════════════════════════════════════════════════
// 🔑 API CONFIGURATION
// ════════════════════════════════════════════════════════════════════════════
//
// ⚠️ IMPORTANT: Configure your API keys and endpoints below
//
// This file contains all the configuration needed to connect Study Buddy
// to your backend services and third-party APIs.
//
// ════════════════════════════════════════════════════════════════════════════

/// API Configuration for Study Buddy
///
/// Configure your backend endpoints and API keys here.
abstract final class ApiConfig {
  // ── Backend API ────────────────────────────────────────────────────────────

  /// 🔌 TODO: Replace with your actual backend API URL
  ///
  /// Example: 'https://api.studybuddy.id/v1'
  ///          'https://your-domain.com/api'
  static const String baseUrl = 'https://your-api.studybuddy.id/v1';

  /// API Key header name (if required by your backend)
  static const String apiKeyHeader = 'X-API-Key';

  /// 🔌 TODO: Add your API key here if your backend requires one
  ///
  /// Get this from your backend's admin panel or environment variables
  static const String apiKey = ''; // ⚠️ PLACEHOLDER - Add your API key

  // ── Google Gemini API ─────────────────────────────────────────────────────

  /// 🔌 TODO: Add your Google Gemini API key
  ///
  /// Get your API key from: https://makersuite.google.com/app/apikey
  ///
  /// This is used for:
  /// - Socratic Tutor chat
  /// - Schedule OCR processing
  /// - AI-powered content generation
  static const String geminiApiKey = ''; // ⚠️ PLACEHOLDER - Add Gemini API key

  /// Gemini API base URL
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';

  /// Gemini model to use for Socratic Tutor
  /// Options: 'gemini-pro', 'gemini-1.5-pro', 'gemini-1.5-flash'
  static const String geminiModel = 'gemini-1.5-flash';

  /// Gemini model for Vision/OCR tasks
  static const String geminiVisionModel = 'gemini-1.5-flash';

  // ── Firebase Configuration ────────────────────────────────────────────────

  /// 🔌 TODO: Configure Firebase for push notifications
  ///
  /// Firebase Cloud Messaging is used for:
  /// - Quiz reminders
  /// - Leaderboard updates
  /// - Study schedule notifications
  ///
  /// Setup steps:
  /// 1. Create a Firebase project at https://console.firebase.google.com
  /// 2. Add Android/iOS apps to your Firebase project
  /// 3. Download google-services.json (Android) and GoogleService-Info.plist (iOS)
  /// 4. Place them in android/app/ and ios/Runner/ respectively
  /// 5. Run: flutterfire configure
  ///
  /// See: https://firebase.flutter.dev/docs/messaging/overview

  // ── Timeout Configuration ────────────────────────────────────────────────

  /// Connection timeout in milliseconds
  static const int connectionTimeout = 30000; // 30 seconds

  /// Receive timeout in milliseconds
  static const int receiveTimeout = 60000; // 60 seconds (for AI responses)

  /// Send timeout in milliseconds
  static const int sendTimeout = 30000; // 30 seconds

  // ── Retry Configuration ──────────────────────────────────────────────────

  /// Maximum number of retry attempts for failed requests
  static const int maxRetries = 3;

  /// Delay between retries in milliseconds
  static const int retryDelay = 1000; // 1 second

  // ── Feature Flags ────────────────────────────────────────────────────────

  /// Enable/disable AI tutor feature
  static const bool enableTutor = true;

  /// Enable/disable schedule scanner feature
  static const bool enableScheduleScanner = true;

  /// Enable/disable leaderboard feature
  static const bool enableLeaderboard = true;

  /// Enable/disable VAK assessment
  static const bool enableVakAssessment = true;

  // ── Indonesian School Configuration ──────────────────────────────────────

  /// Standard Indonesian school start time (24-hour format)
  static const int schoolStartHour = 7; // 07:00

  /// Standard Indonesian school end time (24-hour format)
  static const int schoolEndHour = 16; // 16:00 (4 PM)

  /// Indonesian school days (Monday = 1, Sunday = 7)
  static const List<int> schoolDays = [1, 2, 3, 4, 5, 6]; // Mon-Sat

  /// Common Indonesian high school subjects
  static const List<Map<String, String>> indonesianSubjects = [
    {'code': 'MTK', 'name': 'Matematika'},
    {'code': 'BIO', 'name': 'Biologi'},
    {'code': 'FIS', 'name': 'Fisika'},
    {'code': 'KIM', 'name': 'Kimia'},
    {'code': 'IND', 'name': 'Bahasa Indonesia'},
    {'code': 'ING', 'name': 'Bahasa Inggris'},
    {'code': 'SEJ', 'name': 'Sejarah'},
    {'code': 'GEO', 'name': 'Geografi'},
    {'code': 'SOS', 'name': 'Sosiologi'},
    {'code': 'EKO', 'name': 'Ekonomi'},
    {'code': 'PKN', 'name': 'Pendidikan Kewarganegaraan'},
    {'code': 'AGM', 'name': 'Agama'},
    {'code': 'ORKES', 'name': 'Olahraga'},
    {'code': 'SEN', 'name': 'Seni Budaya'},
    {'code': 'TIK', 'name': 'Teknologi Informasi'},
  ];
}

/// API Endpoints Registry
///
/// All endpoint paths relative to [ApiConfig.baseUrl]
abstract final class ApiEndpoints {
  // ── Authentication ────────────────────────────────────────────────────────

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';

  // ── User Profile ─────────────────────────────────────────────────────────

  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String userStats = '/user/stats';

  // ── VAK Assessment ───────────────────────────────────────────────────────

  static const String vakQuestions = '/vak/questions';
  static const String vakSubmit = '/vak/submit';
  static const String vakResult = '/vak/result';

  // ── AI Tutor ─────────────────────────────────────────────────────────────

  static const String tutorChat = '/tutor/chat';
  static const String tutorSessions = '/tutor/sessions';
  static const String tutorSessionDetail = '/tutor/sessions/{sessionId}';

  // ── Schedule Scanner ─────────────────────────────────────────────────────

  static const String scannerUpload = '/scanner/upload';
  static const String scannerOcr = '/scanner/ocr';
  static const String schedule = '/schedule';
  static const String scheduleDetail = '/schedule/{scheduleId}';

  // ── Quiz ─────────────────────────────────────────────────────────────────

  static const String quizList = '/quiz';
  static const String quizDetail = '/quiz/{quizId}';
  static const String quizSubmit = '/quiz/{quizId}/submit';
  static const String quizResult = '/quiz/{quizId}/result';

  // ── Leaderboard ──────────────────────────────────────────────────────────

  static const String leaderboard = '/leaderboard';
  static const String leaderboardWeekly = '/leaderboard/weekly';
  static const String leaderboardMonthly = '/leaderboard/monthly';

  // ── Study Materials ──────────────────────────────────────────────────────

  static const String materials = '/materials';
  static const String materialDetail = '/materials/{materialId}';

  // ── Notifications ────────────────────────────────────────────────────────

  static const String notifications = '/notifications';
  static const String notificationSettings = '/user/notification-settings';
}
