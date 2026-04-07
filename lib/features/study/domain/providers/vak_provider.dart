import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/vak_model.dart';
import '../../data/repositories/vak_repository.dart';
import '../../../auth/data/repositories/auth_repository.dart';

/// State for VAK assessment.
class VakState {
  final List<VakQuestion> questions;
  final List<VakAnswer> answers;
  final VakResult? result;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final int currentQuestionIndex;

  const VakState({
    this.questions = const [],
    this.answers = const [],
    this.result,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.currentQuestionIndex = 0,
  });

  VakState copyWith({
    List<VakQuestion>? questions,
    List<VakAnswer>? answers,
    VakResult? result,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    int? currentQuestionIndex,
  }) {
    return VakState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error ?? this.error,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }

  double get progress =>
      questions.isEmpty ? 0 : (answers.length / questions.length);

  bool get isComplete => answers.length == questions.length;
}

/// Notifier for VAK assessment state management.
class VakNotifier extends StateNotifier<VakState> {
  final VakRepository _vakRepository;
  final AuthRepository _authRepository;

  VakNotifier(this._vakRepository, this._authRepository)
    : super(const VakState());

  /// Load VAK questions.
  Future<void> loadQuestions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final questions = await _vakRepository.getQuestions();
      state = state.copyWith(questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memuat soal: $e');
    }
  }

  /// Select an answer for the current question.
  void selectAnswer(String option) {
    if (state.currentQuestionIndex >= state.questions.length) return;

    final question = state.questions[state.currentQuestionIndex];
    final answer = VakAnswer(questionId: question.id, selectedOption: option);

    final answers = List<VakAnswer>.from(state.answers)..add(answer);
    state = state.copyWith(answers: answers);
  }

  /// Move to the next question.
  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    }
  }

  /// Move to the previous question.
  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  /// Submit all answers and get VAK result.
  Future<void> submitAnswers() async {
    if (!state.isComplete) return;

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      // Get current user ID (mock for now)
      final user = await _authRepository.getProfile();

      final result = await _vakRepository.submitAnswers(
        userId: user.id,
        answers: state.answers,
      );

      state = state.copyWith(result: result, isSubmitting: false);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Gagal mengirim jawaban: $e',
      );
    }
  }

  /// Reset the assessment.
  void reset() {
    state = const VakState();
  }

  /// Clear result (for recalibration).
  void clearResult() {
    state = state.copyWith(result: null, currentQuestionIndex: 0);
  }
}

/// Provider for VAK notifier.
final vakNotifierProvider = StateNotifierProvider<VakNotifier, VakState>((ref) {
  return VakNotifier(
    ref.watch(vakRepositoryProvider),
    ref.watch(authRepositoryProvider),
  );
});
