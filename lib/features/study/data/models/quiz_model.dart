import 'package:equatable/equatable.dart';

/// Quiz model for practice questions.
class Quiz extends Equatable {
  final String id;
  final String title;
  final String subject;
  final String subjectCode;
  final String difficulty; // 'easy', 'medium', 'hard'
  final int questionCount;
  final int durationMinutes;
  final int xpReward;
  final String? description;
  final String? thumbnailUrl;
  final DateTime createdAt;

  const Quiz({
    required this.id,
    required this.title,
    required this.subject,
    required this.subjectCode,
    required this.difficulty,
    required this.questionCount,
    required this.durationMinutes,
    required this.xpReward,
    this.description,
    this.thumbnailUrl,
    required this.createdAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      subject: json['subject'] as String,
      subjectCode: json['subjectCode'] as String,
      difficulty: json['difficulty'] as String,
      questionCount: json['questionCount'] as int,
      durationMinutes: json['durationMinutes'] as int,
      xpReward: json['xpReward'] as int,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'subjectCode': subjectCode,
      'difficulty': difficulty,
      'questionCount': questionCount,
      'durationMinutes': durationMinutes,
      'xpReward': xpReward,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Quiz copyWith({
    String? id,
    String? title,
    String? subject,
    String? subjectCode,
    String? difficulty,
    int? questionCount,
    int? durationMinutes,
    int? xpReward,
    String? description,
    String? thumbnailUrl,
    DateTime? createdAt,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      subjectCode: subjectCode ?? this.subjectCode,
      difficulty: difficulty ?? this.difficulty,
      questionCount: questionCount ?? this.questionCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      xpReward: xpReward ?? this.xpReward,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subject,
    subjectCode,
    difficulty,
    questionCount,
    durationMinutes,
    xpReward,
    description,
    thumbnailUrl,
    createdAt,
  ];
}

/// Quiz question model.
class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final String? imageUrl;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.imageUrl,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List<dynamic>),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// Parse from MongoDB Atlas document format.
  ///
  /// Atlas uses `_id: {"\$oid": "..."}` instead of plain `id`.
  factory QuizQuestion.fromAtlasJson(Map<String, dynamic> json) {
    // Handle Atlas ObjectId format
    final rawId = json['_id'];
    final id = rawId is Map
        ? rawId['\$oid']?.toString() ?? json['id']?.toString() ?? ''
        : (rawId ?? json['id'])?.toString() ?? '';

    return QuizQuestion(
      id: id,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List<dynamic>),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    question,
    options,
    correctIndex,
    explanation,
    imageUrl,
  ];
}

/// Quiz submission result.
class QuizResult extends Equatable {
  final String id;
  final String quizId;
  final String userId;
  final List<int> selectedAnswers;
  final int correctCount;
  final int score;
  final int xpEarned;
  final DateTime completedAt;
  final Duration timeSpent;

  const QuizResult({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.selectedAnswers,
    required this.correctCount,
    required this.score,
    required this.xpEarned,
    required this.completedAt,
    required this.timeSpent,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] as String,
      quizId: json['quizId'] as String,
      userId: json['userId'] as String,
      selectedAnswers: List<int>.from(json['selectedAnswers'] as List<dynamic>),
      correctCount: json['correctCount'] as int,
      score: json['score'] as int,
      xpEarned: json['xpEarned'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      timeSpent: Duration(seconds: json['timeSpentSeconds'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'userId': userId,
      'selectedAnswers': selectedAnswers,
      'correctCount': correctCount,
      'score': score,
      'xpEarned': xpEarned,
      'completedAt': completedAt.toIso8601String(),
      'timeSpentSeconds': timeSpent.inSeconds,
    };
  }

  @override
  List<Object?> get props => [
    id,
    quizId,
    userId,
    selectedAnswers,
    correctCount,
    score,
    xpEarned,
    completedAt,
    timeSpent,
  ];
}
