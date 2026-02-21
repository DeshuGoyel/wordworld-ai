import '../models/models.dart';

class WordsN {
  static List<WordData> get words => [
    WordData(id: 'n_nest', word: 'Nest', wordHi: 'घोंसला', letter: 'N', emoji: '🪺',
      description: 'A home birds build for their babies', descriptionHi: 'पक्षी अपने बच्चों के लिए बनाते हैं', category: 'nature',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Nest!', textHi: 'मैं घोंसला हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Birds build nests for their eggs!', textHi: 'पक्षी अंडों के लिए घोंसला बनाते हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Nest!', textHi: 'नमस्ते! मैं घोंसला हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Birds collect twigs and leaves to build their nests!', textHi: 'पक्षी टहनियाँ और पत्तियाँ इकट्ठी करके घोंसला बनाते हैं!')]),
      thinkGames: [ThinkGame(id: 'n_nest_find', type: 'find', title: 'Find Nest', instruction: 'Tap the nest!', instructionHi: 'घोंसले पर टैप करो!', config: {'options': ['🪺','🏠','⛺','🪵'], 'correct': '🪺'})],
      talkLines: [TalkLine(textEn: 'The bird is in the nest.', textHi: 'पक्षी घोंसले में है।')],
      writeContent: WriteContent(letters: ['N'], word: 'Nest'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a bowl shape', instructionHi: 'कटोरे का आकार बनाओ', shape: 'curve'), DrawStep(stepNumber: 2, instruction: 'Add eggs inside', instructionHi: 'अंदर अंडे बनाओ', shape: 'oval')], finalDescription: 'A cozy nest!')),
    WordData(id: 'n_nose', word: 'Nose', wordHi: 'नाक', letter: 'N', emoji: '👃',
      description: 'We use it to smell', descriptionHi: 'हम इससे सूँघते हैं', category: 'body',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Nose!', textHi: 'मैं नाक हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'We smell flowers with our nose!', textHi: 'हम नाक से फूलों की खुशबू लेते हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Nose!', textHi: 'नमस्ते! मैं नाक हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Our nose helps us breathe and smell things!', textHi: 'नाक हमें साँस लेने और सूँघने में मदद करती है!')]),
      thinkGames: [ThinkGame(id: 'n_nose_find', type: 'find', title: 'Find Nose', instruction: 'Tap the nose!', instructionHi: 'नाक पर टैप करो!', config: {'options': ['👃','👁️','👂','👄'], 'correct': '👃'})],
      talkLines: [TalkLine(textEn: 'I smell with my nose.', textHi: 'मैं नाक से सूँघता हूँ।')],
      writeContent: WriteContent(letters: ['N'], word: 'Nose'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a triangular nose', instructionHi: 'त्रिकोण नाक बनाओ', shape: 'triangle'), DrawStep(stepNumber: 2, instruction: 'Add nostrils', instructionHi: 'नथुने बनाओ', shape: 'circle')], finalDescription: 'A cute nose!')),
    WordData(id: 'n_night', word: 'Night', wordHi: 'रात', letter: 'N', emoji: '🌃',
      description: 'When the sun goes down and its dark', descriptionHi: 'जब सूरज डूबता है और अँधेरा होता है', category: 'nature',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am the Night!', textHi: 'मैं रात हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'At night, we see stars and the moon!', textHi: 'रात को हम तारे और चाँद देखते हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am the Night!', textHi: 'नमस्ते! मैं रात हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Night comes after the sun sets. We sleep at night!', textHi: 'सूरज डूबने के बाद रात आती है। हम रात को सोते हैं!')]),
      thinkGames: [ThinkGame(id: 'n_night_find', type: 'find', title: 'Find Night', instruction: 'Tap the night sky!', instructionHi: 'रात के आसमान पर टैप करो!', config: {'options': ['🌃','🌅','🌄','☀️'], 'correct': '🌃'})],
      talkLines: [TalkLine(textEn: 'Good night!', textHi: 'शुभ रात्रि!')],
      writeContent: WriteContent(letters: ['N'], word: 'Night'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a dark sky', instructionHi: 'अँधेरा आसमान बनाओ', shape: 'rectangle'), DrawStep(stepNumber: 2, instruction: 'Add moon and stars', instructionHi: 'चाँद और तारे बनाओ', shape: 'circle')], finalDescription: 'A starry night!')),
    WordData(id: 'n_number', word: 'Number', wordHi: 'संख्या', letter: 'N', emoji: '🔢',
      description: 'Used for counting things', descriptionHi: 'चीज़ों को गिनने के लिए', category: 'concepts',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Number! 1, 2, 3!', textHi: 'मैं संख्या हूँ! 1, 2, 3!'), ScriptLine(speaker: 'narrator', textEn: 'Numbers help us count!', textHi: 'संख्याएँ गिनने में मदद करती हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Number!', textHi: 'नमस्ते! मैं संख्या हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'We use numbers every day to count and measure!', textHi: 'हम रोज़ गिनने और मापने के लिए संख्याओं का उपयोग करते हैं!')]),
      thinkGames: [ThinkGame(id: 'n_number_find', type: 'find', title: 'Find Numbers', instruction: 'Tap the numbers!', instructionHi: 'संख्या पर टैप करो!', config: {'options': ['🔢','🔤','🔣','🔠'], 'correct': '🔢'})],
      talkLines: [TalkLine(textEn: 'I can count numbers.', textHi: 'मैं संख्याएँ गिन सकता हूँ।')],
      writeContent: WriteContent(letters: ['N'], word: 'Number'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Write number 1', instructionHi: 'नंबर 1 लिखो', shape: 'line'), DrawStep(stepNumber: 2, instruction: 'Write number 2', instructionHi: 'नंबर 2 लिखो', shape: 'curve'), DrawStep(stepNumber: 3, instruction: 'Write number 3', instructionHi: 'नंबर 3 लिखो', shape: 'curve')], finalDescription: 'Great counting!')),
  ];
}
