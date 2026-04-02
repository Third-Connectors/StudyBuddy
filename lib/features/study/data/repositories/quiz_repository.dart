// ════════════════════════════════════════════════════════════════════════════
// 📝 QUIZ REPOSITORY — Quiz & Leaderboard Operations
// ════════════════════════════════════════════════════════════════════════════
//
// Handles:
// - Quiz listing and filtering
// - Quiz attempt and submission
// - Score calculation and XP rewards
// - Leaderboard rankings
// - User profile stats
//
// Backend: NestJS API Gateway with MongoDB (quiz content) & PostgreSQL (results)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';

import '../models/quiz_model.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';

/// Repository for Quiz operations.
class QuizRepository {
  final ApiClient _apiClient;

  QuizRepository(this._apiClient);

  /// Get list of available quizzes.
  ///
  /// Backend: GET /quiz
  /// Query params: subject, difficulty, gradeLevel
  Future<List<Quiz>> getQuizzes({
    String? subjectCode,
    String? difficulty,
    String? gradeLevel,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.quizList,
        queryParameters: {
          if (subjectCode != null) 'subject': subjectCode,
          if (difficulty != null) 'difficulty': difficulty,
          if (gradeLevel != null) 'gradeLevel': gradeLevel,
        },
      );

      final quizzes = response['quizzes'] as List?;
      if (quizzes == null) return [];

      return quizzes
          .map((q) => Quiz.fromJson(q as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[QuizRepository] Get quizzes error: $e');
      return [];
    }
  }

  /// Get quiz details by ID.
  ///
  /// Backend: GET /quiz/{quizId}
  Future<Quiz?> getQuizById(String quizId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.quizDetail.replaceFirst('{quizId}', quizId),
      );

      return Quiz.fromJson(response['quiz'] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[QuizRepository] Get quiz by ID error: $e');
      return null;
    }
  }

  /// Get quiz questions.
  ///
  /// Backend: GET /quiz/{quizId}/questions
  Future<List<QuizQuestion>> getQuizQuestions(String quizId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.quizDetail}/$quizId/questions',
      );

      final questions = response['questions'] as List?;
      if (questions == null) return [];

      return questions
          .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[QuizRepository] Get questions error: $e');
      return [];
    }
  }

  /// Submit quiz answers.
  ///
  /// Backend: POST /quiz/{quizId}/submit
  /// Response includes score, XP earned, and correct answers
  Future<QuizResult> submitQuiz({
    required String quizId,
    required String userId,
    required List<int> selectedAnswers,
    required Duration timeSpent,
  }) async {
    try {
      final response = await _apiClient
          .post(ApiEndpoints.quizSubmit.replaceFirst('{quizId}', quizId), {
            'userId': userId,
            'answers': selectedAnswers,
            'timeSpentSeconds': timeSpent.inSeconds,
          });

      return QuizResult.fromJson(response['result'] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[QuizRepository] Submit quiz error: $e');
      throw Exception('Failed to submit quiz: $e');
    }
  }

  /// Get quiz result by ID.
  ///
  /// Backend: GET /quiz/result/{resultId}
  Future<QuizResult?> getQuizResult(String resultId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.quizResult.replaceFirst('{quizId}', resultId),
      );

      return QuizResult.fromJson(response['result'] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[QuizRepository] Get result error: $e');
      return null;
    }
  }

  /// Get user's quiz history.
  ///
  /// Backend: GET /quiz/history?userId=$userId
  Future<List<QuizResult>> getQuizHistory(String userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.quizList}/history',
        queryParameters: {'userId': userId},
      );

      final results = response['results'] as List?;
      if (results == null) return [];

      return results
          .map((r) => QuizResult.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[QuizRepository] Get history error: $e');
      return [];
    }
  }

  /// Get recommended quizzes based on user's VAK style and weak subjects.
  ///
  /// Backend: GET /quiz/recommended?userId=$userId
  Future<List<Quiz>> getRecommendedQuizzes(String userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.quizList}/recommended',
        queryParameters: {'userId': userId},
      );

      final quizzes = response['quizzes'] as List?;
      if (quizzes == null) return [];

      return quizzes
          .map((q) => Quiz.fromJson(q as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[QuizRepository] Get recommended error: $e');
      return [];
    }
  }
}

/// Repository for Leaderboard operations.
class LeaderboardRepository {
  final ApiClient _apiClient;

  LeaderboardRepository(this._apiClient);

  /// Get leaderboard entries.
  ///
  /// Backend: GET /leaderboard (or /leaderboard/weekly, /leaderboard/monthly)
  Future<List<LeaderboardEntry>> getLeaderboard({
    String? timeframe, // 'daily', 'weekly', 'monthly', 'alltime'
    int limit = 50,
  }) async {
    try {
      String endpoint;
      if (timeframe == 'weekly') {
        endpoint = ApiEndpoints.leaderboardWeekly;
      } else if (timeframe == 'monthly') {
        endpoint = ApiEndpoints.leaderboardMonthly;
      } else {
        endpoint = ApiEndpoints.leaderboard;
      }

      final response = await _apiClient.get(
        endpoint,
        queryParameters: {'limit': limit},
      );

      final entries = response['entries'] as List?;
      if (entries == null) return [];

      return entries
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[LeaderboardRepository] Get leaderboard error: $e');
      return [];
    }
  }

  /// Get user's rank on leaderboard.
  ///
  /// Backend: GET /leaderboard/rank?userId=$userId
  Future<int?> getUserRank(String userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.leaderboard}/rank',
        queryParameters: {'userId': userId},
      );

      return response['rank'] as int?;
    } catch (e) {
      debugPrint('[LeaderboardRepository] Get rank error: $e');
      return null;
    }
  }

  /// Get user's profile with stats.
  ///
  /// Backend: GET /user/stats/{userId}
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.userStats.replaceFirst('{userId}', userId),
      );

      return UserProfile.fromJson(response['profile'] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[LeaderboardRepository] Get profile error: $e');
      throw Exception('Failed to load user profile: $e');
    }
  }

  /// Get user's friends leaderboard (social comparison).
  ///
  /// Backend: GET /leaderboard/friends
  Future<List<LeaderboardEntry>> getFriendsLeaderboard({int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.leaderboard}/friends',
        queryParameters: {'limit': limit},
      );

      final entries = response['entries'] as List?;
      if (entries == null) return [];

      return entries
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[LeaderboardRepository] Get friends leaderboard error: $e');
      return [];
    }
  }

  /// Get user's rank progression (weekly/monthly trend).
  ///
  /// Backend: GET /leaderboard/progression?userId=$userId
  Future<List<Map<String, dynamic>>> getRankProgression(String userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.leaderboard}/progression',
        queryParameters: {'userId': userId},
      );

      return response['progression'] as List<Map<String, dynamic>>? ?? [];
    } catch (e) {
      debugPrint('[LeaderboardRepository] Get progression error: $e');
      return [];
    }
  }
}

/// Providers for repositories.
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.watch(apiClientProvider));
});

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(ref.watch(apiClientProvider));
});
