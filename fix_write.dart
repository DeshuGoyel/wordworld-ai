import 'dart:io';

void main() {
  final file = File('f:/learn/learn_app/lib/features/kid/word_world/write/write_tab.dart');
  String text = file.readAsStringSync();
  
  // Fix the \1 literals
  text = text.replaceAll(r'TTSService.instance.speak(\1);', "TTSService.instance.speak('Try again!');");
  text = text.replaceAll(r'TTSService.instance.speak(\1),', "TTSService.instance.speak(widget.word.word),");
  text = text.replaceAll(r"final tts = ref.read(ttsServiceProvider_OLD);", "");
  text = text.replaceAll(r"tts.speakEnglish(", "TTSService.instance.speak(");
  text = text.replaceAll(r"final sound = ref.read(soundServiceProvider);", "");
  text = text.replaceAll(r"sound.playCorrect();", "AudioService.instance.play(SoundType.correct);");
  text = text.replaceAll(r"sound.playStarEarned();", "AudioService.instance.play(SoundType.star);");
  
  file.writeAsStringSync(text);
  print('Done fixing write_tab.dart');
}
