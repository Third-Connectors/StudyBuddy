import 'package:equatable/equatable.dart';

/// VAK (Visual, Auditory, Kinesthetic) learning style types.
enum VakStyle { visual, auditory, kinesthetic }

/// Extension for human-readable VAK style names.
extension VakStyleExtension on VakStyle {
  String get displayName {
    switch (this) {
      case VakStyle.visual:
        return 'Visual';
      case VakStyle.auditory:
        return 'Auditory';
      case VakStyle.kinesthetic:
        return 'Kinesthetic';
    }
  }

  String get description {
    switch (this) {
      case VakStyle.visual:
        return 'Belajar dengan melihat gambar, diagram, dan video.';
      case VakStyle.auditory:
        return 'Belajar dengan mendengarkan penjelasan dan diskusi.';
      case VakStyle.kinesthetic:
        return 'Belajar dengan praktik langsung dan eksperimen.';
    }
  }

  String get icon {
    switch (this) {
      case VakStyle.visual:
        return '👁️';
      case VakStyle.auditory:
        return '👂';
      case VakStyle.kinesthetic:
        return '✋';
    }
  }
}

/// VAK Question model for the learning style assessment.
class VakQuestion extends Equatable {
  final int id;
  final String question;
  final String optionA; // Visual
  final String optionB; // Auditory
  final String optionC; // Kinesthetic

  const VakQuestion({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
  });

  factory VakQuestion.fromJson(Map<String, dynamic> json) {
    return VakQuestion(
      id: json['id'] as int,
      question: json['question'] as String,
      optionA: json['optionA'] as String,
      optionB: json['optionB'] as String,
      optionC: json['optionC'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
    };
  }

  @override
  List<Object?> get props => [id, question, optionA, optionB, optionC];
}

/// VAK Answer model representing user's response.
class VakAnswer extends Equatable {
  final int questionId;
  final String selectedOption; // 'A', 'B', or 'C'

  const VakAnswer({required this.questionId, required this.selectedOption});

  factory VakAnswer.fromJson(Map<String, dynamic> json) {
    return VakAnswer(
      questionId: json['questionId'] as int,
      selectedOption: json['selectedOption'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'selectedOption': selectedOption};
  }

  @override
  List<Object?> get props => [questionId, selectedOption];
}

/// VAK Result model containing the assessment outcome.
class VakResult extends Equatable {
  final String userId;
  final VakStyle dominantStyle;
  final double visualScore;
  final double auditoryScore;
  final double kinestheticScore;
  final double confidence;
  final DateTime completedAt;
  final List<VakAnswer> answers;

  const VakResult({
    required this.userId,
    required this.dominantStyle,
    required this.visualScore,
    required this.auditoryScore,
    required this.kinestheticScore,
    this.confidence = 0.0,
    required this.completedAt,
    required this.answers,
  });

  factory VakResult.fromJson(Map<String, dynamic> json) {
    return VakResult(
      userId: json['userId'] as String,
      dominantStyle: VakStyle.values.firstWhere(
        (e) => e.name == json['dominantStyle'],
        orElse: () => VakStyle.visual,
      ),
      visualScore: (json['visualScore'] as num).toDouble(),
      auditoryScore: (json['auditoryScore'] as num).toDouble(),
      kinestheticScore: (json['kinestheticScore'] as num).toDouble(),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      completedAt: DateTime.parse(json['completedAt'] as String),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => VakAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dominantStyle': dominantStyle.name,
      'visualScore': visualScore,
      'auditoryScore': auditoryScore,
      'kinestheticScore': kinestheticScore,
      'confidence': confidence,
      'completedAt': completedAt.toIso8601String(),
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }

  VakResult copyWith({
    String? userId,
    VakStyle? dominantStyle,
    double? visualScore,
    double? auditoryScore,
    double? kinestheticScore,
    double? confidence,
    DateTime? completedAt,
    List<VakAnswer>? answers,
  }) {
    return VakResult(
      userId: userId ?? this.userId,
      dominantStyle: dominantStyle ?? this.dominantStyle,
      visualScore: visualScore ?? this.visualScore,
      auditoryScore: auditoryScore ?? this.auditoryScore,
      kinestheticScore: kinestheticScore ?? this.kinestheticScore,
      confidence: confidence ?? this.confidence,
      completedAt: completedAt ?? this.completedAt,
      answers: answers ?? this.answers,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    dominantStyle,
    visualScore,
    auditoryScore,
    kinestheticScore,
    confidence,
    completedAt,
    answers,
  ];
}
