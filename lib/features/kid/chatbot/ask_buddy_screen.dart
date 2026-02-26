import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/app_providers.dart';

/// "Ask Buddy" — AI chatbot screen for kids.
/// Features a friendly character, voice input, and simple chat interface.
class AskBuddyScreen extends ConsumerStatefulWidget {
  final int childAge;
  const AskBuddyScreen({super.key, this.childAge = 4});

  @override
  ConsumerState<AskBuddyScreen> createState() => _AskBuddyScreenState();
}

class _AskBuddyScreenState extends ConsumerState<AskBuddyScreen>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatBubble> _messages = [];
  bool _isTyping = false;
  late AnimationController _bounceController;
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // Welcome message
    _messages.add(_ChatBubble(
      text: 'Hi there! I\'m Buddy! 🧸\nWhat would you like to learn today?',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _bounceController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (await Permission.microphone.request().isGranted) {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        setState(() => _isRecording = false);
        if (path != null) {
          setState(() => _isTyping = true); // Show typing while transcribing
          try {
            final bytes = await File(path).readAsBytes();
            final text = await ref.read(sttServiceProvider).transcribe(bytes);
            setState(() => _isTyping = false);
            if (text.isNotEmpty) {
              _sendMessage(text);
            }
          } catch (e) {
            setState(() => _isTyping = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to transcribe audio. Please try again.')),
            );
          }
        }
      } else {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/buddy_mic.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
        setState(() => _isRecording = true);
      }
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatBubble(text: text, isUser: true));
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    // Simulate AI response (use AIService in real implementation)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(_ChatBubble(
            text: _mockResponse(text),
            isUser: false,
          ));
        });
        _scrollToBottom();
      }
    });
  }

  String _mockResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi')) {
      return 'Hello, friend! 🌟 Ready to learn something awesome?';
    }
    if (lower.contains('letter') || lower.contains('alphabet')) {
      return 'Letters are so cool! Each one has a special sound 🔤 Which letter do you want to explore?';
    }
    if (lower.contains('favorite') || lower.contains('like')) {
      return 'I love learning about animals! 🦁 Did you know "Lion" starts with L?';
    }
    if (lower.contains('help')) {
      return 'Of course! I\'m here to help! 💪 You can ask me about letters, words, or animals!';
    }
    if (lower.contains('thank')) {
      return 'You\'re welcome! You\'re such a great learner! ⭐';
    }
    return 'That\'s interesting! 🤔 Did you know there are 26 letters in the alphabet? Keep learning! 🚀';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🧸', style: TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ask Buddy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Your learning friend', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Suggested questions
          if (_messages.length <= 1) _buildSuggestions(),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[i]);
              },
            ),
          ),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final suggestions = [
      '🔤 Teach me a letter!',
      '🦁 Tell me about animals',
      '🎵 Sing a song!',
      '🌈 What colors are there?',
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((s) => ActionChip(
          label: Text(s, style: const TextStyle(fontSize: 13)),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          onPressed: () => _sendMessage(s),
        )).toList(),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatBubble msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser)
            Container(
              width: 32, height: 32, margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🧸', style: TextStyle(fontSize: 16))),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: msg.isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(msg.isUser ? 20 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  fontSize: 15,
                  color: msg.isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (msg.isUser)
            Container(
              width: 32, height: 32, margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('👦', style: TextStyle(fontSize: 16))),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32, height: 32, margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('🧸', style: TextStyle(fontSize: 16))),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _bounceController,
                  builder: (_, __) => Container(
                    margin: EdgeInsets.only(left: i > 0 ? 4 : 0),
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.3 + _bounceController.value * 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Mic button (voice input)
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: _isRecording ? AppColors.error : AppColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: _isRecording ? Colors.white : AppColors.secondary,
                ),
                onPressed: _toggleRecording,
              ),
            ),
            const SizedBox(width: 8),
            // Text input
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Ask Buddy anything...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: () => _sendMessage(_controller.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble {
  final String text;
  final bool isUser;
  _ChatBubble({required this.text, required this.isUser});
}
