import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  /// ⚠️ TODO: Implement actual API call
  Future<List<Quiz>> getQuizzes({
    String? subjectCode,
    String? difficulty,
  }) async {
    // ⚠️ PLACEHOLDER - Return mock quizzes
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Quiz(
        id: 'quiz_1',
        title: 'Latihan Matematika - Aljabar',
        subject: 'Matematika',
        subjectCode: 'MTK',
        difficulty: 'medium',
        questionCount: 10,
        durationMinutes: 30,
        xpReward: 100,
        description: 'Latihan soal aljabar untuk kelas 11',
        createdAt: DateTime(2024, 1, 1),
      ),
      Quiz(
        id: 'quiz_2',
        title: 'Latihan Fisika - Kinematika',
        subject: 'Fisika',
        subjectCode: 'FIS',
        difficulty: 'hard',
        questionCount: 15,
        durationMinutes: 45,
        xpReward: 150,
        description: 'Soal kinematika gerak lurus dan parabola',
        createdAt: DateTime(2024, 1, 2),
      ),
      Quiz(
        id: 'quiz_3',
        title: 'Latihan Biologi - Sel',
        subject: 'Biologi',
        subjectCode: 'BIO',
        difficulty: 'easy',
        questionCount: 10,
        durationMinutes: 20,
        xpReward: 80,
        description: 'Mengenal struktur dan fungsi sel',
        createdAt: DateTime(2024, 1, 3),
      ),
    ];

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      ApiEndpoints.quizList,
      queryParameters: {
        if (subjectCode != null) 'subject': subjectCode,
        if (difficulty != null) 'difficulty': difficulty,
      },
    );
    return (response['quizzes'] as List)
        .map((q) => Quiz.fromJson(q))
        .toList();
    */
  }

  /// Get quiz details by ID.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<Quiz?> getQuizById(String quizId) async {
    // ⚠️ PLACEHOLDER - Return null
    await Future.delayed(const Duration(milliseconds: 500));

    return null;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      ApiEndpoints.quizDetail.replaceFirst('{quizId}', quizId),
    );
    return Quiz.fromJson(response['quiz']);
    */
  }

  /// Get quiz questions.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<List<QuizQuestion>> getQuizQuestions(String quizId) async {
    // ⚠️ PLACEHOLDER - Return mock questions
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const QuizQuestion(
        id: 'q1',
        question: 'Jika 2x + 3 = 11, maka nilai x adalah...',
        options: ['2', '3', '4', '5'],
        correctIndex: 2,
        explanation: '2x + 3 = 11 → 2x = 8 → x = 4',
      ),
      const QuizQuestion(
        id: 'q2',
        question: 'Rumus luas lingkaran adalah...',
        options: ['πr', 'πr²', '2πr', 'πd'],
        correctIndex: 1,
        explanation: 'Luas lingkaran = π × r²',
      ),
    ];

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      '${ApiEndpoints.quizDetail}/$quizId/questions',
    );
    return (response['questions'] as List)
        .map((q) => QuizQuestion.fromJson(q))
        .toList();
    */
  }

  /// Submit quiz answers.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<QuizResult> submitQuiz({
    required String quizId,
    required String userId,
    required List<int> selectedAnswers,
    required Duration timeSpent,
  }) async {
    // ⚠️ PLACEHOLDER - Calculate mock result
    await Future.delayed(const Duration(seconds: 1));

    // Calculate mock score
    final correctCount = selectedAnswers.where((a) => a == 0).length;
    final total = selectedAnswers.length;
    final score = (correctCount / total * 100).round();
    final xpEarned = (score / 100 * 100).round();

    return QuizResult(
      id: 'result_${DateTime.now().millisecondsSinceEpoch}',
      quizId: quizId,
      userId: userId,
      selectedAnswers: selectedAnswers,
      correctCount: correctCount,
      score: score,
      xpEarned: xpEarned,
      completedAt: DateTime.now(),
      timeSpent: timeSpent,
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      ApiEndpoints.quizSubmit.replaceFirst('{quizId}', quizId),
      {
        'userId': userId,
        'answers': selectedAnswers,
        'timeSpentSeconds': timeSpent.inSeconds,
      },
    );
    return QuizResult.fromJson(response['result']);
    */
  }

  /// Get quiz result by ID.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<QuizResult?> getQuizResult(String resultId) async {
    // ⚠️ PLACEHOLDER - Return null
    await Future.delayed(const Duration(milliseconds: 500));

    return null;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      ApiEndpoints.quizResult.replaceFirst('{quizId}', resultId),
    );
    return QuizResult.fromJson(response['result']);
    */
  }

  /// Get user's quiz history.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<List<QuizResult>> getQuizHistory(String userId) async {
    // ⚠️ PLACEHOLDER - Return empty list
    await Future.delayed(const Duration(milliseconds: 500));

    return [];

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      '${ApiEndpoints.quizList}/history?userId=$userId',
    );
    return (response['results'] as List)
        .map((r) => QuizResult.fromJson(r))
        .toList();
    */
  }
}

