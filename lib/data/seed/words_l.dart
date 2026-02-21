import '../models/models.dart';

class WordsL {
  static List<WordData> get words => [
    WordData(id: 'l_lion', word: 'Lion', wordHi: 'शेर', letter: 'L', emoji: '🦁',
      description: 'The king of the jungle', descriptionHi: 'जंगल का राजा', category: 'animals',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'Roar! I am a Lion!', textHi: 'दहाड़! मैं शेर हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Lions are big and brave!', textHi: 'शेर बड़े और बहादुर होते हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'I am the Lion, king of the jungle!', textHi: 'मैं शेर हूँ, जंगल का राजा!'), ScriptLine(speaker: 'narrator', textEn: 'Lions live in groups called prides.', textHi: 'शेर झुंड में रहते हैं जिसे प्राइड कहते हैं।')]),
      thinkGames: [ThinkGame(id: 'l_lion_find', type: 'find', title: 'Find Lion', instruction: 'Tap the lion!', instructionHi: 'शेर पर टैप करो!', config: {'options': ['🦁','🐯','🐻','🐺'], 'correct': '🦁'})],
      talkLines: [TalkLine(textEn: 'The lion roars.', textHi: 'शेर दहाड़ता है।')],
      writeContent: WriteContent(letters: ['L'], word: 'Lion'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a round face', instructionHi: 'गोल चेहरा बनाओ', shape: 'circle'), DrawStep(stepNumber: 2, instruction: 'Add a big mane around', instructionHi: 'चारों ओर अयाल बनाओ', shape: 'curve'), DrawStep(stepNumber: 3, instruction: 'Add eyes, nose and mouth', instructionHi: 'आँखें, नाक और मुँह बनाओ', shape: 'circle')], finalDescription: 'A mighty lion!')),
    WordData(id: 'l_lamp', word: 'Lamp', wordHi: 'दीपक', letter: 'L', emoji: '💡',
      description: 'Gives us light', descriptionHi: 'हमें रोशनी देता है', category: 'objects',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Lamp!', textHi: 'मैं दीपक हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Lamps give us light in the dark!', textHi: 'दीपक अँधेरे में रोशनी देता है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Lamp!', textHi: 'नमस्ते! मैं दीपक हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'We light lamps on Diwali!', textHi: 'दिवाली पर हम दीपक जलाते हैं!')]),
      thinkGames: [ThinkGame(id: 'l_lamp_find', type: 'find', title: 'Find Lamp', instruction: 'Tap the lamp!', instructionHi: 'दीपक पर टैप करो!', config: {'options': ['💡','🔦','🕯️','☀️'], 'correct': '💡'})],
      talkLines: [TalkLine(textEn: 'Turn on the lamp.', textHi: 'दीपक जलाओ।')],
      writeContent: WriteContent(letters: ['L'], word: 'Lamp'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw the base', instructionHi: 'आधार बनाओ', shape: 'rectangle'), DrawStep(stepNumber: 2, instruction: 'Add the shade', instructionHi: 'छाया बनाओ', shape: 'triangle')], finalDescription: 'A bright lamp!')),
    WordData(id: 'l_leaf', word: 'Leaf', wordHi: 'पत्ता', letter: 'L', emoji: '🍃',
      description: 'Grows on trees', descriptionHi: 'पेड़ों पर उगता है', category: 'nature',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Leaf!', textHi: 'मैं पत्ता हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Leaves are green and beautiful!', textHi: 'पत्ते हरे और सुंदर होते हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Leaf!', textHi: 'नमस्ते! मैं पत्ता हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Leaves make food for trees using sunlight!', textHi: 'पत्ते सूरज की रोशनी से पेड़ के लिए खाना बनाते हैं!')]),
      thinkGames: [ThinkGame(id: 'l_leaf_find', type: 'find', title: 'Find Leaf', instruction: 'Tap the leaf!', instructionHi: 'पत्ते पर टैप करो!', config: {'options': ['🍃','🌸','🍎','🌻'], 'correct': '🍃'})],
      talkLines: [TalkLine(textEn: 'The leaf is green.', textHi: 'पत्ता हरा है।')],
      writeContent: WriteContent(letters: ['L'], word: 'Leaf'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw an oval leaf shape', instructionHi: 'अंडाकार पत्ती बनाओ', shape: 'oval'), DrawStep(stepNumber: 2, instruction: 'Add a stem and veins', instructionHi: 'डंठल और नसें बनाओ', shape: 'line')], finalDescription: 'A green leaf!')),
    WordData(id: 'l_ladybug', word: 'Ladybug', wordHi: 'लेडीबग', letter: 'L', emoji: '🐞',
      description: 'A small red beetle with spots', descriptionHi: 'धब्बों वाला छोटा लाल भृंग', category: 'animals',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Ladybug!', textHi: 'मैं लेडीबग हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Ladybugs are red with black dots!', textHi: 'लेडीबग लाल रंग की काले बिंदुओं वाली होती है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Ladybug!', textHi: 'नमस्ते! मैं लेडीबग हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Ladybugs help farmers by eating harmful insects!', textHi: 'लेडीबग हानिकारक कीड़े खाकर किसानों की मदद करती है!')]),
      thinkGames: [ThinkGame(id: 'l_ladybug_find', type: 'find', title: 'Find Ladybug', instruction: 'Tap the ladybug!', instructionHi: 'लेडीबग पर टैप करो!', config: {'options': ['🐞','🐜','🦗','🐝'], 'correct': '🐞'})],
      talkLines: [TalkLine(textEn: 'The ladybug is red.', textHi: 'लेडीबग लाल है।')],
      writeContent: WriteContent(letters: ['L'], word: 'Ladybug'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a round body', instructionHi: 'गोल शरीर बनाओ', shape: 'circle'), DrawStep(stepNumber: 2, instruction: 'Add a line in the middle', instructionHi: 'बीच में एक रेखा बनाओ', shape: 'line'), DrawStep(stepNumber: 3, instruction: 'Add spots and head', instructionHi: 'धब्बे और सिर बनाओ', shape: 'circle')], finalDescription: 'A cute ladybug!')),
  ];
}
