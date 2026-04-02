// ════════════════════════════════════════════════════════════════════════════
// 📬 NOTIFICATION SERVICE — Firebase Cloud Messaging
// ════════════════════════════════════════════════════════════════════════════
//
// Handles:
// - Push notifications via Firebase Cloud Messaging
// - Local notifications for reminders
// - Topic subscriptions for targeted notifications
//
// Setup:
// 1. Create Firebase project at https://console.firebase.google.com
// 2. Add Android/iOS apps
// 3. Download google-services.json (Android) → android/app/
// 4. Download GoogleService-Info.plist (iOS) → ios/Runner/
// 5. Run: flutterfire configure
// ════════════════════════════════════════════════════════════════════════════

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Firebase options placeholder.
///
/// After running `flutterfire configure`, import the generated file:
/// ```dart
/// import 'firebase_options.dart';
/// ```
/// Then use:
/// ```dart
/// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
/// ```
class FirebaseOptionsPlaceholder {
  static const bool isConfigured = false;
}

/// Notification Service for Study Buddy.
///
/// Manages push notifications and local alerts for:
/// - Quiz reminders
/// - Leaderboard updates
/// - Study schedule notifications
/// - AI tutor responses
class NotificationService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  bool _initialized = false;

  NotificationService._internal()
    : _messaging = FirebaseMessaging.instance,
      _localNotifications = FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();

  /// Global singleton accessor.
  static NotificationService get instance => _instance;

  /// Initialize Firebase and local notifications.
  ///
  /// Call once in main() after WidgetsFlutterBinding.ensureInitialized().
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize Firebase (if not already initialized)
      if (Firebase.apps.isEmpty) {
        if (FirebaseOptionsPlaceholder.isConfigured) {
          // Uncomment after running flutterfire configure:
          // await Firebase.initializeApp(
          //   options: DefaultFirebaseOptions.currentPlatform,
          // );
          debugPrint('[NotificationService] Firebase initialized');
        } else {
          debugPrint(
            '[NotificationService] ⚠️ Firebase not configured. '
            'Run: flutterfire configure',
          );
          _initialized = true;
          return;
        }
      }

      // Request notification permissions
      await requestPermission();

      // Initialize local notifications
      await _initLocalNotifications();

      // Set up message handlers
      _setupMessageHandlers();

      // Get FCM token for backend registration
      final token = await _messaging.getToken();
      debugPrint('[NotificationService] FCM Token: $token');

      _initialized = true;
    } catch (e) {
      debugPrint('[NotificationService] Initialization error: $e');
    }
  }

  /// Request notification permissions (required for iOS, recommended for Android 13+).
  Future<bool> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      final authorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      debugPrint('[NotificationService] Permission granted: $authorized');
      return authorized;
    } catch (e) {
      debugPrint('[NotificationService] Permission request error: $e');
      return false;
    }
  }

  /// Subscribe to a topic for targeted notifications.
  ///
  /// Topics: 'all_users', 'quiz_reminders', 'leaderboard_updates', 'study_tips'
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('[NotificationService] Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('[NotificationService] Subscribe error: $e');
    }
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('[NotificationService] Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('[NotificationService] Unsubscribe error: $e');
    }
  }

  /// Get FCM token for backend registration.
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('[NotificationService] Get token error: $e');
      return null;
    }
  }

  /// Show a local notification (for reminders, alerts).
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
    String? channelId,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'studybuddy_channel',
        'Study Buddy Alerts',
        channelDescription: 'Notifications for quiz, schedule, and updates',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_notification',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
        payload: payload,
      );

      debugPrint('[NotificationService] Local notification shown: $title');
    } catch (e) {
      debugPrint('[NotificationService] Show notification error: $e');
    }
  }

  /// Schedule a notification for a specific time (for study reminders).
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    int? id,
    String? channelId,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'studybuddy_reminders',
        'Study Reminders',
        channelDescription: 'Scheduled study session reminders',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.zonedSchedule(
        id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      debugPrint(
        '[NotificationService] Notification scheduled for: $scheduledDate',
      );
    } catch (e) {
      debugPrint('[NotificationService] Schedule notification error: $e');
    }
  }

  /// Cancel a specific notification by ID.
  Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
      debugPrint('[NotificationService] Notification cancelled: $id');
    } catch (e) {
      debugPrint('[NotificationService] Cancel notification error: $e');
    }
  }

  /// Cancel all pending notifications.
  Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      debugPrint('[NotificationService] All notifications cancelled');
    } catch (e) {
      debugPrint('[NotificationService] Cancel all error: $e');
    }
  }

  /// Initialize local notification settings.
  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    await _createNotificationChannels();
  }

  /// Create Android notification channels.
  Future<void> _createNotificationChannels() async {
    const quizChannel = AndroidNotificationChannel(
      'studybuddy_channel',
      'Study Buddy Alerts',
      description: 'Notifications for quiz, schedule, and updates',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    const reminderChannel = AndroidNotificationChannel(
      'studybuddy_reminders',
      'Study Reminders',
      description: 'Scheduled study session reminders',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    final channelGroup = AndroidNotificationChannelGroup(
      'studybuddy_group',
      'Study Buddy',
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannelGroup(channelGroup);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(quizChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(reminderChannel);
  }

  /// Handle notification tap when app is in foreground.
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint(
      '[NotificationService] Notification tapped: ${response.payload}',
    );
    // TODO: Implement navigation based on payload
    // Example: Navigate to quiz screen, schedule screen, etc.
  }

  /// Set up Firebase Messaging handlers.
  void _setupMessageHandlers() {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Handle when user taps on notification while app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check if app was opened from a notification (cold start)
    _checkInitialMessage();
  }

  /// Handle foreground messages.
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint('[NotificationService] Foreground message: ${message.data}');

    if (message.notification != null) {
      await showLocalNotification(
        title: message.notification!.title ?? 'Study Buddy',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Handle message opened from background.
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('[NotificationService] Message opened app: ${message.data}');
    // TODO: Implement navigation based on message data
  }

  /// Check if app was started from a notification.
  Future<void> _checkInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      debugPrint('[NotificationService] Initial message: ${message.data}');
      // TODO: Implement navigation based on initial message
    }
  }

  /// Check if initialized (for debugging).
  bool get isInitialized => _initialized;
}

/// Background message handler (must be top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[NotificationService] Background message: ${message.data}');
  // Note: Can't use instance methods here, need separate Firebase init
}
