import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/vak_providers.dart';
import '../domain/models/vak_result_model.dart';
import '../domain/models/vak_question_model.dart';

/// Onboarding final screen — shown after the VAK survey is completed.
///
/// Celebrates the user completing onboarding and displays their dominant
/// VAK learning style alongside a breakdown of visual / auditory /
/// kinesthetic scores.
///
/// Navigation:
/// - In  : from [OnboardingVakScreen] via `Navigator.pushNamed('/onboarding_complete')`
/// - Out : to [MainNavigationScreen] (`/home`), full back-stack cleared
class OnboardingCompleteScreen extends ConsumerWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VakResult? vakResult = ref.watch(savedVakResultProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // ── Celebration emoji ─────────────────────────────────────
                const Text(
                  '🎉',
                  style: TextStyle(fontSize: 72),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // ── Main headline ─────────────────────────────────────────
                Text(
                  'Semua Siap!',
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // ── Sub-headline ──────────────────────────────────────────
                Text(
                  'Profil kamu sudah lengkap dan siap untuk memulai '
                  'perjalanan belajar!',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // ── VAK Result card ───────────────────────────────────────
                if (vakResult != null) _VakResultCard(result: vakResult),

                const SizedBox(height: 32),

                // ── CTA button ────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: AppColors.textWhite,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: Text(
                      'Mulai Belajar 🚀',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── VAK Result Card ────────────────────────────────────────────────────────────

class _VakResultCard extends StatelessWidget {
  final VakResult result;

  const _VakResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Dominant style header row ────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeLighter,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: AppColors.primaryOrange,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gaya Belajarmu',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${result.dominantStyleEmoji} ${result.dominantStyleLabel}',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Divider(color: AppColors.divider, thickness: 1),

          const SizedBox(height: 8),

          // ── Description ──────────────────────────────────────────────────
          Text(
            result.dominantStyleDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // ── Score pills row (Wrapped for responsiveness) ─────────────────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ScorePill(
                label: '👁️ Visual',
                score: result.visualScore,
                isDominant: result.dominantStyle == VakStyle.visual,
              ),
              _ScorePill(
                label: '👂 Auditory',
                score: result.auditoryScore,
                isDominant: result.dominantStyle == VakStyle.auditory,
              ),
              _ScorePill(
                label: '✋ Kinesthetic',
                score: result.kinestheticScore,
                isDominant: result.dominantStyle == VakStyle.kinesthetic,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Score Pill ─────────────────────────────────────────────────────────────────

class _ScorePill extends StatelessWidget {
  final String label;
  final int score;
  final bool isDominant;

  const _ScorePill({
    required this.label,
    required this.score,
    this.isDominant = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDominant
            ? AppColors.primaryOrange
            : AppColors.primaryOrangeLighter,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label: $score',
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: isDominant ? FontWeight.w800 : FontWeight.w600,
          color: isDominant ? Colors.white : AppColors.primaryOrange,
        ),
      ),
    );
  }
}
