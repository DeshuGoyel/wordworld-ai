import 'dart:io';

void main() {
  void fixFile(String path, Map<String, String> replacements) {
    final file = File(path);
    if (!file.existsSync()) return;
    String text = file.readAsStringSync();
    
    replacements.forEach((key, value) {
      text = text.replaceAll(key, value);
    });
    
    file.writeAsStringSync(text);
    print('Fixed $path');
  }

  fixFile('f:/learn/learn_app/lib/features/kid/word_world/meet/meet_tab.dart', {
    'await tts.speakHindi(_lines[i].textHi);': r"await TTSService.instance.speak(_lines[i].textHi, lang: 'hi');",
  });

  fixFile('f:/learn/learn_app/lib/features/kid/word_world/story/story_tab.dart', {
    'await tts.speakHindi(_scenes[i].textHi);': r"await TTSService.instance.speak(_scenes[i].textHi, lang: 'hi');",
    'tts.speakHindi(scene.textHi);': r"TTSService.instance.speak(scene.textHi, lang: 'hi');",
  });

  fixFile('f:/learn/learn_app/lib/features/kid/word_world/talk/talk_tab.dart', {
    'tts.speakHindi(_line.textHi);': r"TTSService.instance.speak(_line.textHi, lang: 'hi');",
    r"TTSService.instance.speak('Try again!');": r"TTSService.instance.speak('Try again', lang: 'hi');",
  });
  
  fixFile('f:/learn/learn_app/lib/features/kid/word_world/think/think_tab.dart', {
    'final tts = ref.read(ttsServiceProvider_OLD);': '',
    'final sound = ref.read(soundServiceProvider);': '',
    r"TTSService.instance.speak(\1);": r"TTSService.instance.speak('Tap to hear');",
    r"TTSService.instance.speak(\1),": r"TTSService.instance.speak('Tap to hear'),",
  });

  fixFile('f:/learn/learn_app/lib/features/kid/word_world/word_world_screen.dart', {
    r"TTSService.instance.speak(\1);": r"TTSService.instance.speak('Level started');",
  });
}
