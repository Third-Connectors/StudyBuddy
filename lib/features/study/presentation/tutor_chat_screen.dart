import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/providers/tutor_provider.dart';
import '../data/models/chat_model.dart';

/// Socratic Tutor Chat Screen.
class TutorChatScreen extends ConsumerStatefulWidget {
  final String? sessionId;
  final String subject;

  const TutorChatScreen({super.key, this.sessionId, this.subject = 'Umum'});

  @override
  ConsumerState<TutorChatScreen> createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends ConsumerState<TutorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Set subject if provided
    if (widget.subject.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(tutorNotifierProvider.notifier).setSubject(widget.subject);
      });
    }

    // Create new session if no sessionId provided
    if (widget.sessionId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(tutorNotifierProvider.notifier)
            .createSession(
              userId: 'user_123', // TODO: Get from auth
              title: 'Socratic Tutor - ${widget.subject}',
              subject: widget.subject,
            );
      });
    } else {
      // Load existing session
      ref.read(tutorNotifierProvider.notifier).loadHistory(widget.sessionId!);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tutorNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              state.subject,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsDialog(context, state),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: state.messages.isEmpty
                ? _buildEmptyState()
                : _buildMessageList(state),
          ),

          // Error banner
          if (state.error != null) _buildErrorBanner(state.error!),

          // Input field
          _buildInputField(state),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Socratic Tutor',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Aku adalah tutor AI yang akan membantumu belajar dengan bertanya, bukan memberi jawaban langsung.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildExampleQuestion(
                  'Bagaimana cara menyelesaikan persamaan kuadrat?',
                ),
                const SizedBox(height: 8),
                _buildExampleQuestion(
                  'Jelaskan proses fotosintesis pada tumbuhan',
                ),
                const SizedBox(height: 8),
                _buildExampleQuestion(
                  'Apa perbedaan sel hewan dan sel tumbuhan?',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleQuestion(String question) {
    return InkWell(
      onTap: () {
        _messageController.text = question;
        _sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[100]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(question, style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(TutorState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.messages.length + (state.isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.messages.length) {
          return _buildTypingIndicator();
        }

        final message = state.messages[index];
        final isUser = message.isUser;
        final showAvatar =
            index == 0 || state.messages[index - 1].isUser != isUser;

        return _buildMessageBubble(message, isUser, showAvatar);
      },
    );
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    bool isUser,
    bool showAvatar,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser && showAvatar) ...[
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Text('🤖', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 8),
          ] else if (!isUser) ...[
            const SizedBox(width: 44),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Theme.of(context).primaryColor
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.file(
                              File(message.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        message.content,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          if (isUser && showAvatar) const SizedBox(width: 8),
          if (isUser && showAvatar)
            CircleAvatar(
              backgroundColor: Colors.green[100],
              child: const Text('👤', style: TextStyle(fontSize: 20)),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: const Text('🤖', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                _buildTypingDot(1),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -value * 4),
          child: Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red[50],
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 20, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.red),
            onPressed: () => ref.read(tutorNotifierProvider.notifier).reset(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(TutorState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Image attachment button
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.grey),
              onPressed: () => _showImageSourceDialog(),
              tooltip: 'Kirim gambar',
            ),

            // Text input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Tanya sesuatu...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send button
            CircleAvatar(
              backgroundColor: state.isSending
                  ? Colors.grey[300]
                  : Theme.of(context).primaryColor,
              child: state.isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _sendMessage,
                      tooltip: 'Kirim',
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    _focusNode.unfocus();
    ref.read(tutorNotifierProvider.notifier).sendMessage(message);
    _scrollToBottom();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: source);

      if (image != null) {
        Navigator.pop(context); // Close dialog
        ref
            .read(tutorNotifierProvider.notifier)
            .sendMessageWithImage(
              message: 'Bantu aku dengan soal ini',
              imagePath: image.path,
            );
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, TutorState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Topik Baru'),
              onTap: () {
                Navigator.pop(context);
                ref.read(tutorNotifierProvider.notifier).reset();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .read(tutorNotifierProvider.notifier)
                      .createSession(
                        userId: 'user_123',
                        title: 'Socratic Tutor',
                        subject: state.subject,
                      );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('Hapus Riwayat Chat'),
              onTap: () {
                Navigator.pop(context);
                _showClearHistoryDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Socratic Tutor'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat?'),
        content: const Text(
          'Semua pesan dalam sesi ini akan dihapus. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(tutorNotifierProvider.notifier).clearHistory();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Socratic Tutor'),
        content: const Text(
          'Socratic Tutor adalah AI yang dirancang untuk membantumu belajar dengan metode Socratic:\n\n'
          '• Tidak memberi jawaban langsung\n'
          '• Mengajukan pertanyaan pemandu\n'
          '• Membantumu memahami konsep\n'
          '• Tersedia 24/7 untuk semua mata pelajaran\n\n'
          'Powered by Google Gemini AI',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
