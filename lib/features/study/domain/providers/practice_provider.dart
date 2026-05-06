import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/quiz_model.dart';
import '../../data/models/chat_model.dart';
import '../../data/repositories/tutor_repository.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../../../core/services/notification_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// 📝 PRACTICE PROVIDER — Quiz + Socratic Hint State Management (Hybrid)
// ════════════════════════════════════════════════════════════════════════════

/// State for a single question's hint history.
class QuestionHintState {
  final List<ChatMessage> hints;
  final bool isLoading;
  final int hintCount;

  const QuestionHintState({
    this.hints = const [],
    this.isLoading = false,
    this.hintCount = 0,
  });

  QuestionHintState copyWith({
    List<ChatMessage>? hints,
    bool? isLoading,
    int? hintCount,
  }) {
    return QuestionHintState(
      hints: hints ?? this.hints,
      isLoading: isLoading ?? this.isLoading,
      hintCount: hintCount ?? this.hintCount,
    );
  }
}

/// Main state for the Practice (Quiz) screen.
class PracticeState {
  final List<QuizQuestion> questions;
  final Map<int, int> selectedAnswers;
  final Map<int, bool> answeredCorrectly;
  final Map<int, QuestionHintState> hintStates;
  final int currentQuestionIndex;
  final bool isLoading;
  final bool isSubmitting;
  final bool isCompleted;
  final bool showExplanation;
  final String? error;
  final String subject;
  final String difficulty;
  final DateTime? startTime;
  final QuizResult? result;

  const PracticeState({
    this.questions = const [],
    this.selectedAnswers = const {},
    this.answeredCorrectly = const {},
    this.hintStates = const {},
    this.currentQuestionIndex = 0,
    this.isLoading = false,
    this.isSubmitting = false,
    this.isCompleted = false,
    this.showExplanation = false,
    this.error,
    this.subject = '',
    this.difficulty = 'medium',
    this.startTime,
    this.result,
  });

  PracticeState copyWith({
    List<QuizQuestion>? questions,
    Map<int, int>? selectedAnswers,
    Map<int, bool>? answeredCorrectly,
    Map<int, QuestionHintState>? hintStates,
    int? currentQuestionIndex,
    bool? isLoading,
    bool? isSubmitting,
    bool? isCompleted,
    bool? showExplanation,
    String? error,
    String? subject,
    String? difficulty,
    DateTime? startTime,
    QuizResult? result,
  }) {
    return PracticeState(
      questions: questions ?? this.questions,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      answeredCorrectly: answeredCorrectly ?? this.answeredCorrectly,
      hintStates: hintStates ?? this.hintStates,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCompleted: isCompleted ?? this.isCompleted,
      showExplanation: showExplanation ?? this.showExplanation,
      error: error,
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
      startTime: startTime ?? this.startTime,
      result: result ?? this.result,
    );
  }

  int get answeredCount => selectedAnswers.length;
  double get progress => questions.isEmpty ? 0 : answeredCount / questions.length;
  int get correctCount => answeredCorrectly.values.where((v) => v).length;
  QuizQuestion? get currentQuestion => questions.isEmpty ? null : questions[currentQuestionIndex];
  bool get isCurrentAnswered => selectedAnswers.containsKey(currentQuestionIndex);
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  int get totalHintsUsed => hintStates.values.fold(0, (sum, h) => sum + h.hintCount);
}

/// Notifier for Practice (Quiz) state.
class PracticeNotifier extends StateNotifier<PracticeState> {
  final TutorRepository _tutorRepository;
  final QuizRepository _quizRepository;
  final SupabaseClient _supabase;

  PracticeNotifier({
    required TutorRepository tutorRepository,
    required QuizRepository quizRepository,
    required SupabaseClient supabase,
  }) : _tutorRepository = tutorRepository,
       _quizRepository = quizRepository,
       _supabase = supabase,
       super(const PracticeState());

  /// Load questions using QuizRepository (Hybrid: Mongo Atlas + Fallback).
  Future<void> loadQuestions({
    required String subject,
    String difficulty = 'medium',
  }) async {
    state = state.copyWith(
      isLoading: true,
      subject: subject,
      difficulty: difficulty,
    );

    // 1. Get questions from Repository (uses MongoDB Atlas)
    List<QuizQuestion> questions = await _quizRepository.getQuizQuestions(
      subject,
      difficulty: difficulty,
    );

    // 2. Fallback to seed data if Mongo is empty or fails
    if (questions.isEmpty) {
      questions = _getSeedQuestions(subject);
      debugPrint('[PracticeNotifier] Using seed fallback for $subject');
    } else {
      debugPrint('[PracticeNotifier] Loaded ${questions.length} questions from MongoDB Atlas');
    }

    state = state.copyWith(
      questions: questions,
      isLoading: false,
      startTime: DateTime.now(),
      selectedAnswers: {},
      answeredCorrectly: {},
      hintStates: {},
      currentQuestionIndex: 0,
      isCompleted: false,
      showExplanation: false,
      result: null,
      error: null,
    );
  }

