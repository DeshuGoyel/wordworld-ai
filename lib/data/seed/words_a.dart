import '../models/models.dart';

class WordsA {
  static List<WordData> get words => [
    _apple, _ant, _airplane, _alligator,
  ];

  static final _apple = WordData(
    id: 'a_apple', word: 'Apple', wordHi: 'सेब', letter: 'A', emoji: '🍎',
    description: 'A red, round fruit that is sweet and crunchy',
    descriptionHi: 'एक लाल, गोल फल जो मीठा और कुरकुरा होता है', category: 'fruit',
    meetContent: MeetContent(
      linesYoung: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Apple!', textHi: 'नमस्ते! मैं सेब हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I am red and round.', textHi: 'मैं लाल और गोल हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I grow on trees.', textHi: 'मैं पेड़ों पर उगता हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I am yummy to eat!', textHi: 'मुझे खाना बहुत स्वादिष्ट है!'),
      ],
      linesOlder: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Apple!', textHi: 'नमस्ते! मैं सेब हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I am red, round, and sweet.', textHi: 'मैं लाल, गोल और मीठा हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I grow on apple trees in orchards.', textHi: 'मैं बागों में सेब के पेड़ों पर उगता हूँ।'),
        ScriptLine(speaker: 'narrator', textEn: 'An apple a day keeps the doctor away!', textHi: 'रोज़ एक सेब खाओ, बीमारी को दूर भगाओ!'),
        ScriptLine(speaker: 'character', textEn: 'I was growing on a tree. Now I am here!', textHi: 'मैं पेड़ पर उग रहा था। अब मैं यहाँ हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I will become your healthy snack!', textHi: 'मैं तुम्हारा हेल्दी स्नैक बनूँगा!'),
      ],
    ),
    thinkGames: [
      ThinkGame(id: 'a_apple_find', type: 'find', title: 'Find the Apple', instruction: 'Tap the apple!', instructionHi: 'सेब पर टैप करो!', config: {'correct': '🍎', 'options': ['🍎','🍌','🍇','🥕']}),
      ThinkGame(id: 'a_apple_sort', type: 'sort', title: 'Fruits vs Not', instruction: 'Which are fruits?', instructionHi: 'कौन से फल हैं?', ageMin: 4, config: {'groups': ['Fruits','Not Fruits'], 'items': [{'item':'🍎','group':'Fruits'},{'item':'🍌','group':'Fruits'},{'item':'🥕','group':'Not Fruits'},{'item':'🪑','group':'Not Fruits'}]}),
    ],
    talkLines: [
      TalkLine(textEn: 'I am an apple.', textHi: 'मैं एक सेब हूँ।'),
      TalkLine(textEn: 'The apple is red.', textHi: 'सेब लाल है।'),
      TalkLine(textEn: 'I like to eat apples.', textHi: 'मुझे सेब खाना पसंद है।'),
    ],
    writeContent: WriteContent(letters: ['A', 'a'], word: 'Apple'),
    drawContent: DrawContent(steps: [
      DrawStep(stepNumber: 1, instruction: 'Draw a big circle', instructionHi: 'एक बड़ा गोला बनाओ', shape: 'circle'),
      DrawStep(stepNumber: 2, instruction: 'Add a small stem on top', instructionHi: 'ऊपर एक छोटी डंठल बनाओ', shape: 'line'),
      DrawStep(stepNumber: 3, instruction: 'Draw a leaf near the stem', instructionHi: 'डंठल के पास एक पत्ता बनाओ', shape: 'curve'),
    ], finalDescription: 'A beautiful apple!'),
  );

  static final _ant = WordData(
    id: 'a_ant', word: 'Ant', wordHi: 'चींटी', letter: 'A', emoji: '🐜',
    description: 'A tiny insect that works very hard', descriptionHi: 'एक छोटा कीड़ा जो बहुत मेहनत करता है', category: 'insect',
    meetContent: MeetContent(
      linesYoung: [
        ScriptLine(speaker: 'character', textEn: 'Hi! I am Ant!', textHi: 'नमस्ते! मैं चींटी हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I am very tiny.', textHi: 'मैं बहुत छोटी हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I carry food on my back!', textHi: 'मैं अपनी पीठ पर खाना ले जाती हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I live with my ant family.', textHi: 'मैं अपने चींटी परिवार के साथ रहती हूँ।'),
      ],
      linesOlder: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Ant!', textHi: 'नमस्ते! मैं चींटी हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I am tiny but very strong.', textHi: 'मैं छोटी हूँ लेकिन बहुत मज़बूत।'),
        ScriptLine(speaker: 'character', textEn: 'I can carry things 50 times my weight!', textHi: 'मैं अपने वज़न से 50 गुना भारी चीज़ उठा सकती हूँ!'),
        ScriptLine(speaker: 'narrator', textEn: 'Ants teach us teamwork!', textHi: 'चींटियाँ हमें टीमवर्क सिखाती हैं!'),
      ],
    ),
    thinkGames: [
      ThinkGame(id: 'a_ant_find', type: 'find', title: 'Find the Ant', instruction: 'Tap the ant!', instructionHi: 'चींटी पर टैप करो!', config: {'correct': '🐜', 'options': ['🐜','🐝','🦋','🐛']}),
    ],
    talkLines: [TalkLine(textEn: 'I see an ant.', textHi: 'मुझे एक चींटी दिख रही है।')],
    writeContent: WriteContent(letters: ['A', 'a'], word: 'Ant'),
    drawContent: DrawContent(steps: [
      DrawStep(stepNumber: 1, instruction: 'Draw 3 small circles in a line', instructionHi: 'एक लाइन में 3 छोटे गोले बनाओ', shape: 'circle'),
      DrawStep(stepNumber: 2, instruction: 'Add 6 tiny legs', instructionHi: '6 छोटे पैर बनाओ', shape: 'line'),
      DrawStep(stepNumber: 3, instruction: 'Add 2 antennae on head', instructionHi: 'सिर पर 2 एंटीना बनाओ', shape: 'line'),
    ], finalDescription: 'A busy little ant!'),
  );

  static final _airplane = WordData(
    id: 'a_airplane', word: 'Airplane', wordHi: 'हवाई जहाज़', letter: 'A', emoji: '✈️',
    description: 'A big machine that flies in the sky', descriptionHi: 'एक बड़ी मशीन जो आसमान में उड़ती है', category: 'vehicle',
    meetContent: MeetContent(
      linesYoung: [
        ScriptLine(speaker: 'character', textEn: 'Whoosh! I am Airplane!', textHi: 'वूश! मैं हवाई जहाज़ हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I fly high in the sky!', textHi: 'मैं आसमान में ऊँचा उड़ता हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I have big wings.', textHi: 'मेरे बड़े पंख हैं।'),
        ScriptLine(speaker: 'character', textEn: 'I take people to far places!', textHi: 'मैं लोगों को दूर जगहों पर ले जाता हूँ!'),
      ],
      linesOlder: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Airplane!', textHi: 'नमस्ते! मैं हवाई जहाज़ हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I fly above the clouds.', textHi: 'मैं बादलों के ऊपर उड़ता हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I was waiting at the airport. Now I am flying!', textHi: 'मैं एयरपोर्ट पर खड़ा था। अब मैं उड़ रहा हूँ!'),
        ScriptLine(speaker: 'narrator', textEn: 'Airplanes connect the whole world!', textHi: 'हवाई जहाज़ पूरी दुनिया को जोड़ते हैं!'),
      ],
    ),
    thinkGames: [
      ThinkGame(id: 'a_air_find', type: 'find', title: 'Find the Airplane', instruction: 'Tap what flies!', instructionHi: 'उड़ने वाली चीज़ पर टैप करो!', config: {'correct': '✈️', 'options': ['✈️','🚗','🚢','🚲']}),
    ],
    talkLines: [TalkLine(textEn: 'The airplane is flying.', textHi: 'हवाई जहाज़ उड़ रहा है।')],
    writeContent: WriteContent(letters: ['A', 'a'], word: 'Air'),
    drawContent: DrawContent(steps: [
      DrawStep(stepNumber: 1, instruction: 'Draw a long oval for body', instructionHi: 'शरीर के लिए लंबा अंडाकार बनाओ', shape: 'oval'),
      DrawStep(stepNumber: 2, instruction: 'Add two wings on sides', instructionHi: 'दोनों तरफ पंख बनाओ', shape: 'line'),
      DrawStep(stepNumber: 3, instruction: 'Add a tail at the back', instructionHi: 'पीछे पूँछ बनाओ', shape: 'line'),
    ], finalDescription: 'An airplane ready to fly!'),
  );

  static final _alligator = WordData(
    id: 'a_alligator', word: 'Alligator', wordHi: 'मगरमच्छ', letter: 'A', emoji: '🐊',
    description: 'A big reptile with a long tail and sharp teeth', descriptionHi: 'लंबी पूँछ और नुकीले दाँतों वाला बड़ा सरीसृप', category: 'animal',
    meetContent: MeetContent(
      linesYoung: [
        ScriptLine(speaker: 'character', textEn: 'Snap! I am Alligator!', textHi: 'स्नैप! मैं मगरमच्छ हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I live in water.', textHi: 'मैं पानी में रहता हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I have a long tail.', textHi: 'मेरी लंबी पूँछ है।'),
        ScriptLine(speaker: 'character', textEn: 'I love to swim!', textHi: 'मुझे तैरना बहुत पसंद है!'),
      ],
      linesOlder: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Alligator!', textHi: 'नमस्ते! मैं मगरमच्छ हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I am a reptile with strong jaws.', textHi: 'मैं मज़बूत जबड़ों वाला सरीसृप हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I live near rivers and lakes.', textHi: 'मैं नदियों और झीलों के पास रहता हूँ।'),
        ScriptLine(speaker: 'narrator', textEn: 'Alligators are ancient animals!', textHi: 'मगरमच्छ बहुत पुराने जानवर हैं!'),
      ],
    ),
    thinkGames: [
      ThinkGame(id: 'a_alli_find', type: 'find', title: 'Find the Alligator', instruction: 'Tap the alligator!', instructionHi: 'मगरमच्छ पर टैप करो!', config: {'correct': '🐊', 'options': ['🐊','🐸','🐢','🦎']}),
    ],
    talkLines: [TalkLine(textEn: 'The alligator swims.', textHi: 'मगरमच्छ तैरता है।')],
    writeContent: WriteContent(letters: ['A', 'a'], word: 'Gator'),
    drawContent: DrawContent(steps: [
      DrawStep(stepNumber: 1, instruction: 'Draw a long oval body', instructionHi: 'एक लंबा अंडाकार शरीर बनाओ', shape: 'oval'),
      DrawStep(stepNumber: 2, instruction: 'Add 4 short legs', instructionHi: '4 छोटे पैर बनाओ', shape: 'line'),
      DrawStep(stepNumber: 3, instruction: 'Draw zigzag teeth', instructionHi: 'ज़िगज़ैग दाँत बनाओ', shape: 'line'),
    ], finalDescription: 'A friendly alligator!'),
  );
}
