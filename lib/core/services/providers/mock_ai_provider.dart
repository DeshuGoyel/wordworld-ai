import 'dart:typed_data';
import 'dart:math';
import '../ai_provider.dart';

/// Mock AI provider for testing and offline mode.
/// Returns realistic dummy data for all AI capabilities.
class MockAIProvider extends AIProvider {
  @override
  String get name => 'Mock AI';
  @override
  AIProviderType get type => AIProviderType.mock;

  final _random = Random();

  // ─── Text ───
  @override
  Future<String> generateText(String prompt, {AIConfig? config}) async {
    await _delay();
    if (prompt.toLowerCase().contains('encourage')) {
      return _randomEncouragement();
    }
    if (prompt.toLowerCase().contains('hint')) {
      return 'Try looking at the shape carefully! You can do it! 🌟';
    }
    return 'This is a mock AI response for: ${prompt.substring(0, prompt.length.clamp(0, 50))}';
  }

  // ─── Chat ───
  @override
  Future<String> chat(List<ChatMessage> messages, {AIConfig? config}) async {
    await _delay();
    final last = messages.isNotEmpty ? messages.last.content : '';
    if (last.toLowerCase().contains('hello') || last.toLowerCase().contains('hi')) {
      return "Hi there! I'm Buddy, your learning friend! 🧸 What would you like to learn today?";
    }
    if (last.toLowerCase().contains('letter')) {
      return "Letters are so cool! Each letter has its own special sound. Which letter would you like to explore? 🔤";
    }
    if (last.toLowerCase().contains('help')) {
      return "Of course I'll help you! That's what friends are for! 💪 What do you need help with?";
    }
    return "That's a great question! Let me think... 🤔 I think you're doing amazing! Keep learning! ⭐";
  }

  @override
  Stream<String> chatStream(List<ChatMessage> messages, {AIConfig? config}) async* {
    final response = await chat(messages, config: config);
    final words = response.split(' ');
    for (final word in words) {
      await Future.delayed(const Duration(milliseconds: 80));
      yield '$word ';
    }
  }

  // ─── Image Generation ───
  @override
  Future<Uint8List> generateImage(String prompt, {int width = 512, int height = 512}) async {
    await _delay(ms: 500);
    // Return a tiny 1x1 placeholder PNG
    return _placeholderPng();
  }

  // ─── Image Animation ───
  @override
  Future<Uint8List> animateImage(Uint8List imageData, String motionPrompt) async {
    await _delay(ms: 800);
    return imageData; // Return same image as "animated" placeholder
  }

  // ─── Vision / Image Analysis ───
  @override
  Future<String> analyzeImage(Uint8List imageData, String question) async {
    await _delay();
    if (question.toLowerCase().contains('handwriting') || question.toLowerCase().contains('trace')) {
      final score = _random.nextInt(3) + 3; // 3-5
      return '{"score": $score, "feedback": "Great effort! Your letter shapes are getting better. Try to keep the lines smoother.", "stars": ${(score / 5 * 3).round()}}';
    }
    if (question.toLowerCase().contains('draw')) {
      return '{"score": 4, "feedback": "Wonderful drawing! I can see the details you added. Keep it up!", "stars": 2}';
    }
    return '{"label": "object", "confidence": 0.85, "description": "I can see something interesting in this image!"}';
  }

  // ─── Speech-to-Text ───
  @override
  Future<String> transcribeAudio(Uint8List audioData, {String? language}) async {
    await _delay();
    // Return mock transcription
    final mockWords = ['apple', 'ball', 'cat', 'dog', 'elephant', 'fish', 'grapes', 'hat'];
    return mockWords[_random.nextInt(mockWords.length)];
  }

  // ─── Speech Generation ───
  @override
  Future<Uint8List> generateSpeech(String text, {String? voice, String? language}) async {
    await _delay(ms: 300);
    return Uint8List(0); // Empty audio, app falls back to flutter_tts
  }

  // ─── Video Generation ───
  @override
  Future<Uint8List> generateVideo(String prompt, {int durationSeconds = 10}) async {
    await _delay(ms: 1000);
    return Uint8List(0); // Placeholder
  }

  // ─── Video Understanding ───
  @override
  Future<String> analyzeVideo(Uint8List videoData, String question) async {
    await _delay();
    return 'The video shows a learning activity. The child appears to be engaged and making good progress!';
  }

  // ─── Advanced Reasoning ───
  @override
  Future<String> reason(String prompt, {AIConfig? config}) async {
    await _delay(ms: 800);
    if (prompt.toLowerCase().contains('learning path')) {
      return '{"recommended": ["letter_B_word_2", "letter_C_word_1", "letter_A_word_3"], "reason": "Focus on letters the child found challenging, building on strengths in visual recognition."}';
    }
    if (prompt.toLowerCase().contains('weakness') || prompt.toLowerCase().contains('weak')) {
      return '{"areas": ["Writing - letter formation needs practice", "Speaking - pronunciation of consonants"], "plan": "Increase Write tab activities, add more Talk tab practice for B, D, G sounds."}';
    }
    return '{"analysis": "The child is progressing well overall. Recommend introducing the next letter group.", "confidence": 0.8}';
  }

  // ─── Fast Response ───
  @override
  Future<String> fastResponse(String prompt, {AIConfig? config}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (prompt.toLowerCase().contains('hint')) {
      final hints = [
        'Look at the colors! 🌈',
        'Try the one that looks different! 👀',
        'Sound it out: what does it start with? 🔊',
        'You\'re so close! Try again! 💪',
      ];
      return hints[_random.nextInt(hints.length)];
    }
    return _randomEncouragement();
  }

  // ─── Helpers ───
  Future<void> _delay({int ms = 200}) => Future.delayed(Duration(milliseconds: ms));

  String _randomEncouragement() {
    final phrases = [
      'Amazing job! You\'re a star! ⭐',
      'Wow, you\'re so smart! 🧠',
      'Keep going, you\'re doing great! 🚀',
      'Fantastic work! I\'m so proud! 🎉',
      'You\'re learning so fast! 💫',
      'Brilliant! You nailed it! 🏆',
    ];
    return phrases[_random.nextInt(phrases.length)];
  }

  Uint8List _placeholderPng() {
    // Minimal 1x1 transparent PNG
    return Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00,
      0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00,
      0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89,
      0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x62,
      0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0xE5, 0x27, 0xDE, 0xFC, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
    ]);
  }
}
