import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

/// The "Saran AI: Fokus hari ini" card displayed at the top of the subject
/// list on the Study screen.
///
/// Design spec:
/// - Warm amber-cream background ([AppColors.aiSuggestionBg])
/// - Amber dashed/solid border ([AppColors.aiSuggestionBorder])
/// - A tinted circular sparkle icon on the left
/// - Two lines of text: a bold title and a lighter description body
///
/// In a production build this widget would be driven by an AI provider
/// (e.g. `ref.watch(aiSuggestionProvider)`). For now, the content is
/// hard-coded to match the design mockup.
class AiSuggestionCardWidget extends StatelessWidget {
  /// Override the suggestion title. Defaults to the design-mockup value.
  final String? title;

  /// Override the suggestion body text. Defaults to the design-mockup value.
  final String? body;

  const AiSuggestionCardWidget({super.key, this.title, this.body});

  // ── Default content (matching design mockup) ───────────────────────────────

  static const String _defaultTitle = 'Saran AI: Fokus hari ini';
  static const String _defaultBody =
      'B. Inggris masih perlu diperkuat. '
      'Coba kerjakan latihan soal Analytical Exposition.';

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.aiSuggestionBg,
            AppColors.aiSuggestionBg.withOpacity(0.6),
            const Color(0xFFFFEDD5), // Light orange tint
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.aiSuggestionBorder.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.aiSuggestionIcon.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Sparkle / AI icon ──────────────────────────────────────────────
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.aiSuggestionIcon.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: AppColors.aiSuggestionIcon,
            ),
          ),

          const SizedBox(width: 12),

          // ── Text content ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title ?? _defaultTitle,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 4),

                // Body
                Text(
                  body ?? _defaultBody,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
