import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.4); // Slower for kids
    await _tts.setPitch(1.1); // Slightly higher pitch
    _initialized = true;
  }

  Future<void> speakEnglish(String text) async {
    await init();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.speak(text);
  }

  Future<void> speakHindi(String text) async {
    await init();
    await _tts.setLanguage('hi-IN');
    await _tts.setSpeechRate(0.4);
    await _tts.speak(text);
  }

  Future<void> speakLetter(String letter) async {
    await init();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.3);
    await _tts.speak(letter);
  }

  Future<void> speakPhonetic(String letter) async {
    await init();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.3);
    // Speak the sound the letter makes
    final sounds = {
      'A': 'aah', 'B': 'buh', 'C': 'kuh', 'D': 'duh',
      'E': 'eh', 'F': 'fff', 'G': 'guh', 'H': 'huh',
      'I': 'ih', 'J': 'juh', 'K': 'kuh', 'L': 'luh',
      'M': 'mmm', 'N': 'nnn', 'O': 'ah', 'P': 'puh',
      'Q': 'kwuh', 'R': 'rrr', 'S': 'sss', 'T': 'tuh',
      'U': 'uh', 'V': 'vvv', 'W': 'wuh', 'X': 'ks',
      'Y': 'yuh', 'Z': 'zzz',
    };
    await _tts.speak(sounds[letter] ?? letter.toLowerCase());
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}
