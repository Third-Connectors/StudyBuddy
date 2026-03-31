import 'vak_question_model.dart';

/// Holds the computed scores from a completed VAK survey and exposes
/// convenience getters for the dominant learning style.
class VakResult {
  final int visualScore;
  final int auditoryScore;
  final int kinestheticScore;

  const VakResult({
    required this.visualScore,
    required this.auditoryScore,
    required this.kinestheticScore,
  });

  // ── Dominant style ─────────────────────────────────────────────────────────

  /// Returns the [VakStyle] with the highest score.
  /// Visual wins ties involving visual; auditory wins a tie with kinesthetic.
  VakStyle get dominantStyle {
    if (visualScore >= auditoryScore && visualScore >= kinestheticScore) {
      return VakStyle.visual;
    }
    if (auditoryScore >= kinestheticScore) return VakStyle.auditory;
    return VakStyle.kinesthetic;
  }

  // ── Labels & metadata ──────────────────────────────────────────────────────

  String get dominantStyleLabel {
    switch (dominantStyle) {
      case VakStyle.visual:
        return 'Visual Learner';
      case VakStyle.auditory:
        return 'Auditory Learner';
      case VakStyle.kinesthetic:
        return 'Kinesthetic Learner';
    }
  }

  String get dominantStyleEmoji {
    switch (dominantStyle) {
      case VakStyle.visual:
        return '👁️';
      case VakStyle.auditory:
        return '👂';
      case VakStyle.kinesthetic:
        return '✋';
    }
  }

  String get dominantStyleDescription {
    switch (dominantStyle) {
      case VakStyle.visual:
        return 'Kamu belajar terbaik melalui gambar, diagram, dan visualisasi.';
      case VakStyle.auditory:
        return 'Kamu belajar terbaik melalui suara, penjelasan, dan diskusi.';
      case VakStyle.kinesthetic:
        return 'Kamu belajar terbaik melalui praktik langsung dan pengalaman.';
    }
  }
}
