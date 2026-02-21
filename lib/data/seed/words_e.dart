import '../models/models.dart';

class WordsE {
  static List<WordData> get words => [_elephant, _egg, _earth, _eagle];

  static WordData _w(String id, String word, String hi, String emoji, String desc, String descHi, String cat,
      List<ScriptLine> y, List<ScriptLine> o, List<ThinkGame> g, String te, String th, List<DrawStep> d, String dd) {
    return WordData(id:id,word:word,wordHi:hi,letter:'E',emoji:emoji,description:desc,descriptionHi:descHi,category:cat,
      meetContent:MeetContent(linesYoung:y,linesOlder:o),thinkGames:g,talkLines:[TalkLine(textEn:te,textHi:th)],
      writeContent:WriteContent(letters:['E','e'],word:word),drawContent:DrawContent(steps:d,finalDescription:dd));
  }

  static final _elephant = _w('e_elephant','Elephant','हाथी','🐘','The biggest animal on land','ज़मीन पर सबसे बड़ा जानवर','animal',
    [ScriptLine(speaker:'character',textEn:'Trumpet! I am Elephant!',textHi:'तुरही! मैं हाथी हूँ!'),ScriptLine(speaker:'character',textEn:'I am very big and strong.',textHi:'मैं बहुत बड़ा और मज़बूत हूँ।'),ScriptLine(speaker:'character',textEn:'My nose is called a trunk!',textHi:'मेरी नाक को सूँड कहते हैं!'),ScriptLine(speaker:'character',textEn:'I love water!',textHi:'मुझे पानी पसंद है!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Elephant!',textHi:'नमस्ते! मैं हाथी हूँ!'),ScriptLine(speaker:'character',textEn:'I am the largest land animal!',textHi:'मैं ज़मीन का सबसे बड़ा जानवर हूँ!'),ScriptLine(speaker:'character',textEn:'My trunk can hold water, grab food, and even hug!',textHi:'मेरी सूँड पानी पकड़ सकती है, खाना उठा सकती है, और गले भी लगा सकती है!'),ScriptLine(speaker:'narrator',textEn:'Elephants have amazing memories!',textHi:'हाथियों की याददाश्त अद्भुत होती है!')],
    [ThinkGame(id:'e_ele_find',type:'find',title:'Find the Elephant',instruction:'Tap the biggest animal!',instructionHi:'सबसे बड़े जानवर पर टैप करो!',config:{'correct':'🐘','options':['🐘','🐭','🐱','🐰']})],
    'The elephant is big.','हाथी बड़ा है।',
    [DrawStep(stepNumber:1,instruction:'Draw big oval body',instructionHi:'बड़ा अंडाकार शरीर बनाओ',shape:'oval'),DrawStep(stepNumber:2,instruction:'Add circle head with trunk',instructionHi:'गोल सिर और सूँड बनाओ',shape:'curve'),DrawStep(stepNumber:3,instruction:'Add 4 thick legs and big ears',instructionHi:'4 मोटे पैर और बड़े कान बनाओ',shape:'line')],'A mighty elephant!');

  static final _egg = _w('e_egg','Egg','अंडा','🥚','An oval thing that baby birds come from','एक अंडाकार चीज़ जिसमें से बच्चे पक्षी निकलते हैं','food',
    [ScriptLine(speaker:'character',textEn:'Crack! I am Egg!',textHi:'क्रैक! मैं अंडा हूँ!'),ScriptLine(speaker:'character',textEn:'I am oval and smooth.',textHi:'मैं अंडाकार और चिकना हूँ।'),ScriptLine(speaker:'character',textEn:'A baby chick lives inside me!',textHi:'मेरे अंदर एक बच्चा चूज़ा रहता है!'),ScriptLine(speaker:'character',textEn:'I can be cooked many ways!',textHi:'मुझे कई तरह से पकाया जा सकता है!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Egg!',textHi:'नमस्ते! मैं अंडा हूँ!'),ScriptLine(speaker:'character',textEn:'I am full of protein and nutrients!',textHi:'मैं प्रोटीन और पोषक तत्वों से भरा हूँ!'),ScriptLine(speaker:'character',textEn:'Birds, reptiles, and fish all lay eggs!',textHi:'पक्षी, सरीसृप, और मछलियाँ सब अंडे देते हैं!'),ScriptLine(speaker:'narrator',textEn:'Eggs are nature\'s perfect package!',textHi:'अंडे प्रकृति का परफेक्ट पैकेज हैं!')],
    [ThinkGame(id:'e_egg_find',type:'find',title:'Find the Egg',instruction:'Tap the egg!',instructionHi:'अंडे पर टैप करो!',config:{'correct':'🥚','options':['🥚','🏀','🎾','🧅']})],
    'I eat an egg.','मैं अंडा खाता हूँ।',
    [DrawStep(stepNumber:1,instruction:'Draw an oval',instructionHi:'एक अंडाकार बनाओ',shape:'oval')],'A perfect egg!');

