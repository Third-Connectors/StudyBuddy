import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/models/quiz_model.dart';

/// Result screen shown after completing a quiz practice session.
class PracticeResultScreen extends StatelessWidget {
  final QuizResult result;
  final String subject;
  final int totalQuestions;
  final int hintsUsed;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const PracticeResultScreen({
    super.key,
    required this.result,
    required this.subject,
    required this.totalQuestions,
    required this.hintsUsed,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isPassing = result.score >= 60;
    final emoji = result.score >= 80 ? '🎉' : result.score >= 60 ? '👍' : '💪';
    final message = result.score >= 80
        ? 'Luar biasa!'
        : result.score >= 60
            ? 'Bagus! Terus berlatih!'
            : 'Jangan menyerah, coba lagi!';

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Emoji & Score
              Text(emoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(message, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(subject, style: AppTextStyles.bodySmall),

              const SizedBox(height: 32),

              // Score circle
              Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isPassing
                        ? [const Color(0xFF10B981), const Color(0xFF059669)]
                        : [AppColors.primaryOrange, const Color(0xFFEA580C)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isPassing ? const Color(0xFF10B981) : AppColors.primaryOrange).withOpacity(0.35),
                      blurRadius: 24, offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${result.score}', style: GoogleFonts.nunito(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text('SKOR', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 2)),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Stats grid
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    _buildStatRow(Icons.check_circle_rounded, 'Benar', '${result.correctCount}/$totalQuestions', AppColors.statusDoneText),
                    const Divider(height: 24),
                    _buildStatRow(Icons.star_rounded, 'XP Diperoleh', '+${result.xpEarned} XP', AppColors.aiSuggestionIcon),
                    const Divider(height: 24),
                    _buildStatRow(Icons.auto_awesome, 'Hint Digunakan', '$hintsUsed kali', AppColors.subjectPurple),
                    const Divider(height: 24),
                    _buildStatRow(Icons.timer_rounded, 'Waktu', _formatDuration(result.timeSpent), AppColors.subjectBlue),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Kembali ke Study'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.divider),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
        Text(value, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m}m ${s}s';
  }
}
