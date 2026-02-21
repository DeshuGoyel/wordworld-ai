import '../models/models.dart';

class WordsB {
  static List<WordData> get words => [_ball, _butterfly, _banana, _bear];

  static final _ball = WordData(
    id: 'b_ball', word: 'Ball', wordHi: 'गेंद', letter: 'B', emoji: '⚽',
    description: 'A round toy you can throw and kick', descriptionHi: 'एक गोल खिलौना जिसे फेंक और किक कर सकते हैं', category: 'toy',
    meetContent: MeetContent(
      linesYoung: [
        ScriptLine(speaker: 'character', textEn: 'Bounce! I am Ball!', textHi: 'बाउंस! मैं गेंद हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I am round and bouncy.', textHi: 'मैं गोल और उछलने वाली हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'You can kick me!', textHi: 'तुम मुझे किक कर सकते हो!'),
        ScriptLine(speaker: 'character', textEn: 'Let us play together!', textHi: 'चलो साथ खेलते हैं!'),
      ],
      linesOlder: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Ball!', textHi: 'नमस्ते! मैं गेंद हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I come in many colors and sizes.', textHi: 'मैं कई रंगों और आकारों में आती हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'You can play football, cricket, basketball with me!', textHi: 'तुम मेरे साथ फुटबॉल, क्रिकेट, बास्केटबॉल खेल सकते हो!'),
        ScriptLine(speaker: 'narrator', textEn: 'Playing ball is great exercise!', textHi: 'गेंद खेलना बहुत अच्छी कसरत है!'),
      ],
    ),
    thinkGames: [
      ThinkGame(id: 'b_ball_find', type: 'find', title: 'Find the Ball', instruction: 'Tap the ball!', instructionHi: 'गेंद पर टैप करो!', config: {'correct': '⚽', 'options': ['⚽','🧸','🪁','🎪']}),
      ThinkGame(id: 'b_ball_match', type: 'match', title: 'Match Sports', instruction: 'Match ball to sport!', instructionHi: 'गेंद को खेल से मिलाओ!', ageMin: 5, config: {'pairs': [{'left':'⚽','right':'Football'},{'left':'🏀','right':'Basketball'},{'left':'🏐','right':'Volleyball'}]}),
    ],
    talkLines: [TalkLine(textEn: 'I like to play ball.', textHi: 'मुझे गेंद खेलना पसंद है।')],
    writeContent: WriteContent(letters: ['B', 'b'], word: 'Ball'),
    drawContent: DrawContent(steps: [
      DrawStep(stepNumber: 1, instruction: 'Draw a big circle', instructionHi: 'एक बड़ा गोला बनाओ', shape: 'circle'),
      DrawStep(stepNumber: 2, instruction: 'Add curved lines inside', instructionHi: 'अंदर घुमावदार रेखाएँ बनाओ', shape: 'curve'),
    ], finalDescription: 'A bouncy ball!'),
  );

  static final _butterfly = WordData(
    id: 'b_butterfly', word: 'Butterfly', wordHi: 'तितली', letter: 'B', emoji: '🦋',
    description: 'A beautiful insect with colorful wings', descriptionHi: 'रंगीन पंखों वाला सुंदर कीड़ा', category: 'insect',
    meetContent: MeetContent(
      linesYoung: [
        ScriptLine(speaker: 'character', textEn: 'Flutter! I am Butterfly!', textHi: 'फड़फड़! मैं तितली हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I have colorful wings.', textHi: 'मेरे रंग-बिरंगे पंख हैं।'),
        ScriptLine(speaker: 'character', textEn: 'I fly from flower to flower.', textHi: 'मैं फूल-फूल पर उड़ती हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I love flowers!', textHi: 'मुझे फूल पसंद हैं!'),
      ],
      linesOlder: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Butterfly!', textHi: 'नमस्ते! मैं तितली हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I was once a tiny caterpillar!', textHi: 'मैं पहले एक छोटी इल्ली थी!'),
        ScriptLine(speaker: 'character', textEn: 'Then I became a butterfly with beautiful wings!', textHi: 'फिर मैं सुंदर पंखों वाली तितली बन गई!'),
        ScriptLine(speaker: 'narrator', textEn: 'Butterflies show us that change is beautiful!', textHi: 'तितलियाँ हमें सिखाती हैं कि बदलाव सुंदर है!'),
      ],
    ),
    thinkGames: [ThinkGame(id: 'b_butt_find', type: 'find', title: 'Find the Butterfly', instruction: 'Tap the butterfly!', instructionHi: 'तितली पर टैप करो!', config: {'correct': '🦋', 'options': ['🦋','🐝','🐜','🐞']})],
    talkLines: [TalkLine(textEn: 'The butterfly is pretty.', textHi: 'तितली सुंदर है।')],
    writeContent: WriteContent(letters: ['B', 'b'], word: 'Fly'),
    drawContent: DrawContent(steps: [
      DrawStep(stepNumber: 1, instruction: 'Draw a small oval body', instructionHi: 'एक छोटा अंडाकार शरीर बनाओ', shape: 'oval'),
      DrawStep(stepNumber: 2, instruction: 'Add 4 big wings', instructionHi: '4 बड़े पंख बनाओ', shape: 'curve'),
      DrawStep(stepNumber: 3, instruction: 'Add colorful circles on wings', instructionHi: 'पंखों पर रंगीन गोले बनाओ', shape: 'circle'),
    ], finalDescription: 'A colorful butterfly!'),
  );

  static final _banana = WordData(
    id: 'b_banana', word: 'Banana', wordHi: 'केला', letter: 'B', emoji: '🍌',
    description: 'A long yellow fruit that monkeys love', descriptionHi: 'एक लंबा पीला फल जो बंदरों को बहुत पसंद है', category: 'fruit',
    meetContent: MeetContent(
      linesYoung: [
        ScriptLine(speaker: 'character', textEn: 'Peel! I am Banana!', textHi: 'छीलो! मैं केला हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I am yellow and curved.', textHi: 'मैं पीला और मुड़ा हुआ हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'Monkeys love me!', textHi: 'बंदर मुझे बहुत पसंद करते हैं!'),
        ScriptLine(speaker: 'character', textEn: 'I am soft and sweet inside.', textHi: 'मैं अंदर से नरम और मीठा हूँ।'),
      ],
      linesOlder: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Banana!', textHi: 'नमस्ते! मैं केला हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I grow in bunches on a plant.', textHi: 'मैं पौधे पर गुच्छों में उगता हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I give you lots of energy!', textHi: 'मैं तुम्हें बहुत ऊर्जा देता हूँ!'),
        ScriptLine(speaker: 'narrator', textEn: 'Bananas are a superfood!', textHi: 'केला एक सुपरफूड है!'),
      ],
    ),
    thinkGames: [ThinkGame(id: 'b_ban_find', type: 'find', title: 'Find the Banana', instruction: 'Tap the banana!', instructionHi: 'केले पर टैप करो!', config: {'correct': '🍌', 'options': ['🍌','🌽','🥒','🫑']})],
    talkLines: [TalkLine(textEn: 'I eat a banana.', textHi: 'मैं केला खाता हूँ।')],
    writeContent: WriteContent(letters: ['B', 'b'], word: 'Ban'),
    drawContent: DrawContent(steps: [
      DrawStep(stepNumber: 1, instruction: 'Draw a curved shape', instructionHi: 'एक घुमावदार आकार बनाओ', shape: 'curve'),
      DrawStep(stepNumber: 2, instruction: 'Add a small stem', instructionHi: 'एक छोटी डंठल बनाओ', shape: 'line'),
    ], finalDescription: 'A yummy banana!'),
  );

  static final _bear = WordData(
    id: 'b_bear', word: 'Bear', wordHi: 'भालू', letter: 'B', emoji: '🐻',
    description: 'A big furry animal that loves honey', descriptionHi: 'एक बड़ा प्यारा जानवर जिसे शहद पसंद है', category: 'animal',
    meetContent: MeetContent(
      linesYoung: [
        ScriptLine(speaker: 'character', textEn: 'Roar! I am Bear!', textHi: 'गर्र! मैं भालू हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I am big and fluffy.', textHi: 'मैं बड़ा और फूला हुआ हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'I love honey!', textHi: 'मुझे शहद बहुत पसंद है!'),
        ScriptLine(speaker: 'character', textEn: 'I sleep all winter long!', textHi: 'मैं पूरी सर्दी सोता हूँ!'),
      ],
      linesOlder: [
        ScriptLine(speaker: 'character', textEn: 'Hello! I am Bear!', textHi: 'नमस्ते! मैं भालू हूँ!'),
        ScriptLine(speaker: 'character', textEn: 'I live in forests and mountains.', textHi: 'मैं जंगलों और पहाड़ों में रहता हूँ।'),
        ScriptLine(speaker: 'character', textEn: 'In winter, I hibernate—that means I sleep for months!', textHi: 'सर्दियों में मैं शीतनिद्रा करता हूँ—मतलब महीनों सोता हूँ!'),
        ScriptLine(speaker: 'narrator', textEn: 'Bears are very clever animals!', textHi: 'भालू बहुत चतुर जानवर हैं!'),
      ],
    ),
    thinkGames: [ThinkGame(id: 'b_bear_find', type: 'find', title: 'Find the Bear', instruction: 'Tap the bear!', instructionHi: 'भालू पर टैप करो!', config: {'correct': '🐻', 'options': ['🐻','🐶','🐱','🐰']})],
    talkLines: [TalkLine(textEn: 'The bear is big.', textHi: 'भालू बड़ा है।')],
    writeContent: WriteContent(letters: ['B', 'b'], word: 'Bear'),
    drawContent: DrawContent(steps: [
      DrawStep(stepNumber: 1, instruction: 'Draw a big circle for body', instructionHi: 'शरीर के लिए बड़ा गोला बनाओ', shape: 'circle'),
      DrawStep(stepNumber: 2, instruction: 'Add a smaller circle for head', instructionHi: 'सिर के लिए छोटा गोला बनाओ', shape: 'circle'),
      DrawStep(stepNumber: 3, instruction: 'Add round ears and small eyes', instructionHi: 'गोल कान और छोटी आँखें बनाओ', shape: 'circle'),
    ], finalDescription: 'A cuddly bear!'),
  );
}
