import 'dart:io';

void main() {
  final files = [
    'f:/learn/learn_app/lib/features/kid/word_world/meet/meet_tab.dart',
    'f:/learn/learn_app/lib/features/kid/word_world/story/story_tab.dart',
    'f:/learn/learn_app/lib/features/kid/word_world/talk/talk_tab.dart'
  ];

  final regex = RegExp(r'tts\.speakHindi\((.*?)\)');

  for (final path in files) {
    final file = File(path);
    if (file.existsSync()) {
      String content = file.readAsStringSync();
      if (content.contains('tts.speakHindi')) {
        content = content.replaceAllMapped(regex, (match) {
          final arg = match.group(1);
          return "TTSService.instance.speak($arg, lang: 'hi')";
        });
        file.writeAsStringSync(content);
        print('Fixed tts.speakHindi in $path');
      }
    }
  }
}
