import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/api_config.dart';
import '../../../../core/services/mongo_atlas_client.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/chat_model.dart';
import '../../data/repositories/tutor_repository.dart';

// ════════════════════════════════════════════════════════════════════════════
// 📝 PRACTICE PROVIDER — Quiz + Socratic Hint State Management
// ════════════════════════════════════════════════════════════════════════════
//
// Manages the state of:
// - Quiz question navigation (next, prev, jump)
// - Answer selection and submission
// - Socratic AI hint system (in-quiz, per-question)
// - Timer and scoring
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
  final Map<int, int> selectedAnswers; // questionIndex -> selectedOptionIndex
  final Map<int, bool> answeredCorrectly; // questionIndex -> isCorrect
  final Map<int, QuestionHintState> hintStates; // questionIndex -> hints
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

  /// How many questions have been answered.
  int get answeredCount => selectedAnswers.length;

  /// Progress as 0.0 – 1.0.
  double get progress =>
      questions.isEmpty ? 0 : answeredCount / questions.length;

  /// How many correct answers so far.
  int get correctCount => answeredCorrectly.values.where((v) => v).length;

  /// Current question (convenience getter).
  QuizQuestion? get currentQuestion =>
      questions.isEmpty ? null : questions[currentQuestionIndex];

  /// Whether the current question has been answered.
  bool get isCurrentAnswered =>
      selectedAnswers.containsKey(currentQuestionIndex);

  /// Whether we're on the last question.
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  /// Total hints used across all questions.
  int get totalHintsUsed =>
      hintStates.values.fold(0, (sum, h) => sum + h.hintCount);
}

/// Notifier for Practice (Quiz) state.
class PracticeNotifier extends StateNotifier<PracticeState> {
  final TutorRepository _tutorRepository;
  final SupabaseClient _supabase;
  final MongoAtlasClient _mongoClient = MongoAtlasClient();

  PracticeNotifier(this._tutorRepository, this._supabase)
    : super(const PracticeState());

