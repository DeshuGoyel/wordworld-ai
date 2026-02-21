import '../models/models.dart';

class WordsF {
  static List<WordData> get words => [_fish, _frog, _flower, _fire];

  static WordData _w(String id, String word, String hi, String emoji, String desc, String descHi, String cat,
      List<ScriptLine> y, List<ScriptLine> o, String te, String th, List<DrawStep> d, String dd) {
    return WordData(id:id,word:word,wordHi:hi,letter:'F',emoji:emoji,description:desc,descriptionHi:descHi,category:cat,
      meetContent:MeetContent(linesYoung:y,linesOlder:o),
      thinkGames:[ThinkGame(id:'${id}_find',type:'find',title:'Find the $word',instruction:'Tap the $word!',instructionHi:'$hi पर टैप करो!',config:{'correct':emoji,'options':[emoji,'🎈','🎪','🧩']})],
      talkLines:[TalkLine(textEn:te,textHi:th)],writeContent:WriteContent(letters:['F','f'],word:word),
      drawContent:DrawContent(steps:d,finalDescription:dd));
  }

  static final _fish = _w('f_fish','Fish','मछली','🐟','A creature that lives and swims in water','पानी में रहने और तैरने वाला जीव','animal',
    [ScriptLine(speaker:'character',textEn:'Splash! I am Fish!',textHi:'छपाक! मैं मछली हूँ!'),ScriptLine(speaker:'character',textEn:'I live in water.',textHi:'मैं पानी में रहती हूँ।'),ScriptLine(speaker:'character',textEn:'I have fins to swim!',textHi:'मेरे तैरने के लिए पंख हैं!'),ScriptLine(speaker:'character',textEn:'I breathe through gills.',textHi:'मैं गलफड़ों से साँस लेती हूँ।')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Fish!',textHi:'नमस्ते! मैं मछली हूँ!'),ScriptLine(speaker:'character',textEn:'There are thousands of fish species!',textHi:'मछलियों की हज़ारों प्रजातियाँ हैं!'),ScriptLine(speaker:'character',textEn:'I use my tail to steer through water.',textHi:'मैं पानी में दिशा बदलने के लिए अपनी पूँछ का उपयोग करती हूँ।'),ScriptLine(speaker:'narrator',textEn:'Fish are incredible swimmers!',textHi:'मछलियाँ अद्भुत तैराक हैं!')],
    'The fish swims fast.','मछली तेज़ तैरती है।',
    [DrawStep(stepNumber:1,instruction:'Draw oval body',instructionHi:'अंडाकार शरीर बनाओ',shape:'oval'),DrawStep(stepNumber:2,instruction:'Add triangle tail',instructionHi:'त्रिकोण पूँछ बनाओ',shape:'line'),DrawStep(stepNumber:3,instruction:'Add fins and eye',instructionHi:'पंख और आँख बनाओ',shape:'curve')],'A beautiful fish!');

  static final _frog = _w('f_frog','Frog','मेंढक','🐸','A green amphibian that jumps and croaks','एक हरा उभयचर जो कूदता और टर्राता है','animal',
    [ScriptLine(speaker:'character',textEn:'Ribbit! I am Frog!',textHi:'टर्र! मैं मेंढक हूँ!'),ScriptLine(speaker:'character',textEn:'I jump really high!',textHi:'मैं बहुत ऊँचा कूदता हूँ!'),ScriptLine(speaker:'character',textEn:'I catch flies with my tongue!',textHi:'मैं अपनी जीभ से मक्खियाँ पकड़ता हूँ!'),ScriptLine(speaker:'character',textEn:'I love the rain!',textHi:'मुझे बारिश पसंद है!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Frog!',textHi:'नमस्ते! मैं मेंढक हूँ!'),ScriptLine(speaker:'character',textEn:'I was a tadpole when I was a baby!',textHi:'बचपन में मैं एक टैडपोल था!'),ScriptLine(speaker:'character',textEn:'I can live on land and in water!',textHi:'मैं ज़मीन और पानी दोनों पर रह सकता हूँ!'),ScriptLine(speaker:'narrator',textEn:'Frogs help control insects!',textHi:'मेंढक कीड़ों को नियंत्रित करने में मदद करते हैं!')],
    'The frog can jump.','मेंढक कूद सकता है।',
    [DrawStep(stepNumber:1,instruction:'Draw round body',instructionHi:'गोल शरीर बनाओ',shape:'circle'),DrawStep(stepNumber:2,instruction:'Add big round eyes on top',instructionHi:'ऊपर बड़ी गोल आँखें बनाओ',shape:'circle'),DrawStep(stepNumber:3,instruction:'Add bent legs',instructionHi:'मुड़े हुए पैर बनाओ',shape:'curve')],'A jumping frog!');

  static final _flower = _w('f_flower','Flower','फूल','🌸','A beautiful colorful part of a plant','पौधे का एक सुंदर रंगीन हिस्सा','nature',
    [ScriptLine(speaker:'character',textEn:'Bloom! I am Flower!',textHi:'खिलो! मैं फूल हूँ!'),ScriptLine(speaker:'character',textEn:'I am colorful and pretty.',textHi:'मैं रंगीन और सुंदर हूँ।'),ScriptLine(speaker:'character',textEn:'Bees love to visit me!',textHi:'मधुमक्खियाँ मुझ पर आना पसंद करती हैं!'),ScriptLine(speaker:'character',textEn:'I smell so nice!',textHi:'मेरी खुशबू बहुत अच्छी है!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Flower!',textHi:'नमस्ते! मैं फूल हूँ!'),ScriptLine(speaker:'character',textEn:'I grow from tiny seeds!',textHi:'मैं छोटे बीजों से उगता हूँ!'),ScriptLine(speaker:'character',textEn:'Bees collect nectar from me to make honey!',textHi:'मधुमक्खियाँ मुझसे रस इकट्ठा करके शहद बनाती हैं!'),ScriptLine(speaker:'narrator',textEn:'Flowers make the world beautiful!',textHi:'फूल दुनिया को सुंदर बनाते हैं!')],
    'The flower is pretty.','फूल सुंदर है।',
    [DrawStep(stepNumber:1,instruction:'Draw a small circle center',instructionHi:'बीच में छोटा गोला बनाओ',shape:'circle'),DrawStep(stepNumber:2,instruction:'Add oval petals around',instructionHi:'चारों ओर अंडाकार पंखुड़ियाँ बनाओ',shape:'oval'),DrawStep(stepNumber:3,instruction:'Add stem and leaves',instructionHi:'तना और पत्ते बनाओ',shape:'line')],'A beautiful flower!');

  static final _fire = _w('f_fire','Fire','आग','🔥','Hot flames that give light and warmth','गर्म लपटें जो रोशनी और गर्मी देती हैं','nature',
    [ScriptLine(speaker:'character',textEn:'Crackle! I am Fire!',textHi:'चटक! मैं आग हूँ!'),ScriptLine(speaker:'character',textEn:'I am hot and bright.',textHi:'मैं गर्म और चमकीली हूँ।'),ScriptLine(speaker:'character',textEn:'I give light at night.',textHi:'मैं रात में रोशनी देती हूँ।'),ScriptLine(speaker:'character',textEn:'Be careful around me!',textHi:'मेरे पास सावधान रहो!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Fire!',textHi:'नमस्ते! मैं आग हूँ!'),ScriptLine(speaker:'character',textEn:'I help cook food and keep you warm.',textHi:'मैं खाना पकाने और तुम्हें गर्म रखने में मदद करती हूँ।'),ScriptLine(speaker:'character',textEn:'But always be safe around me!',textHi:'लेकिन मेरे पास हमेशा सुरक्षित रहो!'),ScriptLine(speaker:'narrator',textEn:'Fire is useful but must be handled with care!',textHi:'आग उपयोगी है लेकिन सावधानी से इस्तेमाल करनी चाहिए!')],
    'Fire is hot.','आग गर्म है।',
    [DrawStep(stepNumber:1,instruction:'Draw a teardrop shape',instructionHi:'आँसू का आकार बनाओ',shape:'curve'),DrawStep(stepNumber:2,instruction:'Add wavy lines inside',instructionHi:'अंदर लहरदार रेखाएँ बनाओ',shape:'curve')],'Dancing fire!');
}
