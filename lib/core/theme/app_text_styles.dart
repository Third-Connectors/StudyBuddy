import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized text style definitions for Study Buddy.
///
/// Uses **Google Fonts "Nunito"** — chosen for its friendly rounded letterforms
/// and excellent legibility at small sizes, ideal for an EdTech app targeting
/// high-school students.
///
/// Usage example:
/// ```dart
/// Text('Hello', style: AppTextStyles.headlineLarge)
/// ```
abstract final class AppTextStyles {
  // ── Display / Hero ────────────────────────────────────────────────────────

  /// Largest text used for the Onboarding 1 hero message.
  /// "UPGRADE YOUR SKILLS STARTING NOW" — all-caps, extra-bold, white.
  static TextStyle get displayHero => GoogleFonts.nunito(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.textWhite,
    height: 1.12,
    letterSpacing: 2.0,
  );

  // ── Headlines ─────────────────────────────────────────────────────────────

  /// Large headline — screen titles such as "Study", user name on Home.
  static TextStyle get headlineLarge => GoogleFonts.nunito(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Medium headline — card headings such as "Data Diri & Kelas".
  static TextStyle get headlineMedium => GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  // ── Titles ────────────────────────────────────────────────────────────────

  /// Large title — section headers like "Latest Quiz", "Progres Keseluruhan".
  static TextStyle get titleLarge => GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Medium title — card sub-headings, stat values.
  static TextStyle get titleMedium => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Small title — field labels, badge text, tab labels.
  static TextStyle get titleSmall => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Body ──────────────────────────────────────────────────────────────────

  /// Body large — primary readable content, form field input text.
  static TextStyle get bodyLarge => GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Body medium — standard paragraph and list item text.
  static TextStyle get bodyMedium => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  /// Body small — supporting descriptions, subtitles, secondary info.
  static TextStyle get bodySmall => GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ── Labels ────────────────────────────────────────────────────────────────

  /// Large label — buttons, important interactive labels.
  static TextStyle get labelLarge => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Medium label — form field labels, chip text.
  static TextStyle get labelMedium => GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Small label — meta info, step indicators, timestamps, captions.
  static TextStyle get labelSmall => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );

  // ── Caption ───────────────────────────────────────────────────────────────

  /// Smallest text — footnotes, placeholder hints, de-emphasised metadata.
  static TextStyle get caption => GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.4,
  );
}
