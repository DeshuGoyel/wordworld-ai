import 'dart:typed_data';
import 'ai_service.dart';

/// Video generation service.
/// Creates educational video clips for letters, words, and stories.
class VideoGenService {
  final AIService _ai;

  VideoGenService(this._ai);

  /// Generate a letter intro video
  Future<Uint8List> generateLetterIntro(String letter, String phonicSound) async {
    return _ai.generateVideo(
      'Short animated video introducing the letter "$letter" to a toddler. '
      'Show the letter appearing with sparkles, then a character saying the phonics sound "$phonicSound". '
      'Colorful, cute, educational. Duration: 10 seconds.',
      durationSeconds: 10,
    );
  }

  /// Generate a word story video
  Future<Uint8List> generateWordStory(String word, String description, int childAge) async {
    return _ai.generateVideo(
      'Short animated story about "$word" for a $childAge-year-old. '
      '$description. '
      'Bright colors, friendly characters, simple narrative. Duration: 15 seconds.',
      durationSeconds: 15,
    );
  }

  /// Generate a phonics blending video
  Future<Uint8List> generatePhonicsBlending(String word) async {
    final letters = word.split('');
    final sounds = letters.join('-');
    return _ai.generateVideo(
      'Phonics blending animation: letters $sounds come together to form "$word". '
      'Each letter lights up as its sound is made, then they merge. '
      'Colorful, educational, for young children. Duration: 10 seconds.',
      durationSeconds: 10,
    );
  }

  /// Generate celebration video
  Future<Uint8List> generateCelebration(String letter, String achievement) async {
    return _ai.generateVideo(
      'Congratulations animation for a child completing letter "$letter". '
      '$achievement. Fireworks, stars, confetti, happy characters dancing. '
      'Very positive and rewarding. Duration: 5 seconds.',
      durationSeconds: 5,
    );
  }
}
