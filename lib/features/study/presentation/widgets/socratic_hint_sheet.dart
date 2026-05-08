// ════════════════════════════════════════════════════════════════════════════
// 💬 SOCRATIC HINT SHEET — Interactive AI Tutoring Bottom Sheet
// ════════════════════════════════════════════════════════════════════════════
//
// Opens as a ModalBottomSheet when the student taps "Hint" on a quiz question.
//
// Flow:
// 1. Sheet opens → auto-requests first Socratic hint from Gemini AI
// 2. AI responds with a leading question (never direct answer)
// 3. Student can type follow-up questions (counts toward hint limit)
// 4. Max 3 AI responses per question
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/chat_model.dart';
import '../../domain/providers/practice_provider.dart';
import '../../../subscription/data/subscription_provider.dart';
import '../../../subscription/presentation/subscription_screen.dart';

/// Shows the Socratic Hint bottom sheet.
///
/// Call via:
/// ```dart
/// showSocraticHintSheet(context, ref, questionIndex, questionText, subject);
/// ```
void showSocraticHintSheet(
  BuildContext context,
  WidgetRef ref,
  int questionIndex,
  String questionText,
  String subject,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => ProviderScope(
      parent: ProviderScope.containerOf(context),
      child: SocraticHintSheet(
        questionIndex: questionIndex,
        questionText: questionText,
        subject: subject,
      ),
    ),
  );
}

/// The actual Socratic hint bottom sheet widget.
class SocraticHintSheet extends ConsumerStatefulWidget {
  final int questionIndex;
  final String questionText;
  final String subject;

  const SocraticHintSheet({
    super.key,
    required this.questionIndex,
    required this.questionText,
    required this.subject,
  });

  @override
  ConsumerState<SocraticHintSheet> createState() => _SocraticHintSheetState();
}

class _SocraticHintSheetState extends ConsumerState<SocraticHintSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Auto-request first hint if none exist yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(practiceNotifierProvider);
      final hintState =
          state.hintStates[widget.questionIndex] ?? const QuestionHintState();
      if (hintState.hints.isEmpty && !hintState.isLoading) {
        final subNotifier = ref.read(subscriptionProvider.notifier);
        if (subNotifier.canChat) {
          subNotifier.incrementAiChat();
          ref.read(practiceNotifierProvider.notifier).requestHint();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final subNotifier = ref.read(subscriptionProvider.notifier);
    if (!subNotifier.canChat) return;

    _controller.clear();
    FocusScope.of(context).unfocus();
    subNotifier.incrementAiChat();
    ref
        .read(practiceNotifierProvider.notifier)
        .requestHint(studentMessage: text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(practiceNotifierProvider);
    final hintState =
        state.hintStates[widget.questionIndex] ?? const QuestionHintState();
    final remaining = 3 - hintState.hintCount;

    // Auto-scroll when new content arrives
    if (hintState.hints.isNotEmpty && !hintState.isLoading) {
      _scrollToBottom();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundCream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ── Drag Handle ──────────────────────────────────────────────
              _buildDragHandle(),

              // ── Header ───────────────────────────────────────────────────
              _buildHeader(remaining),

              // ── Question Preview ─────────────────────────────────────────
              _buildQuestionPreview(),

              const Divider(height: 1, color: AppColors.divider),

              // ── Chat List ────────────────────────────────────────────────
              Expanded(child: _buildChatList(hintState)),

              // ── Input Bar ────────────────────────────────────────────────
              _buildInputBar(hintState, remaining),
            ],
          ),
        );
      },
    );
  }

  // ── Sub-widgets ────────────────────────────────────────────────────────────

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(int remaining) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 8, 12),
      child: Row(
        children: [
          // AI Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8C42), Color(0xFFFF6B2B)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),

          // Title + hint counter dots
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Tutor Socratic',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    ...List.generate(3, (i) {
                      final filled = i < (3 - remaining);
                      return Container(
                        margin: const EdgeInsets.only(right: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? AppColors.primaryOrange
                              : AppColors.divider,
                        ),
                      );
                    }),
                    const SizedBox(width: 6),
                    Text(
                      remaining > 0
                          ? '$remaining hint tersisa'
                          : 'Hint habis 🎯',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: remaining > 0
                            ? AppColors.aiSuggestionIcon
                            : Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Close button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPreview() {
    final preview = widget.questionText.length > 100
        ? '${widget.questionText.substring(0, 100)}...'
        : widget.questionText;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryOrangeLighter,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.aiSuggestionBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.help_outline_rounded,
            size: 16,
            color: AppColors.aiSuggestionIcon,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              preview,
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(QuestionHintState hintState) {
    // Show loading spinner if first hint is being fetched
    if (hintState.hints.isEmpty && hintState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primaryOrange,
              strokeWidth: 2,
            ),
            const SizedBox(height: 12),
            Text(
              'AI sedang berpikir...',
              style: GoogleFonts.nunito(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (hintState.hints.isEmpty) {
      return Center(
        child: Text(
          'Memuat petunjuk pertama...',
          style: GoogleFonts.nunito(color: AppColors.textLight),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      itemCount: hintState.hints.length + (hintState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == hintState.hints.length) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(hintState.hints[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar (left side)
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFFFF6B2B)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryOrange : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isUser
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
                border: isUser
                    ? null
                    : Border.all(color: AppColors.aiSuggestionBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: isUser ? Colors.white : AppColors.textPrimary,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Spacer on user side (keeps bubble from touching edge)
          if (isUser) const SizedBox(width: 30),
        ],
      ),
    );
  }

  /// Animated "..." typing indicator shown while AI is responding.
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF8C42), Color(0xFFFF6B2B)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.aiSuggestionBorder),
            ),
            child: const _TypingDots(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(QuestionHintState hintState, int remaining) {
    final subState = ref.watch(subscriptionProvider);

    if (!subState.isSubscribed) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Socratic AI Tutor Memerlukan Langganan',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Upgrade ke StudyBuddy PRO sekarang juga untuk mendapatkan Socratic AI Tutor tanpa batas, scan jadwal unlimited, & SNBT Premium!',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                  );
                },
                child: Text(
                  'Upgrade ke PRO — Rp 29.000/bln',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Can send if: hints remain AND not currently loading AND at least 1 hint shown
    final canSend =
        remaining > 0 && !hintState.isLoading && hintState.hints.isNotEmpty;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: canSend,
              onSubmitted: canSend ? (_) => _sendMessage() : null,
              textInputAction: TextInputAction.send,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: remaining == 0
                    ? 'Sudah 3 hint — semangat! 💪'
                    : 'Tanya balik AI...',
                hintStyle: GoogleFonts.nunito(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: AppColors.backgroundCream,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: canSend ? _sendMessage : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: canSend
                    ? const LinearGradient(
                        colors: [Color(0xFFFF8C42), Color(0xFFFF6B2B)],
                      )
                    : null,
                color: canSend ? null : AppColors.progressTrack,
                shape: BoxShape.circle,
                boxShadow: canSend
                    ? [
                        BoxShadow(
                          color: AppColors.primaryOrange.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.send_rounded,
                size: 18,
                color: canSend ? Colors.white : AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing Dots Animation ────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final phase = ((_controller.value - delay) % 1.0 + 1.0) % 1.0;
            final opacity = phase < 0.5 ? phase * 2 : (1.0 - phase) * 2;
            return Padding(
              padding: EdgeInsets.only(right: i < 2 ? 4 : 0),
              child: Opacity(
                opacity: opacity.clamp(0.2, 1.0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
