import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Reuse userProvider from home feature
import '../../home/data/home_providers.dart';
export '../../home/data/home_providers.dart' show userProvider;

// ════════════════════════════════════════════════════════════
// 🔌 PLACEHOLDER — Ganti dengan API call nyata
// Endpoint : GET /user/profile
// Endpoint : PUT /user/profile
// TODO: Implementasi setelah backend tersedia.
// ════════════════════════════════════════════════════════════

/// Data class representing a single settings menu item.
class SettingsItem {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const SettingsItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBgColor,
    this.onTap,
  });
}

/// Provider for the user's VAK (Visual-Auditory-Kinesthetic) learning style result.
/// Currently returns a mocked value.
/// 🔌 TODO: Replace with result from onboarding quiz / API.
final profileVakResultProvider = Provider<String?>(
  (ref) => '👁️ Visual Learner',
);

/// Tracks whether a logout operation is currently in progress.
final isLoggingOutProvider = StateProvider<bool>((ref) => false);
