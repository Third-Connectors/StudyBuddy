import 'package:flutter/material.dart';

/// Represents the completion status of a quiz item.
enum QuizStatus { done, inProgress, toDo }

/// Represents a single quiz item displayed in the Latest Quiz list on HomeScreen.
class QuizItemModel {
  final String subject;
  final QuizStatus status;
  final Color subjectColor;

  const QuizItemModel({
    required this.subject,
    required this.status,
    required this.subjectColor,
  });
}
