import '../models/models.dart';

class WordsC {
  static List<WordData> get words => [_cat, _car, _cake, _cloud];

  static WordData _makeWord(String id, String word, String hi, String emoji, String desc, String descHi, String cat,
      List<ScriptLine> young, List<ScriptLine> older, List<ThinkGame> games, String talkEn, String talkHi, List<DrawStep> draw, String drawDesc) {
    return WordData(id: id, word: word, wordHi: hi, letter: 'C', emoji: emoji, description: desc, descriptionHi: descHi, category: cat,
      meetContent: MeetContent(linesYoung: young, linesOlder: older), thinkGames: games,
      talkLines: [TalkLine(textEn: talkEn, textHi: talkHi)],
      writeContent: WriteContent(letters: ['C', 'c'], word: word),
      drawContent: DrawContent(steps: draw, finalDescription: drawDesc));
  }

  static final _cat = _makeWord('c_cat', 'Cat', 'बिल्ली', '🐱', 'A soft furry pet that says meow', 'एक नरम प्यारा पालतू जो म्याऊँ बोलता है', 'animal',
    [ScriptLine(speaker:'character',textEn:'Meow! I am Cat!',textHi:'म्याऊँ! मैं बिल्ली हूँ!'), ScriptLine(speaker:'character',textEn:'I am soft and furry.',textHi:'मैं नरम और फूली हूँ।'), ScriptLine(speaker:'character',textEn:'I love milk!',textHi:'मुझे दूध पसंद है!'), ScriptLine(speaker:'character',textEn:'I like to nap in the sun.',textHi:'मुझे धूप में सोना पसंद है।')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Cat!',textHi:'नमस्ते! मैं बिल्ली हूँ!'), ScriptLine(speaker:'character',textEn:'I can see in the dark!',textHi:'मैं अंधेरे में देख सकती हूँ!'), ScriptLine(speaker:'character',textEn:'I am very flexible and can jump high.',textHi:'मैं बहुत लचीली हूँ और ऊँचा कूद सकती हूँ।'), ScriptLine(speaker:'narrator',textEn:'Cats have been our friends for thousands of years!',textHi:'बिल्लियाँ हज़ारों सालों से हमारी दोस्त हैं!')],
    [ThinkGame(id:'c_cat_find',type:'find',title:'Find the Cat',instruction:'Tap the cat!',instructionHi:'बिल्ली पर टैप करो!',config:{'correct':'🐱','options':['🐱','🐶','🐰','🐹']})],
    'The cat says meow.', 'बिल्ली म्याऊँ बोलती है।',
    [DrawStep(stepNumber:1,instruction:'Draw a circle for head',instructionHi:'सिर के लिए गोला बनाओ',shape:'circle'), DrawStep(stepNumber:2,instruction:'Add triangle ears',instructionHi:'त्रिकोण कान बनाओ',shape:'line'), DrawStep(stepNumber:3,instruction:'Draw whiskers',instructionHi:'मूँछें बनाओ',shape:'line')], 'A cute cat!');

  static final _car = _makeWord('c_car', 'Car', 'गाड़ी', '🚗', 'A vehicle with four wheels', 'चार पहियों वाला वाहन', 'vehicle',
    [ScriptLine(speaker:'character',textEn:'Vroom! I am Car!',textHi:'व्रूम! मैं गाड़ी हूँ!'), ScriptLine(speaker:'character',textEn:'I have four wheels.',textHi:'मेरे चार पहिये हैं।'), ScriptLine(speaker:'character',textEn:'I go on roads.',textHi:'मैं सड़कों पर चलती हूँ।'), ScriptLine(speaker:'character',textEn:'I take you places!',textHi:'मैं तुम्हें जगहों पर ले जाती हूँ!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Car!',textHi:'नमस्ते! मैं गाड़ी हूँ!'), ScriptLine(speaker:'character',textEn:'I run on fuel or electricity.',textHi:'मैं ईंधन या बिजली से चलती हूँ।'), ScriptLine(speaker:'character',textEn:'Always wear your seatbelt when riding in me!',textHi:'मुझमें बैठते समय हमेशा सीटबेल्ट लगाओ!'), ScriptLine(speaker:'narrator',textEn:'Cars help us travel safely!',textHi:'गाड़ियाँ हमें सुरक्षित यात्रा करने में मदद करती हैं!')],
    [ThinkGame(id:'c_car_find',type:'find',title:'Find the Car',instruction:'Tap the car!',instructionHi:'गाड़ी पर टैप करो!',config:{'correct':'🚗','options':['🚗','🚀','🛳️','🚁']})],
    'The car is fast.', 'गाड़ी तेज़ है।',
    [DrawStep(stepNumber:1,instruction:'Draw a rectangle for body',instructionHi:'शरीर के लिए आयत बनाओ',shape:'rectangle'), DrawStep(stepNumber:2,instruction:'Add 2 circles for wheels',instructionHi:'पहियों के लिए 2 गोले बनाओ',shape:'circle'), DrawStep(stepNumber:3,instruction:'Add windows',instructionHi:'खिड़कियाँ बनाओ',shape:'rectangle')], 'A fast car!');

  static final _cake = _makeWord('c_cake', 'Cake', 'केक', '🎂', 'A sweet dessert for celebrations', 'जश्न के लिए एक मीठी मिठाई', 'food',
    [ScriptLine(speaker:'character',textEn:'Yum! I am Cake!',textHi:'यम! मैं केक हूँ!'), ScriptLine(speaker:'character',textEn:'I am sweet and yummy.',textHi:'मैं मीठा और स्वादिष्ट हूँ।'), ScriptLine(speaker:'character',textEn:'I have candles on top!',textHi:'मेरे ऊपर मोमबत्तियाँ हैं!'), ScriptLine(speaker:'character',textEn:'I come on birthdays!',textHi:'मैं जन्मदिन पर आता हूँ!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Cake!',textHi:'नमस्ते! मैं केक हूँ!'), ScriptLine(speaker:'character',textEn:'I am baked in an oven with flour, sugar, and eggs.',textHi:'मुझे आटा, चीनी और अंडों से ओवन में बनाया जाता है।'), ScriptLine(speaker:'character',textEn:'People eat me at parties and celebrations!',textHi:'लोग मुझे पार्टियों और जश्न में खाते हैं!'), ScriptLine(speaker:'narrator',textEn:'Sharing cake makes everyone happy!',textHi:'केक बाँटने से सब खुश होते हैं!')],
    [ThinkGame(id:'c_cake_find',type:'find',title:'Find the Cake',instruction:'Tap the cake!',instructionHi:'केक पर टैप करो!',config:{'correct':'🎂','options':['🎂','🍕','🌭','🍟']})],
    'I like cake.', 'मुझे केक पसंद है।',
    [DrawStep(stepNumber:1,instruction:'Draw a rectangle for cake',instructionHi:'केक के लिए आयत बनाओ',shape:'rectangle'), DrawStep(stepNumber:2,instruction:'Add wavy cream on top',instructionHi:'ऊपर लहरदार क्रीम बनाओ',shape:'curve'), DrawStep(stepNumber:3,instruction:'Add candles',instructionHi:'मोमबत्तियाँ बनाओ',shape:'line')], 'A birthday cake!');

  static final _cloud = _makeWord('c_cloud', 'Cloud', 'बादल', '☁️', 'White fluffy shapes in the sky', 'आसमान में सफेद फूले हुए आकार', 'nature',
    [ScriptLine(speaker:'character',textEn:'Whoosh! I am Cloud!',textHi:'वूश! मैं बादल हूँ!'), ScriptLine(speaker:'character',textEn:'I float in the sky.',textHi:'मैं आसमान में तैरता हूँ।'), ScriptLine(speaker:'character',textEn:'I am white and fluffy.',textHi:'मैं सफेद और फूला हुआ हूँ।'), ScriptLine(speaker:'character',textEn:'I bring rain!',textHi:'मैं बारिश लाता हूँ!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Cloud!',textHi:'नमस्ते! मैं बादल हूँ!'), ScriptLine(speaker:'character',textEn:'I am made of tiny water drops.',textHi:'मैं छोटी पानी की बूँदों से बना हूँ।'), ScriptLine(speaker:'character',textEn:'When I get heavy, I rain!',textHi:'जब मैं भारी हो जाता हूँ, तो बारिश करता हूँ!'), ScriptLine(speaker:'narrator',textEn:'Clouds are part of the water cycle!',textHi:'बादल जल चक्र का हिस्सा हैं!')],
    [ThinkGame(id:'c_cloud_find',type:'find',title:'Find the Cloud',instruction:'Tap the cloud!',instructionHi:'बादल पर टैप करो!',config:{'correct':'☁️','options':['☁️','⭐','🌙','☀️']})],
    'The cloud is white.', 'बादल सफेद है।',
    [DrawStep(stepNumber:1,instruction:'Draw bumpy curves for cloud shape',instructionHi:'बादल के आकार के लिए उभरे हुए वक्र बनाओ',shape:'curve'), DrawStep(stepNumber:2,instruction:'Add a flat bottom',instructionHi:'नीचे सपाट रेखा बनाओ',shape:'line')], 'A fluffy cloud!');
}