  /// Select an answer.
  void selectAnswer(int optionIndex) {
    if (state.isCurrentAnswered) return;
    final question = state.currentQuestion;
    if (question == null) return;

    final isCorrect = optionIndex == question.correctIndex;
    final newAnswers = Map<int, int>.from(state.selectedAnswers);
    newAnswers[state.currentQuestionIndex] = optionIndex;

    final newCorrectly = Map<int, bool>.from(state.answeredCorrectly);
    newCorrectly[state.currentQuestionIndex] = isCorrect;

    state = state.copyWith(
      selectedAnswers: newAnswers,
      answeredCorrectly: newCorrectly,
      showExplanation: true,
    );
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        showExplanation: state.selectedAnswers.containsKey(state.currentQuestionIndex + 1),
      );
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
        showExplanation: state.selectedAnswers.containsKey(state.currentQuestionIndex - 1),
      );
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < state.questions.length) {
      state = state.copyWith(
        currentQuestionIndex: index,
        showExplanation: state.selectedAnswers.containsKey(index),
      );
    }
  }

  /// Request a Socratic hint.
  Future<void> requestHint({String? studentMessage}) async {
    final question = state.currentQuestion;
    if (question == null) return;

    final idx = state.currentQuestionIndex;
    final currentHintState = state.hintStates[idx] ?? const QuestionHintState();
    if (studentMessage == null && currentHintState.hintCount >= 3) return;

    final newHintStates = Map<int, QuestionHintState>.from(state.hintStates);
    newHintStates[idx] = currentHintState.copyWith(isLoading: true);
    state = state.copyWith(hintStates: newHintStates);

    try {
      final hintNumber = currentHintState.hintCount + 1;
      String message;
      if (studentMessage != null && currentHintState.hints.isNotEmpty) {
        final userMsg = ChatMessage(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          content: studentMessage,
          isUser: true,
          timestamp: DateTime.now(),
        );
        final withUserMsg = Map<int, QuestionHintState>.from(state.hintStates);
        withUserMsg[idx] = QuestionHintState(
          hints: [...currentHintState.hints, userMsg],
          isLoading: true,
          hintCount: currentHintState.hintCount,
        );
        state = state.copyWith(hintStates: withUserMsg);

        final previousHintsText = currentHintState.hints
            .where((h) => !h.isUser)
            .map((h) => 'AI: ${h.content}')
            .join('\n');

        message = '''
[SOCRATIC TUTOR — Follow-up]
Soal: ${question.question}
Pilihan: ${question.options.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}. ${e.value}').join('\n')}
Percakapan: $previousHintsText
Siswa: $studentMessage
Tugas: Berikan respons Socratic. Jangan beri jawaban langsung.''';
      } else {
        final previousHints = currentHintState.hints.where((h) => !h.isUser).map((h) => h.content).join('\n');
        message = '''
[QUIZ HINT REQUEST — Hint #$hintNumber]
Soal: ${question.question}
Pilihan: ${question.options.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}. ${e.value}').join('\n')}
${previousHints.isNotEmpty ? 'Hint sebelumnya:\n$previousHints' : 'Ini hint pertama.'}
Tugas: Ajukan SATU pertanyaan penuntun Socratic.''';
      }

      final response = await _tutorRepository.sendMessage(
        sessionId: 'practice_${DateTime.now().millisecondsSinceEpoch}',
        message: message,
        subject: state.subject,
        context: currentHintState.hints.isNotEmpty ? currentHintState.hints.last : null,
      );

      final updatedHintStates = Map<int, QuestionHintState>.from(state.hintStates);
      final currentHints = state.hintStates[idx]?.hints ?? currentHintState.hints;
      updatedHintStates[idx] = QuestionHintState(
        hints: [...currentHints, response],
        isLoading: false,
        hintCount: hintNumber,
      );
      state = state.copyWith(hintStates: updatedHintStates);
    } catch (e) {
      debugPrint('[PracticeNotifier] Hint error: $e');
      final updatedHintStates = Map<int, QuestionHintState>.from(state.hintStates);
      updatedHintStates[idx] = currentHintState.copyWith(isLoading: false);
      state = state.copyWith(hintStates: updatedHintStates, error: 'Gagal memuat hint: $e');
    }
  }

  /// Complete quiz and save to Supabase.
  Future<void> completeQuiz() async {
    final timeSpent = state.startTime != null ? DateTime.now().difference(state.startTime!) : const Duration(minutes: 5);
    final score = state.questions.isEmpty ? 0 : ((state.correctCount / state.questions.length) * 100).round();
    final xpEarned = (score - (state.totalHintsUsed * 5)).clamp(0, 100);
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final result = await _quizRepository.submitQuiz(
        quizId: 'practice_${state.subject}',
        userId: userId,
        selectedAnswers: List.generate(state.questions.length, (i) => state.selectedAnswers[i] ?? -1),
        correctCount: state.correctCount,
        score: score,
        xpEarned: xpEarned,
        timeSpent: timeSpent,
      );

      // Update Profile XP & Level
      final profileRes = await _supabase.from('profiles').select('xp, level').eq('id', userId).single();
      final newXp = ((profileRes['xp'] as int?) ?? 0) + xpEarned;
      final newLevel = (newXp / 1000).floor() + 1;

      await _supabase.from('profiles').update({'xp': newXp, 'level': newLevel}).eq('id', userId);
      await _supabase.from('user_stats').upsert({'user_id': userId, 'xp': newXp}).eq('id', userId);

      NotificationService.instance.cancelDailyReminder();
      state = state.copyWith(isCompleted: true, result: result);
    } catch (e) {
      debugPrint('[PracticeNotifier] Complete failed: $e');
      state = state.copyWith(error: 'Gagal menyimpan hasil: $e');
    }
  }

  void reset() => state = const PracticeState();

  List<QuizQuestion> _getSeedQuestions(String subject) {
    switch (subject) {
      case 'Matematika': return _mathQuestions;
      case 'Fisika': return _physicsQuestions;
      case 'Kimia': return _chemistryQuestions;
      case 'Biologi': return _biologyQuestions;
      case 'B. Indonesia': return _bahasaQuestions;
      default: return _mathQuestions;
    }
  }

  static const List<QuizQuestion> _mathQuestions = [
    QuizQuestion(id: 'mtk_1', question: 'Jika f(x) = 2x² + 3x - 5, maka f\'(x) adalah...', options: ['4x + 3', '4x - 3', '2x + 3', '4x² + 3'], correctIndex: 0, explanation: 'Turunan f(x) = 2x² + 3x - 5 adalah 4x + 3.'),
    QuizQuestion(id: 'mtk_2', question: 'Nilai dari ∫(3x² + 2x) dx adalah...', options: ['x³ + x² + C', '6x + 2 + C', '3x³ + 2x² + C', 'x³ + x² '], correctIndex: 0, explanation: '∫(3x² + 2x) dx = x³ + x² + C.'),
  ];
  static const List<QuizQuestion> _physicsQuestions = [
    QuizQuestion(id: 'fis_1', question: 'Benda 5 kg diberi gaya 20 N. Percepatannya...', options: ['4 m/s²', '100 m/s²', '25 m/s²', '0,25 m/s²'], correctIndex: 0, explanation: 'a = F/m = 20/5 = 4 m/s².'),
  ];
  static const List<QuizQuestion> _chemistryQuestions = [
    QuizQuestion(id: 'kim_1', question: 'Jumlah mol dalam 11 gram CO₂ (Mr = 44) adalah...', options: ['0,25 mol', '0,5 mol', '4 mol', '2,5 mol'], correctIndex: 0, explanation: 'n = 11/44 = 0,25 mol.'),
  ];
  static const List<QuizQuestion> _biologyQuestions = [
    QuizQuestion(id: 'bio_1', question: 'Pusat pengendali sel adalah...', options: ['Nukleus', 'Mitokondria', 'Ribosom', 'Lisosom'], correctIndex: 0, explanation: 'Nukleus mengendalikan seluruh aktivitas sel.'),
  ];
  static const List<QuizQuestion> _bahasaQuestions = [
    QuizQuestion(id: 'ind_1', question: 'Kata baku yang benar adalah...', options: ['menganalisis', 'menganalisa', 'menganalisis data', 'meng-analisa'], correctIndex: 0, explanation: 'Baku: menganalisis.'),
  ];
}

final practiceNotifierProvider = StateNotifierProvider<PracticeNotifier, PracticeState>((ref) {
  return PracticeNotifier(
    tutorRepository: ref.watch(tutorRepositoryProvider),
    quizRepository: ref.watch(quizRepositoryProvider),
    supabase: Supabase.instance.client,
  );
});
