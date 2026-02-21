import 'dart:typed_data';
import 'ai_service.dart';

/// Image animation service.
/// Animates static images (character entrances, kid drawings, celebrations).
class ImageAnimateService {
  final AIService _ai;

  ImageAnimateService(this._ai);

  /// Animate a letter character entrance
  Future<Uint8List> animateCharacterEntrance(Uint8List image, String characterName) async {
    return _ai.animateImage(image, 
      'Make this $characterName character bounce in cheerfully and wave at the viewer. '
      'Cute, child-friendly animation. Short loop.');
  }

  /// Animate a kid's completed drawing as a reward
  Future<Uint8List> animateKidDrawing(Uint8List drawing, String word) async {
    return _ai.animateImage(drawing,
      'Gently bring this child\'s drawing of "$word" to life. '
      'Make it wiggle, bounce slightly, and sparkle. Fun and rewarding.');
  }

  /// Animate a story scene illustration
  Future<Uint8List> animateStoryScene(Uint8List scene, String description) async {
    return _ai.animateImage(scene,
      'Add subtle animation to this story scene: $description. '
      'Gentle movement like clouds drifting, characters swaying. Keep it calm and soothing.');
  }

  /// Generate celebration animation
  Future<Uint8List> celebrationAnimation(Uint8List image) async {
    return _ai.animateImage(image,
      'Add celebration effects: confetti falling, stars sparkling, the character doing a happy dance. '
      'Fun and rewarding for a child.');
  }
}
