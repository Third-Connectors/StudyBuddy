import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/quiz_item_model.dart';
import '../domain/models/user_model.dart';

// ── User Provider ─────────────────────────────────────────────────────────────
/// Provides a mocked [UserModel] that exactly matches the design mockup.
/// Replace with a real repository call (e.g. `ref.watch(authRepoProvider)`)
/// once the backend is wired up.
final userProvider = Provider<UserModel>((ref) {
  return const UserModel(
    id: 'usr_001',
    name: 'Benjamin Šeško',
    gradeClass: 'Class 12',
    xpPoints: 1250,
    rank: 8,
    presencePercentage: 85,
    targetUniversity: 'Institut Teknologi Bandung (ITB) - Teknik Informatika',
    fireStreak: 50,
  );
});

// ── Countdown Data ────────────────────────────────────────────────────────────
/// Plain data class for the UTBK SNBT 2026 countdown values.
class CountdownData {
  final int days;
  final int hours;
  final int minutes;

  const CountdownData({
    required this.days,
    required this.hours,
    required this.minutes,
  });
}

/// Provides mocked countdown data as seen in the design (84d 11h 1m).
/// In production, derive this by computing the delta from DateTime.now()
/// to the UTBK exam date.
final countdownProvider = Provider<CountdownData>((ref) {
  return const CountdownData(days: 84, hours: 11, minutes: 1);
});

// ── Quiz List Provider ────────────────────────────────────────────────────────
/// Provides the mocked "Latest Quiz" list shown on the Home screen.
/// Subjects match the design: Bahasa Indonesia (Done), Matematika (In Progress),
/// Bahasa Inggris (To do).
final quizItemsProvider = Provider<List<QuizItemModel>>((ref) {
  return const [
    QuizItemModel(
      subject: 'Bahasa Indonesia',
      status: QuizStatus.done,
      subjectColor: Color(0xFF4CAF50),
    ),
    QuizItemModel(
      subject: 'Matematika',
      status: QuizStatus.inProgress,
      subjectColor: Color(0xFFFF9800),
    ),
    QuizItemModel(
      subject: 'Bahasa Inggris',
      status: QuizStatus.toDo,
      subjectColor: Color(0xFF9E9E9E),
    ),
  ];
});
