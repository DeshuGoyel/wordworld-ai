import 'dart:typed_data';
import 'dart:convert';
import 'ai_service.dart';

/// Speech-to-Text service.
/// Transcribes audio and grades pronunciation against expected words.
class SttService {
  final AIService _ai;

  SttService(this._ai);

  /// Transcribe raw audio data to text
  Future<String> transcribe(Uint8List audioData, {String language = 'en'}) async {
    return _ai.transcribeAudio(audioData, language: language);
  }

  /// Grade pronunciation: child says a word, we compare against expected
  /// Returns: {score: 1-3, feedback: String, transcribed: String}
  Future<Map<String, dynamic>> gradePronunciation(Uint8List audioData, String expectedWord) async {
    final transcribed = await transcribe(audioData);
    if (transcribed.isEmpty) {
      return {'score': 0, 'feedback': 'I didn\'t hear anything. Try again! 🎤', 'transcribed': ''};
    }

    // Use AI to compare pronunciation
    final prompt = _ai.pronunciationPrompt(expectedWord, transcribed);
    final result = await _ai.fastResponse(prompt);
    try {
      final json = jsonDecode(result) as Map<String, dynamic>;
      json['transcribed'] = transcribed;
      return json;
    } catch (_) {
      // Fallback: simple string comparison
      final score = _simpleScore(expectedWord, transcribed);
      return {
        'score': score,
        'feedback': score == 3
          ? 'Perfect! You said it right! ⭐⭐⭐'
          : score == 2
            ? 'Almost! Try again! ⭐⭐'
            : 'Good try! Let\'s practice more! ⭐',
        'transcribed': transcribed,
      };
    }
  }

  /// Detect language (English vs Hindi)
  Future<String> detectLanguage(Uint8List audioData) async {
    final transcribed = await transcribe(audioData);
    final result = await _ai.fastResponse(
      'Is this text in English or Hindi? Text: "$transcribed". '
      'Reply with just "en" or "hi".');
    return result.trim().toLowerCase().contains('hi') ? 'hi' : 'en';
  }

  /// Parse voice commands (e.g., "Teach me letter B")
  Future<Map<String, dynamic>> parseVoiceCommand(Uint8List audioData) async {
    final transcribed = await transcribe(audioData);
    final result = await _ai.fastResponse(
      'A child said: "$transcribed". Parse their intent. '
      'Reply as JSON: {"intent": "learn_letter|learn_word|ask_question|unknown", '
      '"target": "the letter or word mentioned", "original": "$transcribed"}');
    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (_) {
      return {'intent': 'unknown', 'target': '', 'original': transcribed};
    }
  }

  int _simpleScore(String expected, String actual) {
    final e = expected.toLowerCase().trim();
    final a = actual.toLowerCase().trim();
    if (a == e) return 3;
    if (a.contains(e) || e.contains(a)) return 2;
    if (a.isNotEmpty && e.isNotEmpty && a[0] == e[0]) return 1;
    return 1;
  }
}
