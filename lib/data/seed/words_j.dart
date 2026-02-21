import '../models/models.dart';

class WordsJ {
  static List<WordData> get words => [
    WordData(id: 'j_jellyfish', word: 'Jellyfish', wordHi: 'जेलीफ़िश', letter: 'J', emoji: '🪼',
      description: 'A soft sea creature', descriptionHi: 'एक नरम समुद्री जीव', category: 'animals',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'Hi! I am a Jellyfish!', textHi: 'नमस्ते! मैं जेलीफ़िश हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Jellyfish float in the ocean!', textHi: 'जेलीफ़िश समुद्र में तैरती है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am a Jellyfish!', textHi: 'नमस्ते! मैं जेलीफ़िश हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Jellyfish have no bones - they are made of jelly!', textHi: 'जेलीफ़िश में हड्डियाँ नहीं होतीं - वे जेली से बनी हैं!')]),
      thinkGames: [ThinkGame(id: 'j_jelly_find', type: 'find', title: 'Find Jellyfish', instruction: 'Tap the jellyfish!', instructionHi: 'जेलीफ़िश पर टैप करो!', config: {'options': ['🪼','🐙','🦀','🐠'], 'correct': '🪼'})],
      talkLines: [TalkLine(textEn: 'The jellyfish swims.', textHi: 'जेलीफ़िश तैरती है।')],
      writeContent: WriteContent(letters: ['J'], word: 'Jelly'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a dome shape', instructionHi: 'गुंबद बनाओ', shape: 'curve'), DrawStep(stepNumber: 2, instruction: 'Add wavy tentacles', instructionHi: 'लहरदार तंतु बनाओ', shape: 'curve')], finalDescription: 'A floating jellyfish!')),
    WordData(id: 'j_juice', word: 'Juice', wordHi: 'जूस', letter: 'J', emoji: '🧃',
      description: 'A drink made from fruits', descriptionHi: 'फलों से बना पेय', category: 'food',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am Juice!', textHi: 'मैं जूस हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Juice comes from fruits!', textHi: 'जूस फलों से बनता है!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Hello! I am Juice!', textHi: 'नमस्ते! मैं जूस हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Orange juice, apple juice - so many kinds!', textHi: 'संतरे का जूस, सेब का जूस - कितने प्रकार!')]),
      thinkGames: [ThinkGame(id: 'j_juice_find', type: 'find', title: 'Find Juice', instruction: 'Tap the juice!', instructionHi: 'जूस पर टैप करो!', config: {'options': ['🧃','🥛','☕','🍵'], 'correct': '🧃'})],
      talkLines: [TalkLine(textEn: 'I drink juice.', textHi: 'मैं जूस पीता हूँ।')],
      writeContent: WriteContent(letters: ['J'], word: 'Juice'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw a glass', instructionHi: 'गिलास बनाओ', shape: 'rectangle'), DrawStep(stepNumber: 2, instruction: 'Color it orange', instructionHi: 'इसे नारंगी रंग दो', shape: 'rectangle')], finalDescription: 'Fresh juice!')),
    WordData(id: 'j_jungle', word: 'Jungle', wordHi: 'जंगल', letter: 'J', emoji: '🌴',
      description: 'A place with many trees and animals', descriptionHi: 'पेड़ों और जानवरों से भरी जगह', category: 'nature',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am the Jungle!', textHi: 'मैं जंगल हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'The jungle has many trees and animals!', textHi: 'जंगल में बहुत पेड़ और जानवर हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Welcome to the Jungle!', textHi: 'जंगल में आपका स्वागत है!'), ScriptLine(speaker: 'narrator', textEn: 'Jungles are full of life - birds, monkeys, and tigers!', textHi: 'जंगल जीवन से भरे हैं - पक्षी, बंदर, और बाघ!')]),
      thinkGames: [ThinkGame(id: 'j_jungle_find', type: 'find', title: 'Find Jungle', instruction: 'Tap the jungle!', instructionHi: 'जंगल पर टैप करो!', config: {'options': ['🌴','🏖️','🏙️','🏔️'], 'correct': '🌴'})],
      talkLines: [TalkLine(textEn: 'The jungle is green.', textHi: 'जंगल हरा है।')],
      writeContent: WriteContent(letters: ['J'], word: 'Jungle'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw tall trees', instructionHi: 'ऊँचे पेड़ बनाओ', shape: 'line'), DrawStep(stepNumber: 2, instruction: 'Add leaves and vines', instructionHi: 'पत्तियाँ और बेलें बनाओ', shape: 'curve')], finalDescription: 'A wild jungle!')),
    WordData(id: 'j_jet', word: 'Jet', wordHi: 'जेट', letter: 'J', emoji: '✈️',
      description: 'A fast airplane', descriptionHi: 'एक तेज़ हवाई जहाज़', category: 'transport',
      meetContent: MeetContent(linesYoung: [ScriptLine(speaker: 'character', textEn: 'I am a Jet!', textHi: 'मैं जेट हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Jets fly very fast in the sky!', textHi: 'जेट आसमान में बहुत तेज़ उड़ते हैं!')], linesOlder: [ScriptLine(speaker: 'character', textEn: 'Zoom! I am a Jet!', textHi: 'ज़ूम! मैं जेट हूँ!'), ScriptLine(speaker: 'narrator', textEn: 'Jets can carry hundreds of people across the world!', textHi: 'जेट सैकड़ों लोगों को दुनिया भर में ले जा सकते हैं!')]),
      thinkGames: [ThinkGame(id: 'j_jet_find', type: 'find', title: 'Find Jet', instruction: 'Tap the jet!', instructionHi: 'जेट पर टैप करो!', config: {'options': ['✈️','🚗','🚂','🚢'], 'correct': '✈️'})],
      talkLines: [TalkLine(textEn: 'The jet is fast.', textHi: 'जेट तेज़ है।')],
      writeContent: WriteContent(letters: ['J'], word: 'Jet'),
      drawContent: DrawContent(steps: [DrawStep(stepNumber: 1, instruction: 'Draw the body tube', instructionHi: 'शरीर का ट्यूब बनाओ', shape: 'oval'), DrawStep(stepNumber: 2, instruction: 'Add wings', instructionHi: 'पंख बनाओ', shape: 'line'), DrawStep(stepNumber: 3, instruction: 'Add a tail', instructionHi: 'पूँछ बनाओ', shape: 'line')], finalDescription: 'A speedy jet!')),
  ];
}
