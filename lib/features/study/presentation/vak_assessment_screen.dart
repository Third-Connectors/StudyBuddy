import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/providers/vak_provider.dart';
import 'vak_result_screen.dart';

/// VAK Assessment Screen - 20-question psychometric survey.
class VakAssessmentScreen extends ConsumerStatefulWidget {
  const VakAssessmentScreen({super.key});

  @override
  ConsumerState<VakAssessmentScreen> createState() =>
      _VakAssessmentScreenState();
}

class _VakAssessmentScreenState extends ConsumerState<VakAssessmentScreen> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    // Load questions on screen init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vakNotifierProvider.notifier).loadQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vakNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes Gaya Belajar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.result != null
          ? VakResultScreen(result: state.result!)
          : _buildQuiz(context, state),
    );
  }

  Widget _buildQuiz(BuildContext context, VakState state) {
    if (state.questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Soal tidak tersedia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () =>
                  ref.read(vakNotifierProvider.notifier).loadQuestions(),
              child: const Text('Muat Ulang'),
            ),
          ],
        ),
      );
    }

    final question = state.questions[state.currentQuestionIndex];
    final hasAnswered = state.answers.length > state.currentQuestionIndex;
    final canProceed = state.currentQuestionIndex < state.questions.length - 1;
    final isLastQuestion =
        state.currentQuestionIndex == state.questions.length - 1;

    return Column(
      children: [
        // Progress bar
        LinearProgressIndicator(value: state.progress),

        // Question counter
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal ${state.currentQuestionIndex + 1}/${state.questions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${(state.progress * 100).round()}%',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Question card
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Option A (Visual)
                    _buildOption(
                      'A',
                      question.optionA,
                      '👁️ Visual',
                      hasAnswered
                          ? state
                                .answers[state.currentQuestionIndex]
                                .selectedOption
                          : _selectedOption,
                      (value) => setState(() => _selectedOption = value),
                      !hasAnswered,
                    ),

                    const SizedBox(height: 12),

                    // Option B (Auditory)
                    _buildOption(
                      'B',
                      question.optionB,
                      '👂 Auditory',
                      hasAnswered
                          ? state
                                .answers[state.currentQuestionIndex]
                                .selectedOption
                          : _selectedOption,
                      (value) => setState(() => _selectedOption = value),
                      !hasAnswered,
                    ),

                    const SizedBox(height: 12),

                    // Option C (Kinesthetic)
                    _buildOption(
                      'C',
                      question.optionC,
                      '✋ Kinesthetic',
                      hasAnswered
                          ? state
                                .answers[state.currentQuestionIndex]
                                .selectedOption
                          : _selectedOption,
                      (value) => setState(() => _selectedOption = value),
                      !hasAnswered,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Navigation buttons
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (state.currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _selectedOption = null);
                      ref.read(vakNotifierProvider.notifier).previousQuestion();
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali'),
                  ),
                ),
              if (state.currentQuestionIndex > 0) const SizedBox(width: 12),

              Expanded(
                flex: state.currentQuestionIndex > 0 ? 1 : 2,
                child: hasAnswered
                    ? OutlinedButton(
                        onPressed: canProceed || isLastQuestion
                            ? () {
                                setState(() => _selectedOption = null);
                                if (canProceed) {
                                  ref
                                      .read(vakNotifierProvider.notifier)
                                      .nextQuestion();
                                } else {
                                  _showSubmitDialog();
                                }
                              }
                            : null,
                        child: Text(isLastQuestion ? 'Lihat Hasil' : 'Lanjut'),
                      )
                    : ElevatedButton(
                        onPressed: _selectedOption != null
                            ? () {
                                ref
                                    .read(vakNotifierProvider.notifier)
                                    .selectAnswer(_selectedOption!);
                              }
                            : null,
                        child: const Text('Pilih Jawaban'),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(
    String code,
    String text,
    String label,
    String? selected,
    ValueChanged<String> onChanged,
    bool enabled,
  ) {
    final isSelected = selected == code;

    return InkWell(
      onTap: enabled ? () => onChanged(code) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  code,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: code,
              groupValue: selected,
              onChanged: enabled ? (String? value) => onChanged(value!) : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Jawaban?'),
        content: const Text(
          'Kamu sudah menjawab semua soal. Submit untuk melihat hasil tes gaya belajarmu!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(vakNotifierProvider.notifier).submitAnswers();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
