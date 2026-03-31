import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_progress_bar.dart';
import '../data/vak_providers.dart';
import '../domain/models/vak_question_model.dart';

/// Onboarding VAK Survey Screen.
///
/// Presents the 20-question Visual–Auditory–Kinesthetic learning-style
/// questionnaire one question at a time, with animated option cards and
/// per-question progress tracking.
///
/// **Route arguments** (optional `Map<String, int>`):
/// - `currentStep`  — which onboarding step this screen represents (default 2)
/// - `totalSteps`   — total onboarding steps (default 3)
///
/// On completion navigates to `/onboarding_complete` after persisting the
/// computed [VakResult] into [savedVakResultProvider].
class OnboardingVakScreen extends ConsumerStatefulWidget {
  const OnboardingVakScreen({super.key});

  @override
  ConsumerState<OnboardingVakScreen> createState() =>
      _OnboardingVakScreenState();
}

class _OnboardingVakScreenState extends ConsumerState<OnboardingVakScreen> {
  /// The style the user has tapped for the *currently visible* question.
  /// Resets to null each time we advance to the next question.
  VakStyle? _selectedOption;

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Extract route arguments, falling back to sensible defaults.
  Map<String, int> get _routeArgs {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, int>) return args;
    return {'currentStep': 2, 'totalSteps': 3};
  }

  bool get _isLastQuestion =>
      ref.read(vakCurrentIndexProvider) == _totalQuestions - 1;

  int get _totalQuestions => ref.read(vakQuestionsProvider).length; // 20

  // ── Actions ────────────────────────────────────────────────────────────────

  void _onOptionTapped(VakQuestion question, VakStyle style) {
    // Update local visual state.
    setState(() => _selectedOption = style);

    // Persist answer into the global answers map.
    ref
        .read(vakAnswersProvider.notifier)
        .update((map) => {...map, question.id: style});
  }

  void _onNextPressed() {
    if (_selectedOption == null) return;

    if (_isLastQuestion) {
      // Persist computed result before leaving the survey.
      ref.read(savedVakResultProvider.notifier).state = ref.read(
        vakResultProvider,
      );

      Navigator.of(context).pushNamed('/onboarding_complete');
    } else {
      // Advance to the next question and clear local selection.
      ref.read(vakCurrentIndexProvider.notifier).state++;
      setState(() => _selectedOption = null);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(vakCurrentIndexProvider);
    final questions = ref.watch(vakQuestionsProvider);
    final question = questions[currentIndex];

    // Restore previously saved answer if the user navigates back.
    final savedAnswers = ref.watch(vakAnswersProvider);
    if (_selectedOption == null && savedAnswers.containsKey(question.id)) {
      // Schedule setState so we don't call it during build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedOption = savedAnswers[question.id]);
        }
      });
    }

    final args = _routeArgs;
    final currentStep = args['currentStep']!;
    final totalSteps = args['totalSteps']!;

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      bottomNavigationBar: _buildBottomButton(currentIndex),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Step progress header ─────────────────────────────────────────
            _buildStepHeader(currentStep, totalSteps),

            // ── Survey body ──────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Title
                    Text('Gaya Belajarmu', style: AppTextStyles.headlineMedium),

                    const SizedBox(height: 4),

                    // Sub-title
                    Text(
                      'Jawab jujur untuk hasil yang akurat',
                      style: AppTextStyles.bodySmall,
                    ),

                    const SizedBox(height: 20),

                    // ── In-survey question progress ──────────────────────────
                    _buildQuestionProgress(currentIndex),

                    const SizedBox(height: 16),

                    // ── Question card ────────────────────────────────────────
                    _buildQuestionCard(question.question),

                    const SizedBox(height: 20),

                    // ── Option cards ─────────────────────────────────────────
                    ...question.options.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildOptionCard(question, option),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step Progress Header ────────────────────────────────────────────────────

  Widget _buildStepHeader(int currentStep, int totalSteps) {
    final progress = currentStep / totalSteps;
    final progressPercent = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Langkah $currentStep dari $totalSteps',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '$progressPercent%',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomProgressBar(progress: progress, height: 6),
        ],
      ),
    );
  }

  // ── In-survey Question Progress ─────────────────────────────────────────────

  Widget _buildQuestionProgress(int currentIndex) {
    final total = _totalQuestions; // 20
    final questionProgress = (currentIndex + 1) / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Counter label
        Center(
          child: Text(
            '${currentIndex + 1} / $total',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Thin orange progress bar for in-survey progress
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: questionProgress,
            backgroundColor: AppColors.progressTrack,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryOrange,
            ),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  // ── Question Card ───────────────────────────────────────────────────────────

  Widget _buildQuestionCard(String questionText) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Text(
        questionText,
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }

  // ── Option Card ─────────────────────────────────────────────────────────────

  Widget _buildOptionCard(VakQuestion question, VakOption option) {
    final isSelected = _selectedOption == option.style;

    return GestureDetector(
      onTap: () => _onOptionTapped(question, option.style),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrangeLighter
              : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : AppColors.divider,
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Style icon
            Icon(
              option.icon,
              size: 22,
              color: isSelected
                  ? AppColors.primaryOrange
                  : AppColors.textSecondary,
            ),

            const SizedBox(width: 12),

            // Option text
            Expanded(
              child: Text(
                option.text,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ),

            // Selected check indicator
            if (isSelected) ...[
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 13,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Bottom "Next / Finish" Button ───────────────────────────────────────────

  Widget _buildBottomButton(int currentIndex) {
    final isAnswered = _selectedOption != null;
    final isLast = currentIndex == _totalQuestions - 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isAnswered ? _onNextPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              disabledBackgroundColor: AppColors.progressTrack,
              foregroundColor: AppColors.textWhite,
              disabledForegroundColor: AppColors.textSecondary,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLast ? 'Lihat Hasilku' : 'Selanjutnya',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isAnswered
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isLast
                      ? Icons.emoji_events_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18,
                  color: isAnswered
                      ? AppColors.textWhite
                      : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
