import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService();
});

/// Sound effects service — uses TTS for verbal feedback since
/// web platform doesn't support bundled audio files easily.
/// For production, swap with audioplayers + real audio assets.
class SoundService {
  final FlutterTts _tts = FlutterTts();
  bool _enabled = true;
  bool _initialized = false;

  void setEnabled(bool enabled) => _enabled = enabled;
  bool get isEnabled => _enabled;

  Future<void> _init() async {
    if (_initialized) return;
    await _tts.setVolume(0.8);
    await _tts.setPitch(1.2);
    await _tts.setSpeechRate(0.5);
    await _tts.setLanguage('en-US');
    _initialized = true;
  }

  /// Correct answer — speak cheerful feedback
  Future<void> playCorrect() async {
    if (!_enabled) return;
    try {
      await _init();
      await _tts.setPitch(1.3);
      await _tts.setSpeechRate(0.45);
      final phrases = [
        'Great job!', 'Amazing!', 'You got it!', 'Wonderful!',
        'Super!', 'Excellent!', 'Perfect!', 'Bravo!',
        'Fantastic!', 'Well done!',
      ];
      final phrase = phrases[DateTime.now().millisecond % phrases.length];
      await _tts.speak(phrase);
    } catch (_) {}
  }

  /// Wrong answer — speak gentle encouragement
  Future<void> playWrong() async {
    if (!_enabled) return;
    try {
      await _init();
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.4);
      final phrases = [
        'Try again!', 'Almost!', 'Not quite!', 'Keep trying!',
        'One more try!', 'You can do it!',
      ];
      final phrase = phrases[DateTime.now().millisecond % phrases.length];
      await _tts.speak(phrase);
    } catch (_) {}
  }

  /// Star earned celebration
  Future<void> playStarEarned() async {
    if (!_enabled) return;
    try {
      await _init();
      await _tts.setPitch(1.4);
      await _tts.setSpeechRate(0.4);
      await _tts.speak('You earned a star!');
    } catch (_) {}
  }

  /// Speak a word or letter
  Future<void> speakWord(String text, {bool hindi = false}) async {
    if (!_enabled) return;
    try {
      await _init();
      await _tts.setPitch(1.1);
      await _tts.setSpeechRate(0.35);
      await _tts.setLanguage(hindi ? 'hi-IN' : 'en-US');
      await _tts.speak(text);
    } catch (_) {}
  }

  /// Speak bilingual — English then Hindi
  Future<void> speakBilingual(String english, String hindi) async {
    if (!_enabled) return;
    try {
      await _init();
      await _tts.setPitch(1.1);
      await _tts.setSpeechRate(0.35);
      await _tts.setLanguage('en-US');
      await _tts.speak(english);
      await Future.delayed(const Duration(milliseconds: 1500));
      await _tts.setLanguage('hi-IN');
      await _tts.speak(hindi);
    } catch (_) {}
  }

  /// Level up celebration
  Future<void> playLevelUp() async {
    if (!_enabled) return;
    try {
      await _init();
      await _tts.setPitch(1.5);
      await _tts.setSpeechRate(0.35);
      await _tts.speak('Level up! You are amazing!');
    } catch (_) {}
  }

  void dispose() {
    _tts.stop();
  }
}
