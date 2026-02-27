import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'ai_service.dart';

/// Speech-to-Text service.
/// Transcribes audio and grades pronunciation against expected words.
class SttService {
  final AIService _ai;
  final SpeechToText _speech = SpeechToText();
  bool _isInit = false;

  SttService(this._ai);

  /// Initialize real-time speech_to_text
  Future<bool> initialize() async {
    if (!_isInit) {
      _isInit = await _speech.initialize(
        onError: (e) => print('STT Error: $e'),
        onStatus: (s) => print('STT Status: $s'),
      );
    }
    return _isInit;
  }

  /// Start live microphone listening for TalkTab
  Future<void> startListening(Function(String) onResult, {String localeId = 'en_US'}) async {
    if (!_isInit) await initialize();
    if (_isInit) {
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          onResult(result.recognizedWords);
        },
        localeId: localeId,
        cancelOnError: true,
        partialResults: true,
      );
    }
  }

  /// Stop live listening
  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;

  /// Grade pronunciation (offline algorithm avoiding LLM dependency for speed)
  Map<String, dynamic> gradePronunciationLive(String expected, String actual) {
    if (actual.isEmpty) return {'score': 0.0, 'feedback': 'I didn\'t hear anything. Try again!'};
    
    // Clean strings
    final eWords = expected.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').split(' ')..removeWhere((e) => e.isEmpty);
    final aWords = actual.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').split(' ')..removeWhere((e) => e.isEmpty);
    
    if (eWords.isEmpty || aWords.isEmpty) return {'score': 0.0, 'feedback': 'Try again!'};

    int matchCount = 0;
    for (var w in aWords) {
      if (eWords.contains(w)) matchCount++;
    }

    double accuracy = matchCount / eWords.length;
    double fluency = (aWords.length / eWords.length).clamp(0.0, 1.0);
    
    // Levenshtein-like character level accuracy for short/single words
    double charAccuracy = 0;
    if (eWords.length == 1 && aWords.length == 1) {
       final e = eWords.first;
       final a = aWords.first;
       int common = 0;
       for (int i = 0; i < min(e.length, a.length); i++) {
         if (e[i] == a[i]) common++;
       }
       charAccuracy = common / max(e.length, a.length);
       accuracy = max(accuracy, charAccuracy);
    }

    double finalScore = (accuracy * 0.7) + (fluency * 0.3);
    finalScore = finalScore.clamp(0.0, 1.0);

    String feedback;
    if (finalScore >= 0.8) {
      feedback = '🌟 Excellent! Perfect pronunciation!';
    } else if (finalScore >= 0.5) {
      feedback = '👍 Good job! Keep practicing!';
    } else {
      feedback = '💪 Nice try! Listen and try again.';
    }

    return {
      'score': finalScore,
      'feedback': feedback,
      'accuracy': accuracy,
      'fluency': fluency,
    };
  }


  // ==========================================
  // RETRO-COMPATIBILITY FOR AskBuddyScreen Use
  // ==========================================

  /// Transcribe raw audio data to text
  Future<String> transcribe(Uint8List audioData, {String language = 'en'}) async {
    return _ai.transcribeAudio(audioData, language: language);
  }

  /// Original gradePronunciation via LLM (unused by TalkTab, kept for compatibility if needed)
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
      final scoreVal = _simpleScore(expectedWord, transcribed);
      return {
        'score': scoreVal,
        'feedback': scoreVal == 3
          ? 'Perfect! You said it right! ⭐⭐⭐'
          : scoreVal == 2
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
