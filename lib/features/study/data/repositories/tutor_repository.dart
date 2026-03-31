import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';

/// Repository for Socratic AI Tutor.
class TutorRepository {
  final ApiClient _apiClient;

  TutorRepository(this._apiClient);

  /// Send a message to the Socratic tutor and get a response.
  ///
  /// ⚠️ TODO: Implement actual API call to your backend
  /// Your backend should forward the request to Google Gemini API
  /// with the Socratic prompt template.
  ///
  /// Socratic Prompt Template:
  /// ```
  /// You are a Socratic Tutor for Indonesian high school students.
  /// NEVER give the answer directly.
  /// If a student is stuck, ask a leading question.
  /// Context: Indonesian High School curriculum (Kurikulum Merdeka/K13).
  /// Language: Indonesian (Bahasa Indonesia).
  /// ```
  Future<ChatMessage> sendMessage({
    required String sessionId,
    required String message,
    String? subject,
    ChatMessage? context,
  }) async {
    // ⚠️ PLACEHOLDER - Simulate AI response
    await Future.delayed(const Duration(seconds: 2));

    // Mock Socratic responses (replace with actual Gemini API call)
    final mockResponses = [
      'Pertanyaan yang bagus! 🤔 Coba kamu pikirkan dulu, apa yang kamu ketahui tentang topik ini?',
      'Menarik! Sebelum aku bantu, bisa kamu jelaskan apa yang sudah kamu coba?',
      'Hebat sudah bertanya! 💪 Mari kita pikirkan bersama. Apa langkah pertama yang bisa kamu ambil?',
      'Good thinking! Coba kamu ingat-ingat, apakah ada konsep serupa yang sudah kamu pelajari sebelumnya?',
      'Pertanyaan bagus! 📚 Daripada aku kasih jawaban langsung, bagaimana kalau kita bahas konsep dasarnya dulu?',
    ];

    return ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: mockResponses[DateTime.now().millisecond % mockResponses.length],
      isUser: false,
      timestamp: DateTime.now(),
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      ApiEndpoints.tutorChat,
      {
        'sessionId': sessionId,
        'message': message,
        'subject': subject,
        'context': context?.content,
      },
    );
    return ChatMessage.fromJson(response['message']);
    */
  }

  /// Send a message with image (for math problems, diagrams, etc.).
  ///
  /// ⚠️ TODO: Implement actual API call with Google Gemini Vision
  Future<ChatMessage> sendMessageWithImage({
    required String sessionId,
    required String message,
    required String imagePath,
    String? subject,
  }) async {
    // ⚠️ PLACEHOLDER - Simulate AI response with image analysis
    await Future.delayed(const Duration(seconds: 3));

    return ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content:
          'Aku lihat gambarnya! 📸 Pertanyaan yang menarik. Coba kamu jelaskan apa yang kamu ketahui tentang soal ini?',
      isUser: false,
      timestamp: DateTime.now(),
      imageUrl: imagePath,
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.uploadFile(
      ApiEndpoints.tutorChat,
      imagePath,
      additionalData: {
        'sessionId': sessionId,
        'message': message,
        'subject': subject,
      },
    );
    return ChatMessage.fromJson(response['message']);
    */
  }

  /// Create a new chat session.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<ChatSession> createSession({
    required String userId,
    required String title,
    required String subject,
  }) async {
    // ⚠️ PLACEHOLDER - Create local session
    await Future.delayed(const Duration(milliseconds: 500));

    return ChatSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: title,
      subject: subject,
      messages: [],
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      ApiEndpoints.tutorSessions,
      {
        'userId': userId,
        'title': title,
        'subject': subject,
      },
    );
    return ChatSession.fromJson(response['session']);
    */
  }

  /// Get chat session history.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<List<ChatSession>> getSessions(String userId) async {
    // ⚠️ PLACEHOLDER - Return empty list
    await Future.delayed(const Duration(milliseconds: 500));

    return [];

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      '${ApiEndpoints.tutorSessions}?userId=$userId',
    );
    return (response['sessions'] as List)
        .map((s) => ChatSession.fromJson(s))
        .toList();
    */
  }

  /// Get a specific chat session with messages.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<ChatSession?> getSessionById(String sessionId) async {
    // ⚠️ PLACEHOLDER - Return null
    await Future.delayed(const Duration(milliseconds: 500));

    return null;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      ApiEndpoints.tutorSessionDetail.replaceFirst('{sessionId}', sessionId),
    );
    return ChatSession.fromJson(response['session']);
    */
  }

  /// Delete a chat session.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<void> deleteSession(String sessionId) async {
    // ⚠️ PLACEHOLDER - No-op
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Uncomment when backend is ready
    /*
    await _apiClient.delete(
      ApiEndpoints.tutorSessionDetail.replaceFirst('{sessionId}', sessionId),
    );
    */
  }

  /// Clear conversation history (context management).
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<void> clearHistory(String sessionId) async {
    // ⚠️ PLACEHOLDER - No-op
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Uncomment when backend is ready
    /*
    await _apiClient.post(
      '${ApiEndpoints.tutorSessions}/$sessionId/clear',
      null,
    );
    */
  }
}

/// Provider for the tutor repository.
final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  return TutorRepository(ref.watch(apiClientProvider));
});

/// Google Gemini API service (direct integration option).
///
/// Use this if you want to call Gemini API directly from the app
/// instead of going through your backend.
class GeminiApiService {
  final ApiClient _geminiClient;

  GeminiApiService()
    : _geminiClient = ApiClient(baseUrl: ApiConfig.geminiBaseUrl);

  /// Generate text using Gemini API.
  ///
  /// ⚠️ TODO: Add your Gemini API key in api_config.dart
  Future<String> generateText({
    required String prompt,
    String? systemInstruction,
  }) async {
    // ⚠️ PLACEHOLDER - Direct Gemini API call
    //
    // TODO: Uncomment and add your Gemini API key:
    /*
    final apiKey = ApiConfig.geminiApiKey;
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not configured!');
    }

    final response = await _geminiClient.post(
      '/models/${ApiConfig.geminiModel}:generateContent?key=$apiKey',
      {
        'contents': [
          {
            'parts': [
              {'text': systemInstruction != null ? '$systemInstruction\n\n$prompt' : prompt},
            ],
          },
        ],
      },
    );

    return response['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
    */

    throw UnimplementedError(
      'Gemini API not implemented. Add your API key in api_config.dart',
    );
  }
}

/// Provider for Gemini API service.
final geminiApiServiceProvider = Provider<GeminiApiService>((ref) {
  return GeminiApiService();
});
