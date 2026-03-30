import 'package:flutter/material.dart';

/// Represents a single academic subject with its study progress data.
/// Used by the Study screen to render the subject progress list.
class SubjectModel {
  final String name;
  final Color iconColor;
  final IconData icon;
  final int currentChapter;
  final int totalChapters;

  /// Progress value from 0.0 (no progress) to 1.0 (fully complete).
  final double progress;

  /// The title of the next recommended topic to study.
  final String nextTopic;

  const SubjectModel({
    required this.name,
    required this.iconColor,
    required this.icon,
    required this.currentChapter,
    required this.totalChapters,
    required this.progress,
    required this.nextTopic,
  });

  /// Returns the progress expressed as a whole-number percentage (0–100).
  int get progressPercent => (progress * 100).round();

  /// Returns a formatted chapter string, e.g. "4/8 bab".
  String get chapterLabel => '$currentChapter/$totalChapters bab';
}
