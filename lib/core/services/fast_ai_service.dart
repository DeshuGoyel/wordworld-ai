import 'ai_service.dart';
import 'ai_provider.dart';

/// Fast AI service for real-time, low-latency interactions.
/// Hints, instant feedback, encouragement, quick quizzes.
class FastAIService {
  final AIService _ai;

  FastAIService(this._ai);

  /// Get a contextual hint when child is stuck
  Future<String> getHint(String word, String tabName, int attempts) async {
    return _ai.fastResponse(
      'A child (age 2-7) is on the "$tabName" tab for the word "$word". '
      'They have tried $attempts times. Give one short, encouraging hint. '
      'Keep it under 10 words. Use an emoji.',
      config: const AIConfig(maxTokens: 50, temperature: 0.9),
    );
  }

  /// Real-time stroke feedback during writing
  Future<String> getWriteFeedback(String letter, String strokeIssue) async {
    return _ai.fastResponse(
      'A child is tracing the letter "$letter" and $strokeIssue. '
      'Give a very short, gentle correction in under 8 words. Use an emoji.',
      config: const AIConfig(maxTokens: 40, temperature: 0.7),
    );
  }

  /// Generate unique encouragement (not repetitive)
  Future<String> getEncouragement({String? context}) async {
    return _ai.fastResponse(
      'Generate a unique, enthusiastic praise message for a young child '
      '${context != null ? "who just $context" : "learning letters"}. '
      'One short sentence with an emoji. Be creative, don\'t repeat common phrases.',
      config: const AIConfig(maxTokens: 30, temperature: 1.0),
    );
  }

  /// Quick quiz question for a word
  Future<Map<String, dynamic>> generateQuizQuestion(String word, String letter) async {
    final result = await _ai.fastResponse(
      'Create a simple quiz question about "$word" (letter $letter) for a 4-year-old. '
      'Reply as JSON: {"question": "...", "options": ["a","b","c"], "answer": 0, "emoji": "🎯"}',
      config: const AIConfig(maxTokens: 100, temperature: 0.8),
    );
    try {
      return Map<String, dynamic>.from(_parseJson(result));
    } catch (_) {
      return {
        'question': 'Which letter does $word start with?',
        'options': [letter, 'Z', 'X'],
        'answer': 0,
        'emoji': '🔤',
      };
    }
  }

  /// Smart word suggestion autocomplete
  Future<List<String>> suggestWords(String partial, String letter) async {
    final result = await _ai.fastResponse(
      'A child typed "$partial" while learning letter "$letter". '
      'Suggest 3 simple words starting with "$letter" that match. '
      'Reply as JSON array: ["word1", "word2", "word3"]',
      config: const AIConfig(maxTokens: 30, temperature: 0.5),
    );
    try {
      final list = _parseJson(result);
      if (list is List) return list.cast<String>();
    } catch (_) {}
    return ['${letter.toLowerCase()}...'];
  }

  dynamic _parseJson(String text) {
    // Try to extract JSON from response
    final jsonStart = text.indexOf('{') != -1 ? text.indexOf('{') : text.indexOf('[');
    final jsonEnd = text.lastIndexOf('}') != -1 ? text.lastIndexOf('}') + 1 : text.lastIndexOf(']') + 1;
    if (jsonStart >= 0 && jsonEnd > jsonStart) {
      return text.substring(jsonStart, jsonEnd);
    }
    return text;
  }
}
