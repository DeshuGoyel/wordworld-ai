import 'dart:typed_data';
import 'ai_service.dart';
import 'ai_provider.dart';

/// Image generation service for the app.
/// Generates flashcards, story illustrations, coloring pages, badges.
class ImageGenService {
  final AIService _ai;

  ImageGenService(this._ai);

  /// Generate a flashcard image for a word
  Future<Uint8List> generateFlashcard(String word, String emoji) async {
    return _ai.generateImage(
      'Cute cartoon illustration of "$word" ($emoji) for a children\'s flashcard. '
      'Simple, colorful, flat design, white background, child-friendly. '
      'No text in the image.',
      width: 512,
      height: 512,
    );
  }

  /// Generate a story illustration
  Future<Uint8List> generateStoryScene(String sceneDescription, String word) async {
    return _ai.generateImage(
      'Children\'s book illustration: $sceneDescription. '
      'Features a friendly $word character. '
      'Warm, inviting colors, age-appropriate for toddlers.',
      width: 768,
      height: 512,
    );
  }

  /// Generate a coloring page (line art)
  Future<Uint8List> generateColoringPage(String word) async {
    return _ai.generateImage(
      'Simple line drawing of a $word for a children\'s coloring book. '
      'Thick black outlines, no color fill, large simple shapes. '
      'White background, suitable for printing and coloring by a 3-year-old.',
      width: 800,
      height: 800,
    );
  }

  /// Generate a reward badge
  Future<Uint8List> generateBadge(String letter, String achievement) async {
    return _ai.generateImage(
      'Cute achievement badge with the letter "$letter" in the center. '
      '$achievement theme. Gold border, sparkles, child-friendly design, round shape.',
      width: 256,
      height: 256,
    );
  }

  /// Generate an avatar item
  Future<Uint8List> generateAvatarItem(String itemType) async {
    return _ai.generateImage(
      'Cartoon $itemType accessory for a children\'s avatar. '
      'Cute style, vibrant colors, transparent background.',
      width: 256,
      height: 256,
    );
  }
}
