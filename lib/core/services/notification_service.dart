// ════════════════════════════════════════════════════════════════════════════
// 📬 NOTIFICATION SERVICE — Placeholder (Firebase not configured yet)
// ════════════════════════════════════════════════════════════════════════════
//
// This is a placeholder service until Firebase is configured.
//
// To enable Firebase notifications:
// 1. Create Firebase project at https://console.firebase.google.com
// 2. Add Android/iOS apps
// 3. Download google-services.json → android/app/
// 4. Download GoogleService-Info.plist → ios/Runner/
// 5. Run: flutterfire configure
// 6. Uncomment Firebase dependencies in pubspec.yaml
// 7. Replace this file with the full implementation
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';

/// Notification Service placeholder for Study Buddy.
///
/// This is a stub implementation until Firebase is configured.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;
  NotificationService._internal();

  bool _initialized = false;

  /// Initialize notification service (placeholder).
  Future<void> initialize() async {
    if (_initialized) return;
    debugPrint(
      '[NotificationService] ⚠️ Placeholder mode - Firebase not configured.\n'
      'See lib/core/services/notification_service.dart for setup instructions.',
    );
    _initialized = true;
  }

  /// Request notification permissions (placeholder).
  Future<bool> requestPermission() async {
    debugPrint(
      '[NotificationService] ⚠️ Permission request - placeholder, returning true',
    );
    return true;
  }

  /// Subscribe to topic (placeholder).
  Future<void> subscribeToTopic(String topic) async {
    debugPrint(
      '[NotificationService] ⚠️ subscribeToTopic("$topic") - placeholder',
    );
  }

  /// Unsubscribe from topic (placeholder).
  Future<void> unsubscribeFromTopic(String topic) async {
    debugPrint(
      '[NotificationService] ⚠️ unsubscribeFromTopic("$topic") - placeholder',
    );
  }

  /// Show local notification (placeholder).
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint(
      '[NotificationService] ⚠️ showLocalNotification()\n'
      '  title: $title\n'
      '  body: $body\n'
      '  payload: $payload',
    );
  }

  bool get isInitialized => _initialized;
}
