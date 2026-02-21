import '../models/models.dart';

class WordsH {
  static List<WordData> get words => [_hat, _horse, _house, _heart];

  static WordData _w(String id, String word, String hi, String emoji, String desc, String descHi, String cat,
      List<ScriptLine> y, List<ScriptLine> o, String te, String th, List<DrawStep> d, String dd) {
    return WordData(id:id,word:word,wordHi:hi,letter:'H',emoji:emoji,description:desc,descriptionHi:descHi,category:cat,
      meetContent:MeetContent(linesYoung:y,linesOlder:o),
      thinkGames:[ThinkGame(id:'${id}_find',type:'find',title:'Find the $word',instruction:'Tap the $word!',instructionHi:'$hi पर टैप करो!',config:{'correct':emoji,'options':[emoji,'🎈','🧩','🎪']})],
      talkLines:[TalkLine(textEn:te,textHi:th)],writeContent:WriteContent(letters:['H','h'],word:word),
      drawContent:DrawContent(steps:d,finalDescription:dd));
  }

  static final _hat = _w('h_hat','Hat','टोपी','🎩','Something you wear on your head','कुछ जो तुम अपने सिर पर पहनते हो','clothing',
    [ScriptLine(speaker:'character',textEn:'Ta-da! I am Hat!',textHi:'टा-डा! मैं टोपी हूँ!'),ScriptLine(speaker:'character',textEn:'I sit on your head.',textHi:'मैं तुम्हारे सिर पर बैठती हूँ।'),ScriptLine(speaker:'character',textEn:'I protect you from the sun!',textHi:'मैं तुम्हें धूप से बचाती हूँ!'),ScriptLine(speaker:'character',textEn:'I come in many shapes!',textHi:'मैं कई आकारों में आती हूँ!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Hat!',textHi:'नमस्ते! मैं टोपी हूँ!'),ScriptLine(speaker:'character',textEn:'People have worn hats for thousands of years!',textHi:'लोग हज़ारों सालों से टोपी पहनते आ रहे हैं!'),ScriptLine(speaker:'character',textEn:'I can be a cap, a crown, or even a helmet!',textHi:'मैं टोपी, मुकुट, या हेलमेट भी हो सकती हूँ!'),ScriptLine(speaker:'narrator',textEn:'Hats show style and protect us!',textHi:'टोपियाँ स्टाइल दिखाती हैं और हमें बचाती हैं!')],
    'I wear a hat.','मैं टोपी पहनता हूँ।',
    [DrawStep(stepNumber:1,instruction:'Draw a curved top',instructionHi:'एक घुमावदार ऊपरी हिस्सा बनाओ',shape:'curve'),DrawStep(stepNumber:2,instruction:'Add a wide brim',instructionHi:'एक चौड़ा किनारा बनाओ',shape:'line')],'A stylish hat!');

  static final _horse = _w('h_horse','Horse','घोड़ा','🐴','A strong animal that people ride','एक मज़बूत जानवर जिस पर लोग सवारी करते हैं','animal',
    [ScriptLine(speaker:'character',textEn:'Neigh! I am Horse!',textHi:'हिनहिन! मैं घोड़ा हूँ!'),ScriptLine(speaker:'character',textEn:'I run very fast!',textHi:'मैं बहुत तेज़ दौड़ता हूँ!'),ScriptLine(speaker:'character',textEn:'I have a beautiful mane.',textHi:'मेरी सुंदर अयाल है।'),ScriptLine(speaker:'character',textEn:'You can ride on my back!',textHi:'तुम मेरी पीठ पर सवारी कर सकते हो!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Horse!',textHi:'नमस्ते! मैं घोड़ा हूँ!'),ScriptLine(speaker:'character',textEn:'I have been helping humans for thousands of years!',textHi:'मैं हज़ारों सालों से इंसानों की मदद कर रहा हूँ!'),ScriptLine(speaker:'character',textEn:'I can gallop, trot, and canter!',textHi:'मैं सरपट, दुलकी और कैंटर चाल चल सकता हूँ!'),ScriptLine(speaker:'narrator',textEn:'Horses are symbols of grace and power!',textHi:'घोड़े शान और शक्ति के प्रतीक हैं!')],
    'The horse runs fast.','घोड़ा तेज़ दौड़ता है।',
    [DrawStep(stepNumber:1,instruction:'Draw oval body',instructionHi:'अंडाकार शरीर बनाओ',shape:'oval'),DrawStep(stepNumber:2,instruction:'Add long neck and head',instructionHi:'लंबी गर्दन और सिर बनाओ',shape:'curve'),DrawStep(stepNumber:3,instruction:'Add 4 long legs and tail',instructionHi:'4 लंबे पैर और पूँछ बनाओ',shape:'line')],'A galloping horse!');

