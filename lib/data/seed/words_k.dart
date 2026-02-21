import '../models/models.dart';

class WordsK {
  static List<WordData> get words => [
    WordData(id: 'k_kite', word: 'Kite', wordHi: 'पतंग', letter: 'K', emoji: '🪁',
      description: 'A toy that flies in the wind', descriptionHi: 'हवा में उड़ने वाला खिलौना', category: 'toys',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Kite!', textHi: 'मैं पतंग हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Kites fly high in the sky!', textHi: 'पतंग आसमान में ऊँची उड़ती है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Kite!', textHi: 'नमस्ते! मैं पतंग हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Kites need wind to fly. People fly kites on Makar Sankranti!', textHi: 'पतंग उड़ने के लिए हवा चाहिए। लोग मकर संक्रांति पर पतंग उड़ाते हैं!')]),
      thinkGames: [ThinkGame(id: 'k_kite_find', type: 'find', title: 'Find Kite', instruction: 'Tap the kite!', instructionHi: 'पतंग पर टैप करो!', config: {'options': ['🪁','🎈','🎪','🎠'], 'correct': '🪁'})],
      talkLines: [TalkLine(textEn: 'The kite is flying.', textHi: 'पतंग उड़ रही है।')],
      writeContent: WriteContent(letters: ['K'], word: 'Kite'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a diamond shape', instructionHi: 'हीरे का आकार बनाओ', shape: 'line'), DrawStep(stepNumber: 2, instruction: 'Add a long string', instructionHi: 'एक लंबी डोर बनाओ', shape: 'line'), DrawStep(stepNumber: 3, instruction: 'Add bows on the tail', instructionHi: 'पूँछ पर गाँठें बनाओ', shape: 'curve')], finalDescription: 'A colorful kite!')),
    WordData(id: 'k_king', word: 'King', wordHi: 'राजा', letter: 'K', emoji: '🤴',
      description: 'A ruler who wears a crown', descriptionHi: 'मुकुट पहनने वाला शासक', category: 'people',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am the King!', textHi: 'मैं राजा हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'The King wears a shiny crown!', textHi: 'राजा चमकीला मुकुट पहनता है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Greetings! I am the King!', textHi: 'प्रणाम! मैं राजा हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Kings live in castles and rule kingdoms!', textHi: 'राजा महलों में रहते हैं और राज्य चलाते हैं!')]),
      thinkGames: [ThinkGame(id: 'k_king_find', type: 'find', title: 'Find King', instruction: 'Tap the king!', instructionHi: 'राजा पर टैप करो!', config: {'options': ['🤴','👸','🧙','🦸'], 'correct': '🤴'})],
      talkLines: [TalkLine(textEn: 'The king is kind.', textHi: 'राजा दयालु है।')],
      writeContent: WriteContent(letters: ['K'], word: 'King'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a face', instructionHi: 'चेहरा बनाओ', shape: 'circle'), DrawStep(stepNumber: 2, instruction: 'Add a crown on top', instructionHi: 'ऊपर मुकुट बनाओ', shape: 'line')], finalDescription: 'A royal king!')),
    WordData(id: 'k_koala', word: 'Koala', wordHi: 'कोआला', letter: 'K', emoji: '🐨',
      description: 'A cute animal from Australia', descriptionHi: 'ऑस्ट्रेलिया का प्यारा जानवर', category: 'animals',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Koala!', textHi: 'मैं कोआला हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Koalas love to sleep in trees!', textHi: 'कोआला पेड़ों पर सोना पसंद करते हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'G\'day! I am a Koala!', textHi: 'नमस्ते! मैं कोआला हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Koalas eat eucalyptus leaves and sleep 20 hours a day!', textHi: 'कोआला नीलगिरी के पत्ते खाते हैं और दिन में 20 घंटे सोते हैं!')]),
      thinkGames: [ThinkGame(id: 'k_koala_find', type: 'find', title: 'Find Koala', instruction: 'Tap the koala!', instructionHi: 'कोआला पर टैप करो!', config: {'options': ['🐨','🐻','🐼','🐵'], 'correct': '🐨'})],
      talkLines: [TalkLine(textEn: 'The koala is sleepy.', textHi: 'कोआला नींद में है।')],
      writeContent: WriteContent(letters: ['K'], word: 'Koala'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw round body and head', instructionHi: 'गोल शरीर और सिर बनाओ', shape: 'circle'), DrawStep(stepNumber: 2, instruction: 'Add big fluffy ears', instructionHi: 'बड़े मुलायम कान बनाओ', shape: 'circle'), DrawStep(stepNumber: 3, instruction: 'Add a nose and eyes', instructionHi: 'नाक और आँखें बनाओ', shape: 'circle')], finalDescription: 'A cuddly koala!')),
    WordData(id: 'k_key', word: 'Key', wordHi: 'चाबी', letter: 'K', emoji: '🔑',
      description: 'Used to open locks', descriptionHi: 'तालों को खोलने के लिए', category: 'objects',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Key!', textHi: 'मैं चाबी हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Keys open locked doors!', textHi: 'चाबी बंद दरवाज़े खोलती है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Key!', textHi: 'नमस्ते! मैं चाबी हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Every lock has its own special key!', textHi: 'हर ताले की अपनी खास चाबी होती है!')]),
      thinkGames: [ThinkGame(id: 'k_key_find', type: 'find', title: 'Find Key', instruction: 'Tap the key!', instructionHi: 'चाबी पर टैप करो!', config: {'options': ['🔑','🔒','🔔','🔧'], 'correct': '🔑'})],
      talkLines: [TalkLine(textEn: 'I have a key.', textHi: 'मेरे पास चाबी है।')],
      writeContent: WriteContent(letters: ['K'], word: 'Key'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a circle top', instructionHi: 'गोल सिरा बनाओ', shape: 'circle'), DrawStep(stepNumber: 2, instruction: 'Add a long bar', instructionHi: 'एक लंबी छड़ बनाओ', shape: 'line'), DrawStep(stepNumber: 3, instruction: 'Add teeth at the end', instructionHi: 'सिरे पर दाँत बनाओ', shape: 'line')], finalDescription: 'A golden key!')),
  ];
}
