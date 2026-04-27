import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/providers/practice_provider.dart';
import 'practice_result_screen.dart';

/// Quiz practice screen with integrated Socratic AI hint system.
class PracticeScreen extends ConsumerStatefulWidget {
  final String subject;
  const PracticeScreen({super.key, required this.subject});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  bool _showHintPanel = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(practiceNotifierProvider.notifier).loadQuestions(
        subject: widget.subject,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(practiceNotifierProvider);

    if (state.isCompleted && state.result != null) {
      return PracticeResultScreen(
        result: state.result!,
        subject: widget.subject,
        totalQuestions: state.questions.length,
        hintsUsed: state.totalHintsUsed,
        onRetry: () => ref.read(practiceNotifierProvider.notifier).loadQuestions(subject: widget.subject),
        onBack: () => Navigator.of(context).pop(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: _buildAppBar(state),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange))
          : state.questions.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    _buildProgressBar(state),
                    Expanded(child: _buildQuestionBody(state)),
                    if (_showHintPanel) _buildHintPanel(state),
                    _buildBottomBar(state),
                  ],
                ),
    );
  }

  PreferredSizeWidget _buildAppBar(PracticeState state) {
    return AppBar(
      backgroundColor: AppColors.surfaceWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
        onPressed: () => _showExitDialog(),
      ),
      title: Text(widget.subject, style: AppTextStyles.titleMedium),
      centerTitle: true,
      actions: [
        if (state.questions.isNotEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${state.currentQuestionIndex + 1}/${state.questions.length}',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryOrange),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressBar(PracticeState state) {
    return Container(
      color: AppColors.surfaceWhite,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: List.generate(state.questions.length, (i) {
          Color color;
          if (state.answeredCorrectly.containsKey(i)) {
            color = state.answeredCorrectly[i]! ? AppColors.statusDoneText : Colors.redAccent;
          } else if (i == state.currentQuestionIndex) {
            color = AppColors.primaryOrange;
          } else {
            color = AppColors.progressTrack;
          }
          return Expanded(
            child: GestureDetector(
              onTap: () => ref.read(practiceNotifierProvider.notifier).goToQuestion(i),
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < state.questions.length - 1 ? 3 : 0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuestionBody(PracticeState state) {
    final question = state.currentQuestion!;
    final selectedIdx = state.selectedAnswers[state.currentQuestionIndex];
    final isAnswered = state.isCurrentAnswered;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrangeLighter,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Soal ${state.currentQuestionIndex + 1}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryOrange)),
                    ),
                    const Spacer(),
                    // Hint button
                    if (!isAnswered)
                      _buildHintButton(state),
                  ],
                ),
                const SizedBox(height: 16),
                Text(question.question, style: AppTextStyles.bodyLarge.copyWith(fontSize: 16, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Answer options
          ...List.generate(question.options.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOptionCard(
                index: i,
                text: question.options[i],
                isSelected: selectedIdx == i,
                isCorrect: i == question.correctIndex,
                isAnswered: isAnswered,
                onTap: isAnswered ? null : () => ref.read(practiceNotifierProvider.notifier).selectAnswer(i),
              ),
            );
          }),

          // Explanation
          if (isAnswered && state.showExplanation && question.explanation != null) ...[
            const SizedBox(height: 8),
            _buildExplanationCard(question.explanation!, selectedIdx == question.correctIndex),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHintButton(PracticeState state) {
    final idx = state.currentQuestionIndex;
    final hintState = state.hintStates[idx] ?? const QuestionHintState();
    final remaining = 3 - hintState.hintCount;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _showHintPanel = !_showHintPanel),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFFF8EC), Color(0xFFFFF0DB)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.aiSuggestionBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, size: 16, color: AppColors.aiSuggestionIcon),
              const SizedBox(width: 6),
              Text('Hint ($remaining)', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.aiSuggestionIcon)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required int index,
    required String text,
    required bool isSelected,
    required bool isCorrect,
    required bool isAnswered,
    VoidCallback? onTap,
  }) {
    final label = String.fromCharCode(65 + index);
    Color borderColor = AppColors.divider;
    Color bgColor = AppColors.surfaceWhite;
    Color labelBg = const Color(0xFFF3F4F6);
    Color labelColor = AppColors.textSecondary;
    IconData? trailingIcon;
    Color? trailingColor;

    if (isAnswered) {
      if (isCorrect) {
        borderColor = AppColors.statusDoneText;
        bgColor = const Color(0xFFF0FDF4);
        labelBg = AppColors.statusDoneText;
        labelColor = Colors.white;
        trailingIcon = Icons.check_circle_rounded;
        trailingColor = AppColors.statusDoneText;
      } else if (isSelected) {
        borderColor = Colors.redAccent;
        bgColor = const Color(0xFFFEF2F2);
        labelBg = Colors.redAccent;
        labelColor = Colors.white;
        trailingIcon = Icons.cancel_rounded;
        trailingColor = Colors.redAccent;
      }
    } else if (isSelected) {
      borderColor = AppColors.primaryOrange;
      bgColor = AppColors.primaryOrangeLighter;
      labelBg = AppColors.primaryOrange;
      labelColor = Colors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: labelBg, borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text(label, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: labelColor))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(text, style: AppTextStyles.bodyMedium.copyWith(height: 1.4))),
            if (trailingIcon != null) Icon(trailingIcon, color: trailingColor, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(String explanation, bool isCorrect) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isCorrect ? const Color(0xFFBBF7D0) : AppColors.aiSuggestionBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isCorrect ? Icons.emoji_events_rounded : Icons.lightbulb_rounded, size: 18, color: isCorrect ? AppColors.statusDoneText : AppColors.aiSuggestionIcon),
              const SizedBox(width: 8),
              Text(isCorrect ? 'Benar! 🎉' : 'Pembahasan', style: AppTextStyles.titleSmall.copyWith(color: isCorrect ? AppColors.statusDoneText : AppColors.aiSuggestionIcon)),
            ],
          ),
          const SizedBox(height: 10),
          Text(explanation, style: AppTextStyles.bodySmall.copyWith(height: 1.6, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildHintPanel(PracticeState state) {
    final idx = state.currentQuestionIndex;
    final hintState = state.hintStates[idx] ?? const QuestionHintState();

    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        border: Border(top: BorderSide(color: AppColors.aiSuggestionBorder, width: 1.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 0),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, size: 18, color: AppColors.aiSuggestionIcon),
                const SizedBox(width: 8),
                Text('Socratic Hint', style: AppTextStyles.titleSmall.copyWith(color: AppColors.aiSuggestionIcon)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _showHintPanel = false),
                ),
              ],
            ),
          ),
          // Hint content
          Flexible(
            child: hintState.hints.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Butuh bantuan? AI akan memberi pertanyaan penuntun, bukan jawaban langsung.', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        _buildRequestHintButton(hintState),
                      ],
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    children: [
                      ...hintState.hints.map((hint) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8EC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(hint.content, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.5)),
                        ),
                      )),
                      if (hintState.hintCount < 3) _buildRequestHintButton(hintState),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestHintButton(QuestionHintState hintState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: hintState.isLoading ? null : () => ref.read(practiceNotifierProvider.notifier).requestHint(),
        icon: hintState.isLoading
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.auto_awesome, size: 16),
        label: Text(hintState.isLoading ? 'Memuat...' : 'Minta Hint AI'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.aiSuggestionIcon,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildBottomBar(PracticeState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (state.currentQuestionIndex > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ref.read(practiceNotifierProvider.notifier).previousQuestion(),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Kembali'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.divider),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            if (state.currentQuestionIndex > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: state.isCurrentAnswered
                    ? () {
                        if (state.isLastQuestion) {
                          ref.read(practiceNotifierProvider.notifier).completeQuiz();
                        } else {
                          setState(() => _showHintPanel = false);
                          ref.read(practiceNotifierProvider.notifier).nextQuestion();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.progressTrack,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  state.isLastQuestion && state.isCurrentAnswered ? 'Lihat Hasil' : 'Lanjut',
                  style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.quiz_outlined, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text('Soal belum tersedia', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Text('Coba mata pelajaran lain', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari latihan?'),
        content: const Text('Progres latihanmu tidak akan disimpan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
