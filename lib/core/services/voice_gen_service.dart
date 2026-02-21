import 'dart:typed_data';
import 'ai_service.dart';

/// AI Voice / Speech Generation service.
/// Generates natural character voices, narrator, bilingual TTS.
class VoiceGenService {
  final AIService _ai;

  VoiceGenService(this._ai);

  /// Character voices for different roles
  static const Map<String, String> _voices = {
    'buddy': 'nova',       // Friendly chatbot
    'narrator': 'alloy',   // Calm narrator
    'character': 'shimmer', // Word characters
    'teacher': 'echo',     // Teacher mode
  };

  /// Generate character speech (Buddy, narrator, word characters)
  Future<Uint8List> speak(String text, {String role = 'narrator', String? language}) async {
    final voice = _voices[role] ?? _voices['narrator']!;
    final result = await _ai.generateSpeech(text, voice: voice, language: language);
    return result;
  }

  /// Buddy speaks (chatbot voice)
  Future<Uint8List> buddySays(String text) => speak(text, role: 'buddy');

  /// Narrator speaks (calm, story-telling voice)
  Future<Uint8List> narratorSays(String text) => speak(text, role: 'narrator');

  /// Word character speaks with enthusiasm
  Future<Uint8List> characterSays(String text, String word) =>
    speak(text, role: 'character');

  /// Speak letter sound (phonics)
  Future<Uint8List> speakPhonics(String letter, String sound) =>
    speak('The letter $letter makes the sound... $sound!', role: 'teacher');

  /// Bilingual speech (English followed by Hindi)
  Future<Uint8List> speakBilingual(String textEn, String textHi) async {
    final enAudio = await speak(textEn, language: 'en');
    if (enAudio.isEmpty) return enAudio;
    // For now return English only, could concatenate both in future
    return enAudio;
  }

  /// Generate emotional speech
  Future<Uint8List> speakWithEmotion(String text, String emotion) async {
    String enhancedText;
    switch (emotion) {
      case 'excited':
        enhancedText = '(excitedly) $text';
        break;
      case 'gentle':
        enhancedText = '(gently and warmly) $text';
        break;
      case 'encouraging':
        enhancedText = '(with encouragement) $text';
        break;
      default:
        enhancedText = text;
    }
    return speak(enhancedText);
  }

  /// Check if AI voice is available (non-empty response)
  Future<bool> isAvailable() async {
    try {
      final test = await speak('Hello', role: 'narrator');
      return test.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
