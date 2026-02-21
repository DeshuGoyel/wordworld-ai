import '../models/models.dart';

class WordsM {
  static List<WordData> get words => [
    WordData(id: 'm_moon', word: 'Moon', wordHi: 'चाँद', letter: 'M', emoji: '🌙',
      description: 'Shines at night in the sky', descriptionHi: 'रात को आसमान में चमकता है', category: 'nature',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am the Moon!', textHi: 'मैं चाँद हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'The moon shines bright at night!', textHi: 'चाँद रात को चमकता है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am the Moon!', textHi: 'नमस्ते! मैं चाँद हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'The moon goes around the Earth. It has no light of its own!', textHi: 'चाँद पृथ्वी के चारों ओर घूमता है। इसकी अपनी रोशनी नहीं है!')]),
      thinkGames: [ThinkGame(id: 'm_moon_find', type: 'find', title: 'Find Moon', instruction: 'Tap the moon!', instructionHi: 'चाँद पर टैप करो!', config: {'options': ['🌙','⭐','☀️','🌍'], 'correct': '🌙'})],
      talkLines: [TalkLine(textEn: 'The moon is bright.', textHi: 'चाँद चमकीला है।')],
      writeContent: WriteContent(letters: ['M'], word: 'Moon'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a crescent shape', instructionHi: 'अर्धचंद्र बनाओ', shape: 'curve'), DrawStep(stepNumber: 2, instruction: 'Add stars around', instructionHi: 'चारों ओर तारे बनाओ', shape: 'line')], finalDescription: 'A beautiful moon!')),
    WordData(id: 'm_monkey', word: 'Monkey', wordHi: 'बंदर', letter: 'M', emoji: '🐵',
      description: 'A playful animal that swings on trees', descriptionHi: 'पेड़ों पर झूलने वाला शरारती जानवर', category: 'animals',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'Ooh ooh! I am a Monkey!', textHi: 'ऊ ऊ! मैं बंदर हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Monkeys love bananas!', textHi: 'बंदरों को केले बहुत पसंद हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hi! I am a Monkey!', textHi: 'नमस्ते! मैं बंदर हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Monkeys are very smart and can use tools!', textHi: 'बंदर बहुत चतुर होते हैं और औजारों का उपयोग कर सकते हैं!')]),
      thinkGames: [ThinkGame(id: 'm_monkey_find', type: 'find', title: 'Find Monkey', instruction: 'Tap the monkey!', instructionHi: 'बंदर पर टैप करो!', config: {'options': ['🐵','🐻','🦊','🐶'], 'correct': '🐵'})],
      talkLines: [TalkLine(textEn: 'The monkey eats bananas.', textHi: 'बंदर केले खाता है।')],
      writeContent: WriteContent(letters: ['M'], word: 'Monkey'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a round face', instructionHi: 'गोल चेहरा बनाओ', shape: 'circle'), DrawStep(stepNumber: 2, instruction: 'Add big ears and a smile', instructionHi: 'बड़े कान और मुस्कान बनाओ', shape: 'circle'), DrawStep(stepNumber: 3, instruction: 'Draw a curly tail', instructionHi: 'घुंघराली पूँछ बनाओ', shape: 'curve')], finalDescription: 'A funny monkey!')),
    WordData(id: 'm_mango', word: 'Mango', wordHi: 'आम', letter: 'M', emoji: '🥭',
      description: 'King of fruits, sweet and juicy', descriptionHi: 'फलों का राजा, मीठा और रसीला', category: 'food',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Mango!', textHi: 'मैं आम हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Mango is sweet and yummy!', textHi: 'आम मीठा और स्वादिष्ट है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am the Mango!', textHi: 'नमस्ते! मैं आम हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Mango is called the king of fruits in India!', textHi: 'भारत में आम को फलों का राजा कहते हैं!')]),
      thinkGames: [ThinkGame(id: 'm_mango_find', type: 'find', title: 'Find Mango', instruction: 'Tap the mango!', instructionHi: 'आम पर टैप करो!', config: {'options': ['🥭','🍎','🍊','🍋'], 'correct': '🥭'})],
      talkLines: [TalkLine(textEn: 'I eat a mango.', textHi: 'मैं आम खाता हूँ।')],
      writeContent: WriteContent(letters: ['M'], word: 'Mango'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw an oval shape', instructionHi: 'अंडाकार बनाओ', shape: 'oval'), DrawStep(stepNumber: 2, instruction: 'Color it yellow', instructionHi: 'पीला रंग भरो', shape: 'oval')], finalDescription: 'A juicy mango!')),
    WordData(id: 'm_mountain', word: 'Mountain', wordHi: 'पहाड़', letter: 'M', emoji: '🏔️',
      description: 'A very tall landform', descriptionHi: 'बहुत ऊँचा भूभाग', category: 'nature',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Mountain!', textHi: 'मैं पहाड़ हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Mountains are very tall!', textHi: 'पहाड़ बहुत ऊँचे होते हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Mountain!', textHi: 'नमस्ते! मैं पहाड़ हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'The Himalayas are the tallest mountains in the world!', textHi: 'हिमालय दुनिया के सबसे ऊँचे पहाड़ हैं!')]),
      thinkGames: [ThinkGame(id: 'm_mountain_find', type: 'find', title: 'Find Mountain', instruction: 'Tap the mountain!', instructionHi: 'पहाड़ पर टैप करो!', config: {'options': ['🏔️','🌋','🏝️','🏜️'], 'correct': '🏔️'})],
      talkLines: [TalkLine(textEn: 'The mountain is tall.', textHi: 'पहाड़ ऊँचा है।')],
      writeContent: WriteContent(letters: ['M'], word: 'Mountain'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a big triangle', instructionHi: 'एक बड़ा त्रिकोण बनाओ', shape: 'triangle'), DrawStep(stepNumber: 2, instruction: 'Add snow on top', instructionHi: 'ऊपर बर्फ बनाओ', shape: 'curve')], finalDescription: 'A snowy mountain!')),
  ];
}
