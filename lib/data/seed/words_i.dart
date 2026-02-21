import '../models/models.dart';

class WordsI {
  static List<WordData> get words => [
    WordData(id: 'i_ice_cream', word: 'Ice Cream', wordHi: 'आइसक्रीम', letter: 'I', emoji: '🍦',
      description: 'A cold sweet frozen treat', descriptionHi: 'एक ठंडी मीठी जमी हुई मिठाई', category: 'food',
      meetContent: MeetContent(
        linesYoung: [
          ScriptLine(speaker: 'character', textEn: 'Hi! I am Ice Cream!', textHi: 'नमस्ते! मैं आइसक्रीम हूँ!'),
          ScriptLine(speaker: 'narrator', textEn: 'Ice Cream is cold and yummy!', textHi: 'आइसक्रीम ठंडी और स्वादिष्ट होती है!'),
          ScriptLine(speaker: 'character', textEn: 'I start with the letter I!', textHi: 'मेरा नाम I से शुरू होता है!'),
        ],
        linesOlder: [
          ScriptLine(speaker: 'character', textEn: 'Hello! I am Ice Cream!', textHi: 'नमस्ते! मैं आइसक्रीम हूँ!'),
          ScriptLine(speaker: 'narrator', textEn: 'Ice cream comes in many flavors like chocolate and vanilla.', textHi: 'आइसक्रीम कई फ्लेवर में आती है जैसे चॉकलेट और वनीला।'),
          ScriptLine(speaker: 'character', textEn: 'I is for Ice Cream! Can you say I?', textHi: 'I आइसक्रीम के लिए है! क्या तुम I बोल सकते हो?'),
        ],
      ),
      thinkGames: [ThinkGame(id: 'i_ice_cream_find', type: 'find', title: 'Find Ice Cream', instruction: 'Tap the ice cream!', instructionHi: 'आइसक्रीम पर टैप करो!', config: {'options': ['🍦','🍕','🎂','🍪'], 'correct': '🍦'})],
      talkLines: [TalkLine(textEn: 'I like ice cream.', textHi: 'मुझे आइसक्रीम पसंद है।'), TalkLine(textEn: 'Ice cream is cold.', textHi: 'आइसक्रीम ठंडी होती है।')],
      writeContent: WriteContent(letters: ['I'], word: 'Ice'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a triangle cone', instructionHi: 'एक त्रिकोण कोन बनाओ', shape: 'triangle'), DrawStep(stepNumber: 2, instruction: 'Add scoops on top', instructionHi: 'ऊपर गोले बनाओ', shape: 'circle'), DrawStep(stepNumber: 3, instruction: 'Add a cherry!', instructionHi: 'ऊपर चेरी लगाओ', shape: 'circle')], finalDescription: 'Yummy ice cream!')),
    WordData(id: 'i_igloo', word: 'Igloo', wordHi: 'इग्लू', letter: 'I', emoji: '🏠',
      description: 'A house made of ice blocks', descriptionHi: 'बर्फ के टुकड़ों से बना घर', category: 'places',
      meetContent: MeetContent(
        linesYoung: [
          ScriptLine(speaker: 'character', textEn: 'I am an Igloo!', textHi: 'मैं एक इग्लू हूँ!'),
          ScriptLine(speaker: 'narrator', textEn: 'An igloo is a house made of snow!', textHi: 'इग्लू बर्फ से बना घर है!'),
          ScriptLine(speaker: 'character', textEn: 'I keep people warm inside!', textHi: 'मैं अंदर लोगों को गर्म रखता हूँ!'),
        ],
        linesOlder: [
          ScriptLine(speaker: 'character', textEn: 'Hello! I am an Igloo!', textHi: 'नमस्ते! मैं एक इग्लू हूँ!'),
          ScriptLine(speaker: 'narrator', textEn: 'Igloos are built by Inuit people in cold places.', textHi: 'इग्लू ठंडे इलाकों में इनुइट लोग बनाते हैं।'),
          ScriptLine(speaker: 'character', textEn: 'I is for Igloo!', textHi: 'I इग्लू के लिए है!'),
        ],
      ),
      thinkGames: [ThinkGame(id: 'i_igloo_find', type: 'find', title: 'Find Igloo', instruction: 'Tap the igloo!', instructionHi: 'इग्लू पर टैप करो!', config: {'options': ['🏠','🏰','🏢','⛺'], 'correct': '🏠'})],
      talkLines: [TalkLine(textEn: 'This is an igloo.', textHi: 'यह एक इग्लू है।')],
      writeContent: WriteContent(letters: ['I'], word: 'Igloo'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a half circle', instructionHi: 'एक अर्धवृत्त बनाओ', shape: 'curve'), DrawStep(stepNumber: 2, instruction: 'Draw a small door', instructionHi: 'एक छोटा दरवाजा बनाओ', shape: 'rectangle')], finalDescription: 'A cozy igloo!')),
    WordData(id: 'i_insect', word: 'Insect', wordHi: 'कीड़ा', letter: 'I', emoji: '🐛',
      description: 'A tiny creature with six legs', descriptionHi: 'छह पैरों वाला छोटा जीव', category: 'animals',
      meetContent: MeetContent(
        linesYoung: [
          ScriptLine(speaker: 'character', textEn: 'I am an Insect!', textHi: 'मैं एक कीड़ा हूँ!'),
          ScriptLine(speaker: 'narrator', textEn: 'Insects are tiny and have six legs!', textHi: 'कीड़े छोटे होते हैं और उनके छह पैर होते हैं!'),
        ],
        linesOlder: [
          ScriptLine(speaker: 'character', textEn: 'Hello! I am an Insect!', textHi: 'नमस्ते! मैं एक कीड़ा हूँ!'),
          ScriptLine(speaker: 'narrator', textEn: 'Insects have six legs and some can fly!', textHi: 'कीड़ों के छह पैर होते हैं और कुछ उड़ सकते हैं!'),
        ],
      ),
      thinkGames: [ThinkGame(id: 'i_insect_find', type: 'find', title: 'Find Insect', instruction: 'Tap the insect!', instructionHi: 'कीड़े पर टैप करो!', config: {'options': ['🐛','🐶','🐱','🐟'], 'correct': '🐛'})],
      talkLines: [TalkLine(textEn: 'I see an insect.', textHi: 'मुझे एक कीड़ा दिखा।')],
      writeContent: WriteContent(letters: ['I'], word: 'Insect'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw an oval body', instructionHi: 'अंडाकार शरीर बनाओ', shape: 'oval'), DrawStep(stepNumber: 2, instruction: 'Add six legs', instructionHi: 'छह पैर बनाओ', shape: 'line'), DrawStep(stepNumber: 3, instruction: 'Add antennae', instructionHi: 'एंटीना बनाओ', shape: 'line')], finalDescription: 'A cute insect!')),
    WordData(id: 'i_island', word: 'Island', wordHi: 'द्वीप', letter: 'I', emoji: '🏝️',
      description: 'Land surrounded by water', descriptionHi: 'चारों ओर पानी से घिरी जमीन', category: 'nature',
      meetContent: MeetContent(
        linesYoung: [
          ScriptLine(speaker: 'character', textEn: 'I am an Island!', textHi: 'मैं एक द्वीप हूँ!'),
          ScriptLine(speaker: 'narrator', textEn: 'An island has water all around it!', textHi: 'द्वीप के चारों ओर पानी होता है!'),
        ],
        linesOlder: [
          ScriptLine(speaker: 'character', textEn: 'Hello! I am an Island!', textHi: 'नमस्ते! मैं एक द्वीप हूँ!'),
          ScriptLine(speaker: 'narrator', textEn: 'Islands are pieces of land surrounded by ocean.', textHi: 'द्वीप समुद्र से घिरे जमीन के टुकड़े हैं।'),
        ],
      ),
      thinkGames: [ThinkGame(id: 'i_island_find', type: 'find', title: 'Find Island', instruction: 'Tap the island!', instructionHi: 'द्वीप पर टैप करो!', config: {'options': ['🏝️','🏔️','🌊','🏜️'], 'correct': '🏝️'})],
      talkLines: [TalkLine(textEn: 'The island is beautiful.', textHi: 'द्वीप सुंदर है।')],
      writeContent: WriteContent(letters: ['I'], word: 'Island'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a bumpy land shape', instructionHi: 'ऊबड़-खाबड़ जमीन बनाओ', shape: 'curve'), DrawStep(stepNumber: 2, instruction: 'Add a palm tree', instructionHi: 'एक ताड़ का पेड़ बनाओ', shape: 'line'), DrawStep(stepNumber: 3, instruction: 'Draw waves around', instructionHi: 'चारों ओर लहरें बनाओ', shape: 'curve')], finalDescription: 'A tropical island!')),
  ];
}
