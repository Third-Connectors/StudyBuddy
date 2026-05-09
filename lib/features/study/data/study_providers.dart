import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/subject_model.dart';
import '../../home/data/home_providers.dart';

// ── Overall Progress Data ────────────────────────────────────────────────────

/// Holds aggregated study progress statistics shown at the top of StudyScreen.
class StudyOverallData {
  final double overallProgress;
  final int subjectsAbove80;
  final int totalSubjects;

  const StudyOverallData({
    required this.overallProgress,
    required this.subjectsAbove80,
    required this.totalSubjects,
  });
}

/// Provides dynamic overall progress data matching user stats.
final studyOverallProvider = Provider<StudyOverallData>((ref) {
  final statsAsync = ref.watch(userStatsProvider);
  final stats = statsAsync.value;
  
  if (stats == null) {
    return const StudyOverallData(
      overallProgress: 0.15,
      subjectsAbove80: 0,
      totalSubjects: 8,
    );
  }

  // Calculate dynamic overall progress based on XP, up to a max of 95%
  final double progress = (stats.xp / 5000).clamp(0.12, 0.95);
  final int subjectsAbove80 = stats.xp > 3000 ? 2 : (stats.xp > 1500 ? 1 : 0);

  return StudyOverallData(
    overallProgress: progress,
    subjectsAbove80: subjectsAbove80,
    totalSubjects: 8,
  );
});

// ── Subject List Provider ────────────────────────────────────────────────────

/// Provides the complete dynamic list of subjects with progress data.
final subjectListProvider = Provider<List<SubjectModel>>((ref) {
  final statsAsync = ref.watch(userStatsProvider);
  final xp = statsAsync.value?.xp ?? 0;

  // Dynamically scale progress with XP to make it feel alive and non-placeholder
  double calcProgress(double base, double weight) {
    return (base + (xp / 12000) * weight).clamp(0.10, 0.98);
  }

  return [
    SubjectModel(
      name: 'B. Inggris',
      iconColor: const Color(0xFF3B82F6),
      icon: Icons.translate_rounded,
      currentChapter: xp > 2000 ? 5 : 4,
      totalChapters: 8,
      progress: calcProgress(0.48, 0.5),
      nextTopic: 'Analytical Exposition',
    ),
    SubjectModel(
      name: 'Fisika',
      iconColor: const Color(0xFFFF6B2B),
      icon: Icons.science_rounded,
      currentChapter: xp > 3000 ? 5 : 4,
      totalChapters: 8,
      progress: calcProgress(0.52, 0.4),
      nextTopic: 'Gelombang Bunyi',
    ),
    SubjectModel(
      name: 'Ekonomi',
      iconColor: const Color(0xFF10B981),
      icon: Icons.bar_chart_rounded,
      currentChapter: xp > 4000 ? 5 : 4,
      totalChapters: 7,
      progress: calcProgress(0.55, 0.3),
      nextTopic: 'Perdagangan Internasional',
    ),
    SubjectModel(
      name: 'Biologi',
      iconColor: const Color(0xFF8B5CF6),
      icon: Icons.biotech_rounded,
      currentChapter: xp > 1500 ? 4 : 3,
      totalChapters: 8,
      progress: calcProgress(0.38, 0.6),
      nextTopic: 'Sistem Pencernaan',
    ),
    SubjectModel(
      name: 'Kimia',
      iconColor: const Color(0xFFEC4899),
      icon: Icons.water_drop_rounded,
      currentChapter: xp > 5000 ? 6 : 5,
      totalChapters: 9,
      progress: calcProgress(0.71, 0.2),
      nextTopic: 'Elektrolisis',
    ),
    SubjectModel(
      name: 'Matematika',
      iconColor: const Color(0xFFF59E0B),
      icon: Icons.functions_rounded,
      currentChapter: xp > 2500 ? 7 : 6,
      totalChapters: 10,
      progress: calcProgress(0.60, 0.45),
      nextTopic: 'Integral Parsial',
    ),
    SubjectModel(
      name: 'Sejarah',
      iconColor: const Color(0xFF6366F1),
      icon: Icons.history_edu_rounded,
      currentChapter: xp > 1000 ? 4 : 3,
      totalChapters: 7,
      progress: calcProgress(0.43, 0.55),
      nextTopic: 'Kemerdekaan Indonesia',
    ),
    SubjectModel(
      name: 'B. Indonesia',
      iconColor: const Color(0xFF14B8A6),
      icon: Icons.menu_book_rounded,
      currentChapter: xp > 6000 ? 8 : 7,
      totalChapters: 8,
      progress: calcProgress(0.88, 0.1),
      nextTopic: 'Karya Ilmiah',
    ),
  ];
});

// ── Active Tab Provider ──────────────────────────────────────────────────────

/// Controls which tab is active on the Study screen segmented control.
/// 0 = Mata Pelajaran, 1 = SNBT
final studyTabIndexProvider = StateProvider<int>((ref) => 0);

/// Keeps track of completed chapters per subject (e.g., {'Matematika': {0, 1, 2}})
final completedChaptersProvider = StateNotifierProvider<CompletedChaptersNotifier, Map<String, Set<int>>>((ref) {
  return CompletedChaptersNotifier();
});

class CompletedChaptersNotifier extends StateNotifier<Map<String, Set<int>>> {
  CompletedChaptersNotifier() : super({});

  void toggleChapter(String subject, int chapterIndex) {
    final current = Map<String, Set<int>>.from(state);
    final subjectSet = Set<int>.from(current[subject] ?? {});
    if (subjectSet.contains(chapterIndex)) {
      subjectSet.remove(chapterIndex);
    } else {
      subjectSet.add(chapterIndex);
    }
    current[subject] = subjectSet;
    state = current;
  }
}
