// ════════════════════════════════════════════════════════════════════════════
// 🔑 API CONFIGURATION — Study Buddy Blueprint Implementation
// ════════════════════════════════════════════════════════════════════════════
//
// Architecture: NestJS (API Gateway) + FastAPI (ML Service)
// Databases: PostgreSQL (User Data) + MongoDB (Content) + Redis (Cache)
// LLM Provider: Google Gemini
//
// ════════════════════════════════════════════════════════════════════════════

/// API Configuration for Study Buddy
///
/// Blueprint-compliant configuration for:
/// - NestJS API Gateway
/// - Python FastAPI ML Service
/// - Google Gemini LLM
/// - PostgreSQL, MongoDB, Redis
abstract final class ApiConfig {
  // ── Backend API Gateway (NestJS) ──────────────────────────────────────────

  /// 🌐 NestJS API Gateway Base URL
  ///
  /// Development: Use local IP or localhost
  /// Production: Deploy to cloud (GCP, AWS, Azure, Railway, Render)
  static const String baseUrl = 'http://192.168.1.100:3000/api/v1';

  /// API Key header name for backend authentication
  static const String apiKeyHeader = 'X-API-Key';

  /// Backend API Key (optional, for rate limiting & analytics)
  /// Leave empty if not using API key authentication
  static const String apiKey = '';

  // ── ML Service (Python FastAPI) ───────────────────────────────────────────

  /// 🤖 ML Service Base URL (FastAPI)
  ///
  /// This service handles:
  /// - VAK Classification (KNN Model)
  /// - Schedule Optimization (Genetic Algorithm)
  /// - AI Tutor prompt processing
  static const String mlServiceUrl = 'http://192.168.1.100:8000/api/v1';

  // ── Google Gemini API ─────────────────────────────────────────────────────

  /// 🔑 Google Gemini API Key
  ///
  /// Get your API key from: https://makersuite.google.com/app/apikey
  ///
  /// ⚠️ SECURITY: In production, route through backend to hide this key
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  /// Gemini API base URL
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/';

  /// Gemini model for Socratic Tutor (text-based)
  /// Recommended: gemini-1.5-flash for speed & cost efficiency
  static const String geminiModel = 'gemini-2.5-flash';

  /// Gemini model for Vision/OCR tasks (schedule scanner, image analysis)
  static const String geminiVisionModel = 'gemini-2.5-flash';

  /// Socratic Tutor System Prompt (Kurikulum Merdeka/K13 context)
  static const String socraticPrompt =
      '''You are a Socratic Tutor for Indonesian high school students (SMA/MA/SMK).

RULES:
1. NEVER give the answer directly
2. Ask leading questions to guide students
3. Use Indonesian language (Bahasa Indonesia)
4. Context: Kurikulum Merdeka & K13 curriculum
5. Be encouraging and friendly
6. If student is stuck, break down the problem into smaller steps
7. Relate concepts to real-life examples when possible

SUBJECTS: Matematika, Fisika, Kimia, Biologi, Bahasa Indonesia,
          Bahasa Inggris, Sejarah, Geografi, Sosiologi, Ekonomi,
          PKN, Agama, Olahraga, Seni Budaya, TIK''';

  // ── MongoDB Atlas Data API ─────────────────────────────────────────────────

  /// 🍃 MongoDB Atlas Data API Base URL
  ///
  /// Setup:
  /// 1. Go to https://cloud.mongodb.com → Your Project → App Services
  /// 2. Create a new App → Data API tab → Enable Data API
  /// 3. Copy the App ID (format: data-abcde)
  /// 4. Replace 'YOUR_APP_ID' below with your App ID
  static const String mongoAtlasBaseUrl =
      'https://data.mongodb-api.com/app/YOUR_APP_ID/endpoint/data/v1';

  /// 🔑 MongoDB Atlas Data API Key
  ///
  /// 1. In App Services → API Keys → Create API Key
  /// 2. Replace with your key
  static const String mongoAtlasApiKey = 'YOUR_ATLAS_API_KEY';

  /// Atlas cluster name (usually 'Cluster0')
  static const String mongoAtlasDataSource = 'Cluster0';

  /// Atlas database name
  static const String mongoAtlasDatabase = 'studybuddy';

  /// Collections
  static const String colQuestions = 'questions';
  static const String colQuizResults = 'quiz_results';
  static const String colTutorSessions = 'tutor_sessions';

  // ── Midtrans Payment Gateway ──────────────────────────────────────────────

  /// 💳 Midtrans Client Key (Untuk integrasi Mobile SDK / snap frontend)
  static const String midtransClientKey = String.fromEnvironment('MIDTRANS_CLIENT_KEY', defaultValue: '');

  /// 🔑 Midtrans Server Key (Untuk otorisasi transaksi sisi backend)
  static const String midtransServerKey = String.fromEnvironment('MIDTRANS_SERVER_KEY', defaultValue: '');

  /// 🆔 Midtrans Merchant ID
  static const String midtransMerchantId = 'M068686375';

  /// 🌐 Menggunakan Sandbox Environment (Set false jika sudah Production)
  static const bool isMidtransSandbox = true;

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
