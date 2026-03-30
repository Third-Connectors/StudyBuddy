import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/subject_model.dart';

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

/// Provides mocked overall progress data matching the design mockup (63%).
final studyOverallProvider = Provider<StudyOverallData>((ref) {
  return const StudyOverallData(
    overallProgress: 0.63,
    subjectsAbove80: 1,
    totalSubjects: 8,
  );
});

// ── Subject List Provider ────────────────────────────────────────────────────

/// Provides the complete mocked list of subjects with progress data,
/// matching the Study screen mockup exactly.
final subjectListProvider = Provider<List<SubjectModel>>((ref) {
  return const [
    SubjectModel(
      name: 'B. Inggris',
      iconColor: Color(0xFF3B82F6),
      icon: Icons.translate_rounded,
      currentChapter: 4,
      totalChapters: 8,
      progress: 0.48,
      nextTopic: 'Analytical Exposition',
    ),
    SubjectModel(
      name: 'Fisika',
      iconColor: Color(0xFFFF6B2B),
      icon: Icons.science_rounded,
      currentChapter: 4,
      totalChapters: 8,
      progress: 0.52,
      nextTopic: 'Gelombang Bunyi',
    ),
    SubjectModel(
      name: 'Ekonomi',
      iconColor: Color(0xFF10B981),
      icon: Icons.bar_chart_rounded,
      currentChapter: 4,
      totalChapters: 7,
      progress: 0.55,
      nextTopic: 'Perdagangan Internasional',
    ),
    SubjectModel(
      name: 'Biologi',
      iconColor: Color(0xFF8B5CF6),
      icon: Icons.biotech_rounded,
      currentChapter: 3,
      totalChapters: 8,
      progress: 0.38,
      nextTopic: 'Sistem Pencernaan',
    ),
    SubjectModel(
      name: 'Kimia',
      iconColor: Color(0xFFEC4899),
      icon: Icons.water_drop_rounded,
      currentChapter: 5,
      totalChapters: 9,
      progress: 0.71,
      nextTopic: 'Elektrolisis',
    ),
    SubjectModel(
      name: 'Matematika',
      iconColor: Color(0xFFF59E0B),
      icon: Icons.functions_rounded,
      currentChapter: 6,
      totalChapters: 10,
      progress: 0.60,
      nextTopic: 'Integral Parsial',
    ),
    SubjectModel(
      name: 'Sejarah',
      iconColor: Color(0xFF6366F1),
      icon: Icons.history_edu_rounded,
      currentChapter: 3,
      totalChapters: 7,
      progress: 0.43,
      nextTopic: 'Kemerdekaan Indonesia',
    ),
    SubjectModel(
      name: 'B. Indonesia',
      iconColor: Color(0xFF14B8A6),
      icon: Icons.menu_book_rounded,
      currentChapter: 7,
      totalChapters: 8,
      progress: 0.88,
      nextTopic: 'Karya Ilmiah',
    ),
  ];
});

// ── Active Tab Provider ──────────────────────────────────────────────────────

/// Controls which tab is active on the Study screen segmented control.
/// 0 = Mata Pelajaran, 1 = SNBT
final studyTabIndexProvider = StateProvider<int>((ref) => 0);