  static final _earth = _w('e_earth','Earth','पृथ्वी','🌍','Our beautiful planet','हमारा सुंदर ग्रह','nature',
    [ScriptLine(speaker:'character',textEn:'Spin! I am Earth!',textHi:'घूमो! मैं पृथ्वी हूँ!'),ScriptLine(speaker:'character',textEn:'I am blue and green.',textHi:'मैं नीली और हरी हूँ।'),ScriptLine(speaker:'character',textEn:'You live on me!',textHi:'तुम मुझ पर रहते हो!'),ScriptLine(speaker:'character',textEn:'I have oceans and mountains!',textHi:'मेरे पास समुद्र और पहाड़ हैं!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Earth!',textHi:'नमस्ते! मैं पृथ्वी हूँ!'),ScriptLine(speaker:'character',textEn:'I am the third planet from the Sun.',textHi:'मैं सूर्य से तीसरा ग्रह हूँ।'),ScriptLine(speaker:'character',textEn:'I spin around once every 24 hours—that makes a day!',textHi:'मैं हर 24 घंटे में एक बार घूमती हूँ—यही एक दिन बनाता है!'),ScriptLine(speaker:'narrator',textEn:'Let\'s take care of our beautiful Earth!',textHi:'चलो अपनी सुंदर पृथ्वी की देखभाल करें!')],
    [ThinkGame(id:'e_earth_find',type:'find',title:'Find Earth',instruction:'Tap our planet!',instructionHi:'हमारे ग्रह पर टैप करो!',config:{'correct':'🌍','options':['🌍','🌙','⭐','☀️']})],
    'Earth is our home.','पृथ्वी हमारा घर है।',
    [DrawStep(stepNumber:1,instruction:'Draw a big circle',instructionHi:'एक बड़ा गोला बनाओ',shape:'circle'),DrawStep(stepNumber:2,instruction:'Add wavy land shapes inside',instructionHi:'अंदर लहरदार ज़मीन के आकार बनाओ',shape:'curve')],'Our beautiful Earth!');

  static final _eagle = _w('e_eagle','Eagle','चील','🦅','A powerful bird that flies very high','एक शक्तिशाली पक्षी जो बहुत ऊँचा उड़ता है','bird',
    [ScriptLine(speaker:'character',textEn:'Screech! I am Eagle!',textHi:'चीं! मैं चील हूँ!'),ScriptLine(speaker:'character',textEn:'I fly very high!',textHi:'मैं बहुत ऊँचा उड़ता हूँ!'),ScriptLine(speaker:'character',textEn:'I have sharp eyes.',textHi:'मेरी तेज़ आँखें हैं।'),ScriptLine(speaker:'character',textEn:'I am the king of birds!',textHi:'मैं पक्षियों का राजा हूँ!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Eagle!',textHi:'नमस्ते! मैं चील हूँ!'),ScriptLine(speaker:'character',textEn:'I can spot a mouse from miles away!',textHi:'मैं मीलों दूर से चूहा देख सकता हूँ!'),ScriptLine(speaker:'character',textEn:'My wings can spread very wide!',textHi:'मेरे पंख बहुत चौड़े फैल सकते हैं!'),ScriptLine(speaker:'narrator',textEn:'Eagles symbolize strength and freedom!',textHi:'चील शक्ति और स्वतंत्रता का प्रतीक है!')],
    [ThinkGame(id:'e_eagle_find',type:'find',title:'Find the Eagle',instruction:'Tap the eagle!',instructionHi:'चील पर टैप करो!',config:{'correct':'🦅','options':['🦅','🐦','🦜','🦉']})],
    'The eagle flies high.','चील ऊँचा उड़ती है।',
    [DrawStep(stepNumber:1,instruction:'Draw V shape for wings',instructionHi:'पंखों के लिए V आकार बनाओ',shape:'line'),DrawStep(stepNumber:2,instruction:'Add body in the middle',instructionHi:'बीच में शरीर बनाओ',shape:'oval'),DrawStep(stepNumber:3,instruction:'Add curved beak',instructionHi:'घुमावदार चोंच बनाओ',shape:'curve')],'A soaring eagle!');
}
