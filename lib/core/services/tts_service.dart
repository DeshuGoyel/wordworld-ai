import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final instance = TTSService._();
  TTSService._();
  
  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;
  double _speed = 0.9;
  
  // Callbacks for subtitle sync:
  VoidCallback? onComplete;
  Function(String word, int start, int end)? onWordBoundary;
  
  Future<void> init() async {
    // iOS audio session:
    if (!kIsWeb && Platform.isIOS) {
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.allowBluetooth],
        IosTextToSpeechAudioMode.defaultMode,
      );
    }
    
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.9);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);
    
    _tts.setCompletionHandler(() {
      _isPlaying = false;
      onComplete?.call();
    });
    
    _tts.setProgressHandler((text, start, end, word) {
        onWordBoundary?.call(word, start, end);
    });
    
    _tts.setErrorHandler((msg) {
      _isPlaying = false;
      debugPrint('TTS Error: $msg');
    });
  }
  
  Future<void> speak(
    String text, {
    String lang = 'en',
    bool isGyani = false,
  }) async {
    await stop();
    
    if (lang == 'hi') {
      await _tts.setLanguage('hi-IN');
      await _tts.setSpeechRate(_speed * 0.85);
    } else {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(_speed);
    }
    
    if (isGyani) {
      await _tts.setPitch(1.35);
      await _tts.setSpeechRate(_speed * 0.85);
    } else {
      await _tts.setPitch(1.1);
    }
    
    _isPlaying = true;
    final result = await _tts.speak(text);
    if (result != 1) _isPlaying = false;
  }
  
  // Speak bilingual: EN then HI:
  Future<void> speakBilingual(String textEn, String textHi) async {
    onComplete = () async {
      onComplete = null;
      await Future.delayed(const Duration(milliseconds: 300));
      await speak(textHi, lang: 'hi');
    };
    await speak(textEn, lang: 'en');
  }
  
  Future<void> stop() async {
    await _tts.stop();
    _isPlaying = false;
  }
  
  void setSpeed(double speed) {
    _speed = speed.clamp(0.5, 1.5);
  }
  
  bool get isPlaying => _isPlaying;
}