  /// Load questions — tries MongoDB Atlas first, falls back to seed data.
  Future<void> loadQuestions({
    required String subject,
    String difficulty = 'medium',
  }) async {
    state = state.copyWith(
      isLoading: true,
      subject: subject,
      difficulty: difficulty,
    );

    List<QuizQuestion> questions = [];

    // ── Try MongoDB Atlas first ───────────────────────────────────────────
    try {
      // Only attempt if Atlas API key is configured
      if (ApiConfig.mongoAtlasApiKey != 'YOUR_ATLAS_API_KEY') {
        final docs = await _mongoClient.find(
          collection: ApiConfig.colQuestions,
          filter: {'subject': subject, 'difficulty': difficulty},
          limit: 10,
          sort: {'_id': 1},
        );

        if (docs.isNotEmpty) {
          questions = docs.map((d) => QuizQuestion.fromAtlasJson(d)).toList();
          debugPrint(
            '[PracticeNotifier] Loaded ${questions.length} questions from MongoDB Atlas',
          );
        }
      }
    } catch (e) {
      debugPrint(
        '[PracticeNotifier] MongoDB Atlas fetch failed, using seed data: $e',
      );
    }

    // ── Fallback to hardcoded seed data ──────────────────────────────────
    if (questions.isEmpty) {
      questions = _getSeedQuestions(subject);
      debugPrint(
        '[PracticeNotifier] Using ${questions.length} seed questions for $subject',
      );
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

  /// Select an answer for the current question.
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

  /// Move to the next question.
  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        showExplanation: state.selectedAnswers.containsKey(
          state.currentQuestionIndex + 1,
        ),
      );
    }
  }

  /// Move to the previous question.
  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
        showExplanation: state.selectedAnswers.containsKey(
          state.currentQuestionIndex - 1,
        ),
      );
    }
  }

  /// Jump to a specific question index.
  void goToQuestion(int index) {
    if (index >= 0 && index < state.questions.length) {
      state = state.copyWith(
        currentQuestionIndex: index,
        showExplanation: state.selectedAnswers.containsKey(index),
      );
    }
  }

  /// Request a Socratic hint for the current question.
  ///
  /// [studentMessage] — if provided, the student typed a follow-up question;
  /// it is optimistically appended to the chat before the AI responds.
  Future<void> requestHint({String? studentMessage}) async {
    final question = state.currentQuestion;
    if (question == null) return;

    final idx = state.currentQuestionIndex;
    final currentHintState = state.hintStates[idx] ?? const QuestionHintState();

    // Max 3 hints per question (auto-hints only; follow-ups are unlimited)
    if (studentMessage == null && currentHintState.hintCount >= 3) return;

    // Set loading state
    final newHintStates = Map<int, QuestionHintState>.from(state.hintStates);
    newHintStates[idx] = currentHintState.copyWith(isLoading: true);
    state = state.copyWith(hintStates: newHintStates);

    try {
      final hintNumber = currentHintState.hintCount + 1;

      // Build hint message — handle both auto-hint and student follow-up
      String message;
      if (studentMessage != null && currentHintState.hints.isNotEmpty) {
        // Student typed a follow-up — optimistically add their message to chat
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

        message =
            '''
[SOCRATIC TUTOR — Follow-up]

Soal: ${question.question}

Pilihan jawaban:
${question.options.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}. ${e.value}').join('\n')}

Percakapan sejauh ini:
$previousHintsText
Siswa: $studentMessage

Tugasmu: Berikan respons Socratic. JANGAN beri jawaban langsung. Ajukan satu pertanyaan pemantik yang membantu siswa menemukan jawaban sendiri. Bahasa Indonesia yang ramah.''';
      } else {
        // Auto-hint request (first hint or subsequent without student input)
        final previousHints = currentHintState.hints
            .where((h) => !h.isUser)
            .map((h) => h.content)
            .join('\n');

        message =
            '''
[QUIZ HINT REQUEST — Hint #$hintNumber of 3]

Soal: ${question.question}

Pilihan jawaban:
${question.options.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}. ${e.value}').join('\n')}

${previousHints.isNotEmpty ? 'Hint sebelumnya:\n$previousHints\n\nBerikan hint baru yang BERBEDA dan lebih spesifik.' : 'Ini hint pertama. Bantu siswa berpikir kritis untuk menemukan jawaban.'}

Ingat: JANGAN berikan jawaban langsung. Ajukan SATU pertanyaan penuntun dalam Bahasa Indonesia.''';
      }

      final response = await _tutorRepository.sendMessage(
        sessionId: 'practice_${DateTime.now().millisecondsSinceEpoch}',
        message: message,
        subject: state.subject,
        context: currentHintState.hints.isNotEmpty
            ? currentHintState.hints.last
            : null,
      );

      // Use state.hintStates[idx] (not currentHintState) so the optimistically
      // added user message is preserved when we append the AI response.
      final updatedHintStates = Map<int, QuestionHintState>.from(
        state.hintStates,
      );
      final currentHints =
          state.hintStates[idx]?.hints ?? currentHintState.hints;
      updatedHintStates[idx] = QuestionHintState(
        hints: [...currentHints, response],
        isLoading: false,
        hintCount: hintNumber,
      );

      state = state.copyWith(hintStates: updatedHintStates);
    } catch (e) {
      debugPrint('[PracticeNotifier] Hint request error: $e');

      final updatedHintStates = Map<int, QuestionHintState>.from(
        state.hintStates,
      );
      updatedHintStates[idx] = currentHintState.copyWith(isLoading: false);
      state = state.copyWith(
        hintStates: updatedHintStates,
        error: 'Gagal memuat hint: $e',
      );
    }
  }

  /// Mark the quiz as completed, save XP to Supabase, and update state.
  Future<void> completeQuiz() async {
    final timeSpent = state.startTime != null
        ? DateTime.now().difference(state.startTime!)
        : const Duration(minutes: 5);

    final score = state.questions.isEmpty
        ? 0
        : ((state.correctCount / state.questions.length) * 100).round();

    // XP calculation: base score + bonus for fewer hints used
    final baseXp = score;
    final hintPenalty = state.totalHintsUsed * 5;
    final xpEarned = (baseXp - hintPenalty).clamp(0, 100);

    final result = QuizResult(
      id: 'result_${DateTime.now().millisecondsSinceEpoch}',
      quizId: 'practice_${state.subject}',
      userId: 'current_user',
      selectedAnswers: List.generate(
        state.questions.length,
        (i) => state.selectedAnswers[i] ?? -1,
      ),
      correctCount: state.correctCount,
      score: score,
      xpEarned: xpEarned,
      completedAt: DateTime.now(),
      timeSpent: timeSpent,
    );

    // ── Save XP to Supabase ──────────────────────────────────────────────
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null && xpEarned > 0) {
        // Fetch current XP
        final statsRes = await _supabase
            .from('user_stats')
            .select('xp')
            .eq('user_id', userId)
            .maybeSingle();

        final currentXp = (statsRes?['xp'] as int?) ?? 0;
        final newXp = currentXp + xpEarned;

        // Upsert XP (in case the row doesn't exist yet)
        await _supabase
            .from('user_stats')
            .upsert({'user_id': userId, 'xp': newXp})
            .eq('user_id', userId);

        debugPrint(
          '[PracticeNotifier] XP saved: $currentXp → $newXp (+$xpEarned)',
        );
      }
    } catch (e) {
      debugPrint('[PracticeNotifier] Failed to save XP: $e');
      // Don't fail the quiz completion — just log
    }

    state = state.copyWith(isCompleted: true, result: result);
  }

  /// Reset the entire practice session.
  void reset() {
    state = const PracticeState();
  }

  /// Seed mock questions for each subject.
  List<QuizQuestion> _getSeedQuestions(String subject) {
    switch (subject) {
      case 'Matematika':
        return _mathQuestions;
      case 'Fisika':
        return _physicsQuestions;
      case 'Kimia':
        return _chemistryQuestions;
      case 'Biologi':
        return _biologyQuestions;
      case 'B. Indonesia':
        return _bahasaQuestions;
      default:
        return _mathQuestions; // Default fallback
    }
  }

  // ── Seed Data: Matematika ────────────────────────────────────────────────

  static const List<QuizQuestion> _mathQuestions = [
    QuizQuestion(
      id: 'mtk_1',
      question: 'Jika f(x) = 2x² + 3x - 5, maka f\'(x) adalah...',
      options: ['4x + 3', '4x - 3', '2x + 3', '4x² + 3'],
      correctIndex: 0,
      explanation:
          'Turunan f(x) = 2x² + 3x - 5 menggunakan rumus d/dx(axⁿ) = naxⁿ⁻¹.\nf\'(x) = 2(2)x¹ + 3(1)x⁰ = 4x + 3.',
    ),
    QuizQuestion(
      id: 'mtk_2',
      question: 'Nilai dari ∫(3x² + 2x) dx adalah...',
      options: ['x³ + x² + C', '6x + 2 + C', '3x³ + 2x² + C', 'x³ + x² '],
      correctIndex: 0,
      explanation:
          'Integral ∫(3x² + 2x) dx = (3/3)x³ + (2/2)x² + C = x³ + x² + C.',
    ),
    QuizQuestion(
      id: 'mtk_3',
      question: 'Limit dari lim(x→0) (sin 3x) / x adalah...',
      options: ['3', '0', '1', '1/3'],
      correctIndex: 0,
      explanation:
          'Gunakan rumus lim(x→0) sin(ax)/x = a.\nMaka lim(x→0) sin(3x)/x = 3.',
    ),
    QuizQuestion(
      id: 'mtk_4',
      question: 'Jika log₂(x) = 5, maka x = ...',
      options: ['32', '10', '25', '64'],
      correctIndex: 0,
      explanation: 'log₂(x) = 5 berarti 2⁵ = x, maka x = 32.',
    ),
    QuizQuestion(
      id: 'mtk_5',
      question: 'Matriks A = [[1,2],[3,4]]. Determinan A adalah...',
      options: ['-2', '2', '10', '-10'],
      correctIndex: 0,
      explanation: 'det(A) = (1)(4) - (2)(3) = 4 - 6 = -2.',
    ),
  ];

  // ── Seed Data: Fisika ────────────────────────────────────────────────────

  static const List<QuizQuestion> _physicsQuestions = [
    QuizQuestion(
      id: 'fis_1',
      question:
          'Sebuah benda bermassa 5 kg diberi gaya 20 N. Percepatan benda tersebut adalah...',
      options: ['4 m/s²', '100 m/s²', '25 m/s²', '0,25 m/s²'],
      correctIndex: 0,
      explanation: 'Hukum Newton II: F = ma → a = F/m = 20/5 = 4 m/s².',
    ),
    QuizQuestion(
      id: 'fis_2',
      question:
          'Energi kinetik benda bermassa 2 kg dengan kecepatan 3 m/s adalah...',
      options: ['9 J', '6 J', '3 J', '18 J'],
      correctIndex: 0,
      explanation: 'Ek = ½mv² = ½(2)(3²) = ½(2)(9) = 9 J.',
    ),
    QuizQuestion(
      id: 'fis_3',
      question:
          'Frekuensi gelombang dengan panjang gelombang 2 m dan cepat rambat 340 m/s adalah...',
      options: ['170 Hz', '680 Hz', '342 Hz', '338 Hz'],
      correctIndex: 0,
      explanation: 'f = v/λ = 340/2 = 170 Hz.',
    ),
    QuizQuestion(
      id: 'fis_4',
      question:
          'Tegangan listrik pada hambatan 10 Ω yang dialiri arus 2 A adalah...',
      options: ['20 V', '5 V', '12 V', '8 V'],
      correctIndex: 0,
      explanation: 'Hukum Ohm: V = IR = 2 × 10 = 20 V.',
    ),
    QuizQuestion(
      id: 'fis_5',
      question:
          'Usaha yang dilakukan gaya 50 N yang memindahkan benda sejauh 4 m adalah...',
      options: ['200 J', '12,5 J', '54 J', '46 J'],
      correctIndex: 0,
      explanation:
          'W = F × s = 50 × 4 = 200 J (asumsi gaya searah perpindahan).',
    ),
  ];

  // ── Seed Data: Kimia ─────────────────────────────────────────────────────

  static const List<QuizQuestion> _chemistryQuestions = [
    QuizQuestion(
      id: 'kim_1',
      question: 'Jumlah mol dalam 11 gram gas CO₂ (Mr = 44) adalah...',
      options: ['0,25 mol', '0,5 mol', '4 mol', '2,5 mol'],
      correctIndex: 0,
      explanation: 'n = massa/Mr = 11/44 = 0,25 mol.',
    ),
    QuizQuestion(
      id: 'kim_2',
      question: 'pH larutan HCl 0,01 M adalah...',
      options: ['2', '1', '3', '12'],
      correctIndex: 0,
      explanation: '[H⁺] = 0,01 M = 10⁻² M → pH = -log[H⁺] = -log(10⁻²) = 2.',
    ),
    QuizQuestion(
      id: 'kim_3',
      question: 'Ikatan yang terjadi antara atom Na dan Cl adalah ikatan...',
      options: ['Ionik', 'Kovalen', 'Logam', 'Kovalen koordinasi'],
      correctIndex: 0,
      explanation:
          'Na (logam) menyerahkan elektron ke Cl (non-logam) → ikatan ionik.',
    ),
    QuizQuestion(
      id: 'kim_4',
      question: 'Bilangan oksidasi Mn dalam KMnO₄ adalah...',
      options: ['+7', '+5', '+4', '+6'],
      correctIndex: 0,
      explanation: 'K(+1) + Mn(x) + 4×O(-2) = 0 → 1 + x - 8 = 0 → x = +7.',
    ),
    QuizQuestion(
      id: 'kim_5',
      question:
          'Gas ideal memiliki volume 2 L pada tekanan 1 atm dan suhu 273 K. Jika tekanan menjadi 2 atm pada suhu tetap, volumenya menjadi...',
      options: ['1 L', '4 L', '0,5 L', '3 L'],
      correctIndex: 0,
      explanation:
          'Hukum Boyle (T tetap): P₁V₁ = P₂V₂ → 1×2 = 2×V₂ → V₂ = 1 L.',
    ),
  ];

  // ── Seed Data: Biologi ───────────────────────────────────────────────────

  static const List<QuizQuestion> _biologyQuestions = [
    QuizQuestion(
      id: 'bio_1',
      question:
          'Organel sel yang berfungsi sebagai pusat pengendali sel adalah...',
      options: ['Nukleus', 'Mitokondria', 'Ribosom', 'Lisosom'],
      correctIndex: 0,
      explanation:
          'Nukleus (inti sel) mengandung DNA yang mengendalikan seluruh aktivitas sel.',
    ),
    QuizQuestion(
      id: 'bio_2',
      question: 'Proses fotosintesis terjadi di...',
      options: ['Kloroplas', 'Mitokondria', 'Ribosom', 'Vakuola'],
      correctIndex: 0,
      explanation:
          'Kloroplas mengandung klorofil yang menyerap cahaya untuk fotosintesis.',
    ),
    QuizQuestion(
      id: 'bio_3',
      question: 'Enzim yang memecah protein di lambung adalah...',
      options: ['Pepsin', 'Amilase', 'Lipase', 'Tripsin'],
      correctIndex: 0,
      explanation:
          'Pepsin bekerja di lambung (pH asam) untuk memecah protein menjadi pepton.',
    ),
    QuizQuestion(
      id: 'bio_4',
      question:
          'Urutan hierarki taksonomi dari yang tertinggi ke terendah adalah...',
      options: [
        'Kingdom-Filum-Kelas-Ordo-Famili-Genus-Spesies',
        'Spesies-Genus-Famili-Ordo-Kelas-Filum-Kingdom',
        'Kingdom-Kelas-Filum-Ordo-Famili-Genus-Spesies',
        'Filum-Kingdom-Kelas-Ordo-Famili-Genus-Spesies',
      ],
      correctIndex: 0,
      explanation:
          'Ingat: King Philip Came Over For Good Spaghetti (Kingdom, Phylum, Class, Order, Family, Genus, Species).',
    ),
    QuizQuestion(
      id: 'bio_5',
      question:
          'Pembuluh darah yang membawa darah kaya oksigen dari paru-paru ke jantung adalah...',
      options: ['Vena pulmonalis', 'Arteri pulmonalis', 'Aorta', 'Vena cava'],
      correctIndex: 0,
      explanation:
          'Vena pulmonalis membawa darah kaya O₂ dari paru-paru ke atrium kiri jantung.',
    ),
  ];

  // ── Seed Data: Bahasa Indonesia ──────────────────────────────────────────

  static const List<QuizQuestion> _bahasaQuestions = [
    QuizQuestion(
      id: 'ind_1',
      question: 'Kalimat berikut yang menggunakan kata baku adalah...',
      options: [
        'Mereka menganalisis data dengan cermat',
        'Mereka menganalisa data dengan cermat',
        'Mereka menganalisis data dengan cermats',
        'Mereka meng-analisa data dengan cermat',
      ],
      correctIndex: 0,
      explanation:
          'Kata baku yang benar adalah "menganalisis" bukan "menganalisa" (KBBI edisi terbaru).',
    ),
    QuizQuestion(
      id: 'ind_2',
      question: 'Teks prosedur bertujuan untuk...',
      options: [
        'Memberikan petunjuk langkah-langkah melakukan sesuatu',
        'Menceritakan kembali peristiwa masa lalu',
        'Menyampaikan pendapat tentang suatu isu',
        'Menjelaskan proses terjadinya suatu fenomena',
      ],
      correctIndex: 0,
      explanation:
          'Teks prosedur berisi langkah-langkah atau tahapan untuk mencapai tujuan tertentu.',
    ),
    QuizQuestion(
      id: 'ind_3',
      question: 'Konjungsi yang menunjukkan hubungan sebab-akibat adalah...',
      options: ['Oleh karena itu', 'Akan tetapi', 'Selain itu', 'Bahkan'],
      correctIndex: 0,
      explanation:
          '"Oleh karena itu" menghubungkan kalimat sebab dengan kalimat akibat.',
    ),
    QuizQuestion(
      id: 'ind_4',
      question: 'Struktur teks eksposisi yang benar adalah...',
      options: [
        'Tesis – Argumentasi – Penegasan Ulang',
        'Orientasi – Komplikasi – Resolusi',
        'Pernyataan Umum – Deretan Penjelasan – Penutup',
        'Tujuan – Langkah-langkah – Penegasan Ulang',
      ],
      correctIndex: 0,
      explanation:
          'Teks eksposisi tersusun dari: tesis (pendapat), argumentasi (bukti), dan penegasan ulang (kesimpulan).',
    ),
    QuizQuestion(
      id: 'ind_5',
      question: 'Penulisan judul karya ilmiah yang benar adalah...',
      options: [
        'Pengaruh Media Sosial terhadap Prestasi Belajar Siswa',
        'pengaruh media sosial terhadap prestasi belajar siswa',
        'PENGARUH MEDIA SOSIAL TERHADAP PRESTASI BELAJAR SISWA',
        'Pengaruh media sosial Terhadap prestasi belajar Siswa',
      ],
      correctIndex: 0,
      explanation:
          'Judul karya ilmiah ditulis dengan huruf kapital di awal setiap kata, kecuali kata tugas (terhadap, dan, di, ke, dari) yang tidak di awal judul.',
    ),
  ];
}

/// Provider for the Practice notifier.
final practiceNotifierProvider =
    StateNotifierProvider<PracticeNotifier, PracticeState>((ref) {
      return PracticeNotifier(
        ref.watch(tutorRepositoryProvider),
        Supabase.instance.client,
      );
    });
