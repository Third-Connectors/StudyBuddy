import 'package:flutter/material.dart';

/// Centralized color palette for Study Buddy.
/// All colors are derived from the provided design reference (4-screen mockup).
abstract final class AppColors {
  // ── Primary Palette ──────────────────────────────────────────────────────
  /// Vibrant orange — primary CTA, card backgrounds, active states, badges.
  static const Color primaryOrange = Color(0xFFFF6B2B);

  /// Soft peach — used for bordered field containers and hover backgrounds.
  static const Color primaryOrangeLight = Color(0xFFFFDDCC);

  /// Very light cream-orange — field fill backgrounds, subtle tints.
  static const Color primaryOrangeLighter = Color(0xFFFFF5F0);

  // ── Secondary Palette ────────────────────────────────────────────────────
  /// Deep forest green — primary action buttons ("Let's Start!", "Next").
  static const Color darkGreen = Color(0xFF1A3D2B);

  // ── Background ───────────────────────────────────────────────────────────
  /// Warm cream — the main scaffold background across all app screens.
  static const Color backgroundCream = Color(0xFFFFF6E5);

  /// Pure white — card surfaces, modal sheets, form containers.
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  /// Light periwinkle blue — top-half background of Onboarding Screen 1.
  static const Color onboardingTopBlue = Color(0xFF89B0F3);

  // ── Text ─────────────────────────────────────────────────────────────────
  /// Near-black — primary headings, body copy, and important labels.
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Medium grey — secondary descriptions, subtitles, captions.
  static const Color textSecondary = Color(0xFF6B7280);

  /// Light grey — placeholder text, disabled states, tertiary hints.
  static const Color textLight = Color(0xFFADB5BD);

  /// Pure white — text placed on dark or colored backgrounds.
  static const Color textWhite = Color(0xFFFFFFFF);

  // ── Quiz Status Badges ────────────────────────────────────────────────────
  /// "Done" badge text — green.
  static const Color statusDoneText = Color(0xFF16A34A);

  /// "Done" badge background — light green tint.
  static const Color statusDoneBg = Color(0xFFDCFCE7);

  /// "In Progress" badge text — deep orange.
  static const Color statusInProgressText = Color(0xFFEA580C);

  /// "In Progress" badge background — warm orange tint.
  static const Color statusInProgressBg = Color(0xFFFFF7ED);

  /// "To do" badge / text — neutral grey.
  static const Color statusToDoText = Color(0xFF9CA3AF);

  // ── Progress Bar ─────────────────────────────────────────────────────────
  /// The track (background) of all progress bars.
  static const Color progressTrack = Color(0xFFE5E7EB);

  // ── Bottom Navigation Bar ─────────────────────────────────────────────────
  /// Floating pill background — very dark navy.
  static const Color bottomNavBg = Color(0xFF1A1A2E);

  /// Active nav icon color.
  static const Color bottomNavActiveIcon = Color(0xFFFF6B2B);

  /// Inactive nav icon color.
  static const Color bottomNavInactiveIcon = Color(0xFF6B7280);

  // ── Subject Icon Colors ───────────────────────────────────────────────────
  static const Color subjectBlue = Color(0xFF3B82F6); // B. Inggris
  static const Color subjectOrange = Color(0xFFFF6B2B); // Fisika
  static const Color subjectGreen = Color(0xFF10B981); // Ekonomi
  static const Color subjectPurple = Color(0xFF8B5CF6); // Biologi
  static const Color subjectPink = Color(0xFFEC4899); // Kimia
  static const Color subjectAmber = Color(0xFFF59E0B); // Matematika
  static const Color subjectIndigo = Color(0xFF6366F1); // Sejarah
  static const Color subjectTeal = Color(0xFF14B8A6); // B. Indonesia

  // ── AI Suggestion Card ────────────────────────────────────────────────────
  /// Warm amber-cream background for the Saran AI card.
  static const Color aiSuggestionBg = Color(0xFFFFF8EC);

  /// Amber border for the Saran AI card.
  static const Color aiSuggestionBorder = Color(0xFFFFDEA0);

  /// Sparkle icon color inside the Saran AI card.
  static const Color aiSuggestionIcon = Color(0xFFF59E0B);

  // ── Stat Card Icon Backgrounds ────────────────────────────────────────────
  static const Color statXpBg = Color(0xFFFFF8EC); // Amber tint
  static const Color statRankBg = Color(0xFFD1FAE5); // Green tint
  static const Color statPresenceBg = Color(0xFFEFF6FF); // Blue tint

  static const Color statXpIcon = Color(0xFFF59E0B);
  static const Color statRankIcon = Color(0xFF10B981); // Green
  static const Color statPresenceIcon = Color(0xFF3B82F6); // Blue

  // ── Utility ───────────────────────────────────────────────────────────────
  /// Standard 1 px divider line.
  static const Color divider = Color(0xFFE5E7EB);

  /// Very subtle shadow tint for cards (4 % black).
  static const Color cardShadow = Color(0x0A000000);
}
