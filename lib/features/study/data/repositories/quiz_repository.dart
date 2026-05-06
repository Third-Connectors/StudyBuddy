import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/quiz_model.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../../core/services/mongo_atlas_client.dart';
import '../../../../core/constants/api_config.dart';

/// Hybrid Repository for Quiz operations.
/// Questions come from MongoDB Atlas, Results go to Supabase.
class QuizRepository {
  final supabase.SupabaseClient _supabase;
  final MongoAtlasClient _mongoClient = MongoAtlasClient();

  QuizRepository(this._supabase);

  /// Get quiz questions from MongoDB Atlas.
  Future<List<QuizQuestion>> getQuizQuestions(String subject, {String difficulty = 'medium'}) async {
    try {
      // 1. Try to fetch from MongoDB Atlas
      if (ApiConfig.mongoAtlasApiKey != 'YOUR_ATLAS_API_KEY') {
        final docs = await _mongoClient.find(
          collection: ApiConfig.colQuestions,
          filter: {'subject': subject, 'difficulty': difficulty},
          limit: 10,
        );

        if (docs.isNotEmpty) {
          return docs.map((d) => QuizQuestion.fromAtlasJson(d)).toList();
        }
      }
    } catch (e) {
      debugPrint('[QuizRepository] MongoDB Atlas fetch failed: $e');
    }
    
    return []; // Return empty if not found, caller can use fallback
  }

  /// Submit quiz answers and save to Supabase 'quiz_results'.
  Future<QuizResult> submitQuiz({
    required String quizId,
    required String userId,
    required List<int> selectedAnswers,
    required int correctCount,
    required int score,
    required int xpEarned,
    required Duration timeSpent,
  }) async {
    try {
      final response = await _supabase.from('quiz_results').insert({
        'quiz_id': quizId,
        'user_id': userId,
        'answers': selectedAnswers,
        'correct_count': correctCount,
        'score': score,
        'xp_earned': xpEarned,
        'time_spent_seconds': timeSpent.inSeconds,
      }).select().single();

      return _mapQuizResultFromSupabase(response);
    } catch (e) {
      debugPrint('[QuizRepository] Submit quiz error: $e');
      throw Exception('Failed to submit quiz: $e');
    }
  }

  /// Helper to map Supabase JSON to QuizResult model.
  QuizResult _mapQuizResultFromSupabase(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'],
      quizId: json['quiz_id'],
      userId: json['user_id'],
      selectedAnswers: List<int>.from(json['answers']),
      correctCount: json['correct_count'],
      score: (json['score'] as num).toInt(),
      xpEarned: json['xp_earned'],
      completedAt: DateTime.parse(json['completed_at']),
      timeSpent: Duration(seconds: json['time_spent_seconds']),
    );
  }
}

/// Repository for Leaderboard operations using Supabase.
class LeaderboardRepository {
  final supabase.SupabaseClient _supabase;

  LeaderboardRepository(this._supabase);

  /// Get leaderboard entries from 'profiles' table.
  Future<List<LeaderboardEntry>> getLeaderboard({int limit = 50}) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id, name, xp, level, profile_image_url')
          .order('xp', ascending: false)
          .limit(limit);

      return (response as List).asMap().entries.map<LeaderboardEntry>((entry) {
        final i = entry.key;
        final data = entry.value;
        return LeaderboardEntry(
          id: data['id'] ?? '',
          userId: data['id'] ?? '',
          userName: data['name'] ?? 'Student',
          profileImageUrl: data['profile_image_url'] as String?,
          xp: data['xp'] ?? 0,
          rank: i + 1,
          level: data['level'] ?? 1,
          badges: 0,
        );
      }).toList();
    } catch (e) {
      debugPrint('[LeaderboardRepository] Get leaderboard error: $e');
      return [];
    }
  }

  /// Get user's rank on leaderboard.
  Future<int?> getUserRank(String userId) async {
    try {
      final userResponse = await _supabase
          .from('profiles')
          .select('xp')
          .eq('id', userId)
          .single();

      final userXp = userResponse['xp'] ?? 0;
      final countResponse = await _supabase
          .from('profiles')
          .count()
          .gt('xp', userXp);

      return countResponse + 1;
    } catch (e) {
      debugPrint('[LeaderboardRepository] Get rank error: $e');
      return null;
    }
  }
}

/// Providers for repositories.
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.watch(supabaseClientProvider));
});

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(ref.watch(supabaseClientProvider));
});
