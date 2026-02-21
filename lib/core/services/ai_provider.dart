import 'dart:typed_data';

/// Chat message for multi-turn conversations
class ChatMessage {
  final String role; // 'user', 'assistant', 'system'
  final String content;
  final Uint8List? imageData;

  const ChatMessage({required this.role, required this.content, this.imageData});
}

/// AI generation config
class AIConfig {
  final double temperature;
  final int maxTokens;
  final String? systemPrompt;

  const AIConfig({
    this.temperature = 0.7,
    this.maxTokens = 1024,
    this.systemPrompt,
  });
}

/// Supported AI providers
enum AIProviderType { openai, gemini, anthropic, mock }

/// Abstract interface for all AI capabilities.
/// Implementations: OpenAIProvider, GeminiProvider, AnthropicProvider, MockAIProvider
abstract class AIProvider {
  String get name;
  AIProviderType get type;

  // ─── Text Generation ───
  Future<String> generateText(String prompt, {AIConfig? config});

  // ─── Chat / Chatbot ───
  Future<String> chat(List<ChatMessage> messages, {AIConfig? config});
  Stream<String> chatStream(List<ChatMessage> messages, {AIConfig? config});

  // ─── Image Generation ───
  Future<Uint8List> generateImage(String prompt, {int width, int height});

  // ─── Image Animation ───
  Future<Uint8List> animateImage(Uint8List imageData, String motionPrompt);

  // ─── Image Analysis / Vision ───
  Future<String> analyzeImage(Uint8List imageData, String question);

  // ─── Speech-to-Text ───
  Future<String> transcribeAudio(Uint8List audioData, {String? language});

  // ─── Speech / Audio Generation ───
  Future<Uint8List> generateSpeech(String text, {String? voice, String? language});

  // ─── Video Generation ───
  Future<Uint8List> generateVideo(String prompt, {int durationSeconds});

  // ─── Video Understanding ───
  Future<String> analyzeVideo(Uint8List videoData, String question);

  // ─── Advanced Reasoning ───
  Future<String> reason(String prompt, {AIConfig? config});

  // ─── Fast Response ───
  Future<String> fastResponse(String prompt, {AIConfig? config});

  // ─── Dispose ───
  void dispose() {}
}
