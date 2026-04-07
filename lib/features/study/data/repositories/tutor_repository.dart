// ════════════════════════════════════════════════════════════════════════════
// 🤖 TUTOR REPOSITORY — Google Gemini AI Integration
// ════════════════════════════════════════════════════════════════════════════
//
// Socratic AI Tutor using Google Gemini API.
//
// Features:
// - Text-based Socratic tutoring (never give direct answers)
// - Image-based problem solving (Gemini Vision)
// - Context-aware conversations
// - Indonesian curriculum context (Kurikulum Merdeka/K13)
//
// Architecture:
// - Direct Gemini API calls (for MVP)
// - Production: Route through NestJS backend to hide API key
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/providers/api_providers.dart';

/// Repository for Socratic AI Tutor.
///
/// Uses Google Gemini API for AI-powered tutoring with Socratic method.
class TutorRepository {
  final ApiClient _apiClient;
  final ApiClient _geminiClient;

  TutorRepository(this._apiClient, this._geminiClient);

  /// Send a message to the Socratic tutor and get a response.
  ///
  /// Uses Gemini API with Socratic prompt template.
  ///
  /// [sessionId] - Chat session identifier
  /// [message] - Student's question/message
  /// [subject] - Subject context (e.g., "Matematika", "Fisika")
  /// [context] - Previous message for continuity
  Future<ChatMessage> sendMessage({
    required String sessionId,
    required String message,
    String? subject,
    ChatMessage? context,
  }) async {
    try {
      // Build the prompt with Socratic instructions
      final prompt = _buildSocraticPrompt(
        message: message,
        subject: subject,
        context: context,
      );

      // Call Gemini API
      final response = await _geminiClient.post(
        '/models/${ApiConfig.geminiModel}:generateContent',
        {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 512,
          },
        },
        queryParameters: {'key': ApiConfig.geminiApiKey},
      );

      // Extract AI response
      final aiText = _extractGeminiResponse(response);

      return ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        content: aiText,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[TutorRepository] Send message error: $e');
      throw Exception('Failed to get tutor response: $e');
    }
  }

  /// Send a message with image (for math problems, diagrams, etc.).
  ///
  /// Uses Gemini Vision API for image analysis + Socratic tutoring.
  Future<ChatMessage> sendMessageWithImage({
    required String sessionId,
    required String message,
    required String imagePath,
    String? subject,
  }) async {
    try {
      // Read and encode image
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Detect MIME type
      final mimeType = _getMimeType(imagePath);

      // Build multimodal prompt
      final prompt = _buildSocraticPrompt(
        message: message,
        subject: subject,
        context: null,
        hasImage: true,
      );

      // Call Gemini Vision API
      final response = await _geminiClient.post(
        '/models/${ApiConfig.geminiVisionModel}:generateContent',
        {
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inline_data': {'mime_type': mimeType, 'data': base64Image},
                },
              ],
            },
          ],
          'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 512},
        },
        queryParameters: {'key': ApiConfig.geminiApiKey},
      );

      final aiText = _extractGeminiResponse(response);

      return ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        content: aiText,
        isUser: false,
        timestamp: DateTime.now(),
        imageUrl: imagePath,
      );
    } catch (e) {
      debugPrint('[TutorRepository] Send image message error: $e');
      throw Exception('Failed to analyze image: $e');
    }
  }

  /// Create a new chat session.
  ///
  /// For MVP: Creates local session.
  /// Production: Save to MongoDB via backend.
  Future<ChatSession> createSession({
    required String userId,
    required String title,
    required String subject,
  }) async {
    // MVP: Create local session
    // TODO: Call backend API to save session to MongoDB
    return ChatSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: title,
      subject: subject,
      messages: [],
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
    );
  }

  /// Get chat session history.
  ///
  /// TODO: Fetch from MongoDB via backend.
  Future<List<ChatSession>> getSessions(String userId) async {
    // MVP: Return empty list
    // TODO: Call GET /tutor/sessions?userId=$userId
    return [];
  }

  /// Get a specific chat session with messages.
  ///
  /// TODO: Fetch from MongoDB via backend.
  Future<ChatSession?> getSessionById(String sessionId) async {
    // MVP: Return null
    // TODO: Call GET /tutor/sessions/{sessionId}
    return null;
  }

  /// Delete a chat session.
  ///
  /// TODO: Delete from MongoDB via backend.
  Future<void> deleteSession(String sessionId) async {
    // MVP: No-op
    // TODO: Call DELETE /tutor/sessions/{sessionId}
  }

  /// Clear conversation history (context management).
  ///
  /// TODO: Clear from MongoDB via backend.
  Future<void> clearHistory(String sessionId) async {
    // MVP: No-op
    // TODO: Call POST /tutor/sessions/{sessionId}/clear
  }

  /// Build Socratic prompt with context.
  String _buildSocraticPrompt({
    required String message,
    String? subject,
    ChatMessage? context,
    bool hasImage = false,
  }) {
    final buffer = StringBuffer();

    // System instruction (Socratic method)
    buffer.writeln(ApiConfig.socraticPrompt);
    buffer.writeln();

    // Add subject context if provided
    if (subject != null) {
      buffer.writeln('Subject: $subject');
      buffer.writeln();
    }

    // Add image context if present
    if (hasImage) {
      buffer.writeln('[Student sent an image related to the question]');
      buffer.writeln();
    }

    // Add conversation context if available
    if (context != null) {
      buffer.writeln('Previous conversation:');
      buffer.writeln('Student: ${context.content}');
      buffer.writeln();
    }

    // Student's current question
    buffer.writeln('Student: $message');
    buffer.writeln();
    buffer.writeln('Tutor: ');

    return buffer.toString();
  }

  /// Extract text response from Gemini API response.
  String _extractGeminiResponse(Map<String, dynamic> response) {
    try {
      final candidates = response['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return 'Maaf, aku sedang kesulitan memahami pertanyaanmu. Bisa kamu ulangi dengan lebih jelas?';
      }

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;

      if (parts == null || parts.isEmpty) {
        return 'Maaf, aku tidak bisa memberikan jawaban saat ini. Mari kita coba lagi!';
      }

      final text = parts[0]['text'] as String?;
      return text ?? 'Pertanyaan menarik! Mari kita pikirkan bersama-sama.';
    } catch (e) {
      debugPrint('[TutorRepository] Extract response error: $e');
      return 'Terima kasih atas pertanyaannya! Bisakah kamu menjelaskan lebih detail apa yang ingin kamu pelajari?';
    }
  }

  /// Get MIME type from file extension.
  String _getMimeType(String path) {
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'image/jpeg';
    if (path.endsWith('.gif')) return 'image/gif';
    if (path.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg'; // Default
  }
}

/// Provider for the tutor repository.
final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  return TutorRepository(
    ref.watch(apiClientProvider),
    ApiClient(baseUrl: ApiConfig.geminiBaseUrl),
  );
});