/// Repository for Leaderboard operations.
class LeaderboardRepository {
  final ApiClient _apiClient;

  LeaderboardRepository(this._apiClient);

  /// Get leaderboard entries.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<List<LeaderboardEntry>> getLeaderboard({
    String? timeframe, // 'daily', 'weekly', 'monthly', 'alltime'
    int limit = 50,
  }) async {
    // ⚠️ PLACEHOLDER - Return mock leaderboard
    await Future.delayed(const Duration(milliseconds: 500));

    return List.generate(
      limit,
      (index) => LeaderboardEntry(
        id: 'user_$index',
        userId: 'user_$index',
        userName: 'User ${index + 1}',
        schoolName: 'SMA Negeri ${index + 1}',
        rank: index + 1,
        xp: 10000 - (index * 100),
        level: 10 - (index ~/ 5),
        badges: 5 - (index ~/ 10),
        lastActiveAt: DateTime.now(),
      ),
    );

    // TODO: Uncomment when backend is ready
    /*
    final endpoint = timeframe == 'weekly'
        ? ApiEndpoints.leaderboardWeekly
        : timeframe == 'monthly'
            ? ApiEndpoints.leaderboardMonthly
            : ApiEndpoints.leaderboard;

    final response = await _apiClient.get(
      endpoint,
      queryParameters: {'limit': limit},
    );
    return (response['entries'] as List)
        .map((e) => LeaderboardEntry.fromJson(e))
        .toList();
    */
  }

  /// Get user's rank on leaderboard.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<int?> getUserRank(String userId) async {
    // ⚠️ PLACEHOLDER - Return null
    await Future.delayed(const Duration(milliseconds: 500));

    return null;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      '${ApiEndpoints.leaderboard}/rank?userId=$userId',
    );
    return response['rank'] as int?;
    */
  }

  /// Get user's profile with stats.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<UserProfile> getUserProfile(String userId) async {
    // ⚠️ PLACEHOLDER - Return mock profile
    await Future.delayed(const Duration(milliseconds: 500));

    return UserProfile(
      userId: userId,
      name: 'Test User',
      email: 'user@studybuddy.id',
      schoolName: 'SMA Negeri 1 Example',
      gradeLevel: '11',
      xp: 1500,
      level: 5,
      badges: 3,
      quizzesCompleted: 25,
      averageScore: 85,
      learningStyle: 'visual',
      joinedAt: DateTime(2024, 1, 1),
      lastActiveAt: DateTime.now(),
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      ApiEndpoints.userStats.replaceFirst('{userId}', userId),
    );
    return UserProfile.fromJson(response['profile']);
    */
  }
}

/// Providers for repositories.
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.watch(apiClientProvider));
});

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(ref.watch(apiClientProvider));
});
