import 'dart:io';

void main() {
  final libDir = Directory('f:/learn/learn_app/lib');
  
  for (var file in libDir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      String text = file.readAsStringSync();
      bool changed = false;
      
      if (text.contains(r'TTSService.instance.speak(\1)')) {
        text = text.replaceAll(r'TTSService.instance.speak(\1);', "TTSService.instance.speak('Try again!');");
        text = text.replaceAll(r'TTSService.instance.speak(\1),', "TTSService.instance.speak('Tap to hear'),");
        changed = true;
      }
      
      if (text.contains('ttsServiceProvider_OLD') && text.contains('ref.read')) {
        text = text.replaceAll(RegExp(r"final\s+\w+\s*=\s*ref\.read\(ttsServiceProvider_OLD\);"), "");
        changed = true;
      }
      
      if (text.contains('soundServiceProvider') && text.contains('ref.read')) {
        text = text.replaceAll(RegExp(r"final\s+\w+\s*=\s*ref\.read\(soundServiceProvider\);"), "");
        changed = true;
      }
      
      if (text.contains('tts.speakEnglish(')) {
        text = text.replaceAll(r"tts.speakEnglish(", "TTSService.instance.speak(");
        changed = true;
      }

      if (text.contains('sound.playCorrect();')) {
        text = text.replaceAll(r"sound.playCorrect();", "AudioService.instance.play(SoundType.correct);");
        changed = true;
      }
      
      if (text.contains('sound.playStarEarned();')) {
        text = text.replaceAll(r"sound.playStarEarned();", "AudioService.instance.play(SoundType.star);");
        changed = true;
      }

      if (text.contains('sound.playWrong();')) {
        text = text.replaceAll(r"sound.playWrong();", "AudioService.instance.play(SoundType.wrong);");
        changed = true;
      }

      if (changed) {
        file.writeAsStringSync(text);
        print('Fixed: ${file.path}');
      }
    }
  }
}
