import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/chat_model.dart';
import '../../data/repositories/tutor_repository.dart';

/// State for Socratic Tutor chat.
class TutorState {
  final String? sessionId;
  final String title;
  final String subject;
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;

  const TutorState({
    this.sessionId,
    this.title = 'Socratic Tutor',
    this.subject = 'Umum',
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  TutorState copyWith({
    String? sessionId,
    String? title,
    String? subject,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return TutorState(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error ?? this.error,
    );
  }

  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;
}

/// Notifier for Socratic Tutor state management.
class TutorNotifier extends StateNotifier<TutorState> {
  final TutorRepository _tutorRepository;

  TutorNotifier(this._tutorRepository) : super(const TutorState());

  /// Create a new chat session.
  Future<void> createSession({
    required String userId,
    String title = 'Socratic Tutor',
    String subject = 'Umum',
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await _tutorRepository.createSession(
        userId: userId,
        title: title,
        subject: subject,
      );

      state = state.copyWith(
        sessionId: session.id,
        title: session.title,
        subject: session.subject,
        messages: session.messages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal membuat sesi: $e');
    }
  }

  /// Send a message to the tutor.
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty || state.sessionId == null) return;

    state = state.copyWith(isSending: true, error: null);

    // Add user message immediately
    final userMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(messages: [...state.messages, userMessage]);

    try {
      // Get AI response
      final response = await _tutorRepository.sendMessage(
        sessionId: state.sessionId!,
        message: message,
        subject: state.subject,
        context: state.lastMessage,
      );

      state = state.copyWith(
        messages: [...state.messages, response],
        isSending: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: 'Gagal mengirim pesan: $e',
      );
    }
  }

  /// Send a message with image.
  Future<void> sendMessageWithImage({
    required String message,
    required String imagePath,
  }) async {
    if (message.trim().isEmpty || state.sessionId == null) return;

    state = state.copyWith(isSending: true, error: null);

    // Add user message with image
    final userMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
      imageUrl: imagePath,
    );

    state = state.copyWith(messages: [...state.messages, userMessage]);

    try {
      // Get AI response
      final response = await _tutorRepository.sendMessageWithImage(
        sessionId: state.sessionId!,
        message: message,
        imagePath: imagePath,
        subject: state.subject,
      );

      state = state.copyWith(
        messages: [...state.messages, response],
        isSending: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: 'Gagal mengirim gambar: $e',
      );
    }
  }

  /// Load chat history.
  Future<void> loadHistory(String sessionId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await _tutorRepository.getSessionById(sessionId);

      if (session != null) {
        state = state.copyWith(
          sessionId: session.id,
          title: session.title,
          subject: session.subject,
          messages: session.messages,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false, error: 'Sesi tidak ditemukan');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Gagal memuat riwayat: $e',
      );
    }
  }

  /// Clear chat history.
  Future<void> clearHistory() async {
    if (state.sessionId == null) return;

    try {
      await _tutorRepository.clearHistory(state.sessionId!);
      state = state.copyWith(messages: []);
    } catch (e) {
      state = state.copyWith(error: 'Gagal menghapus riwayat: $e');
    }
  }

  /// Reset the tutor state.
  void reset() {
    state = const TutorState();
  }

  /// Update subject.
  void setSubject(String subject) {
    state = state.copyWith(subject: subject);
  }
}

/// Provider for tutor notifier.
final tutorNotifierProvider = StateNotifierProvider<TutorNotifier, TutorState>((
  ref,
) {
  return TutorNotifier(ref.watch(tutorRepositoryProvider));
});