  static final _house = _w('h_house','House','घर','🏠','A building where families live','एक इमारत जहाँ परिवार रहते हैं','building',
    [ScriptLine(speaker:'character',textEn:'Welcome! I am House!',textHi:'स्वागत! मैं घर हूँ!'),ScriptLine(speaker:'character',textEn:'I keep families safe and warm.',textHi:'मैं परिवारों को सुरक्षित और गर्म रखता हूँ।'),ScriptLine(speaker:'character',textEn:'I have rooms, windows, and a door!',textHi:'मेरे कमरे, खिड़कियाँ और दरवाज़ा है!'),ScriptLine(speaker:'character',textEn:'Home sweet home!',textHi:'घर प्यारा घर!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am House!',textHi:'नमस्ते! मैं घर हूँ!'),ScriptLine(speaker:'character',textEn:'I can be made of bricks, wood, or even mud!',textHi:'मैं ईंटों, लकड़ी, या मिट्टी से भी बन सकता हूँ!'),ScriptLine(speaker:'character',textEn:'Every house is special to its family.',textHi:'हर घर अपने परिवार के लिए खास होता है।'),ScriptLine(speaker:'narrator',textEn:'A house becomes a home with love!',textHi:'प्यार से घर एक होम बनता है!')],
    'This is my house.','यह मेरा घर है।',
    [DrawStep(stepNumber:1,instruction:'Draw a square for walls',instructionHi:'दीवारों के लिए चौकोर बनाओ',shape:'rectangle'),DrawStep(stepNumber:2,instruction:'Add triangle roof on top',instructionHi:'ऊपर त्रिकोण छत बनाओ',shape:'line'),DrawStep(stepNumber:3,instruction:'Add door and windows',instructionHi:'दरवाज़ा और खिड़कियाँ बनाओ',shape:'rectangle')],'A cozy house!');

  static final _heart = _w('h_heart','Heart','दिल','❤️','A shape that means love','एक आकार जो प्यार का मतलब है','symbol',
    [ScriptLine(speaker:'character',textEn:'Thump! I am Heart!',textHi:'धड़क! मैं दिल हूँ!'),ScriptLine(speaker:'character',textEn:'I mean love and kindness.',textHi:'मेरा मतलब प्यार और दयालुता है।'),ScriptLine(speaker:'character',textEn:'I beat inside your chest!',textHi:'मैं तुम्हारी छाती में धड़कता हूँ!'),ScriptLine(speaker:'character',textEn:'I pump blood to keep you alive!',textHi:'मैं खून पंप करता हूँ ताकि तुम जीवित रहो!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Heart!',textHi:'नमस्ते! मैं दिल हूँ!'),ScriptLine(speaker:'character',textEn:'I beat about 100,000 times every day!',textHi:'मैं हर दिन लगभग 1,00,000 बार धड़कता हूँ!'),ScriptLine(speaker:'character',textEn:'Exercise makes me stronger!',textHi:'कसरत मुझे मज़बूत बनाती है!'),ScriptLine(speaker:'narrator',textEn:'A healthy heart means a healthy life!',textHi:'स्वस्थ दिल का मतलब स्वस्थ जीवन!')],
    'I love my family.','मैं अपने परिवार से प्यार करता हूँ।',
    [DrawStep(stepNumber:1,instruction:'Draw two bumps at top',instructionHi:'ऊपर दो उभार बनाओ',shape:'curve'),DrawStep(stepNumber:2,instruction:'Connect them to a point at bottom',instructionHi:'उन्हें नीचे एक बिंदु पर जोड़ो',shape:'line')],'A lovely heart!');
}
