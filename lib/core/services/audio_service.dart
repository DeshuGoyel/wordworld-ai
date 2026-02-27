import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SoundType {
  tap,
  correct,
  wrong,
  complete,
  star,
  levelup,
  unlock,
  streak,
}

class AudioService {
  static final instance = AudioService._();
  AudioService._();
  
  final Map<SoundType, AudioPlayer> _pool = {};
  bool _muted = false;
  AudioPlayer? _bgPlayer;
  
  Future<void> init() async {
    // Preload all SFX:
    for (final type in SoundType.values) {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      try {
        await player.setSource(AssetSource('sounds/${type.name}.mp3'));
      } catch(_) {
        // Sound file missing — skip silently
      }
      _pool[type] = player;
    }
    
    // Load mute preference:
    final prefs = await SharedPreferences.getInstance();
    _muted = prefs.getBool('audio_muted') ?? false;
    
    // BG music player:
    _bgPlayer = AudioPlayer();
    await _bgPlayer!.setReleaseMode(ReleaseMode.loop);
    try {
      if (!kIsWeb) {
         await _bgPlayer!.setSource(AssetSource('sounds/bg_music.mp3'));
      }
    } catch(_) {}
  }
  
  void play(SoundType type) {
    if (_muted) return;
    final player = _pool[type];
    if (player == null) return;
    player.stop().then((_) => player.resume());
  }
  
  Future<void> playBg() async {
    if (_muted) return;
    await _bgPlayer?.resume();
  }
  
  Future<void> stopBg() async {
    await _bgPlayer?.pause();
  }
  
  Future<void> setMuted(bool muted) async {
    _muted = muted;
    if (muted) await _bgPlayer?.pause();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audio_muted', muted);
  }
  
  bool get isMuted => _muted;
  
  Future<void> dispose() async {
    for (final p in _pool.values) await p.dispose();
    await _bgPlayer?.dispose();
  }
}
