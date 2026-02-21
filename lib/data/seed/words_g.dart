import '../models/models.dart';

class WordsG {
  static List<WordData> get words => [_grapes, _giraffe, _guitar, _ghost];

  static WordData _w(String id, String word, String hi, String emoji, String desc, String descHi, String cat,
      List<ScriptLine> y, List<ScriptLine> o, String te, String th, List<DrawStep> d, String dd) {
    return WordData(id:id,word:word,wordHi:hi,letter:'G',emoji:emoji,description:desc,descriptionHi:descHi,category:cat,
      meetContent:MeetContent(linesYoung:y,linesOlder:o),
      thinkGames:[ThinkGame(id:'${id}_find',type:'find',title:'Find the $word',instruction:'Tap the $word!',instructionHi:'$hi पर टैप करो!',config:{'correct':emoji,'options':[emoji,'🎈','🧩','🎪']})],
      talkLines:[TalkLine(textEn:te,textHi:th)],writeContent:WriteContent(letters:['G','g'],word:word),
      drawContent:DrawContent(steps:d,finalDescription:dd));
  }

  static final _grapes = _w('g_grapes','Grapes','अंगूर','🍇','Small round fruits that grow in bunches','छोटे गोल फल जो गुच्छों में उगते हैं','fruit',
    [ScriptLine(speaker:'character',textEn:'Squish! I am Grapes!',textHi:'स्क्विश! मैं अंगूर हूँ!'),ScriptLine(speaker:'character',textEn:'I grow in bunches.',textHi:'मैं गुच्छों में उगता हूँ।'),ScriptLine(speaker:'character',textEn:'I am sweet and juicy!',textHi:'मैं मीठा और रसीला हूँ!'),ScriptLine(speaker:'character',textEn:'I can be purple or green!',textHi:'मैं बैंगनी या हरा हो सकता हूँ!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Grapes!',textHi:'नमस्ते! मैं अंगूर हूँ!'),ScriptLine(speaker:'character',textEn:'I grow on vines in vineyards.',textHi:'मैं बागों में बेलों पर उगता हूँ।'),ScriptLine(speaker:'character',textEn:'People also make juice and jam from me!',textHi:'लोग मुझसे जूस और जैम भी बनाते हैं!'),ScriptLine(speaker:'narrator',textEn:'Grapes are one of the oldest fruits!',textHi:'अंगूर सबसे पुराने फलों में से एक हैं!')],
    'I like grapes.','मुझे अंगूर पसंद हैं।',
    [DrawStep(stepNumber:1,instruction:'Draw many small circles together',instructionHi:'कई छोटे गोले एक साथ बनाओ',shape:'circle'),DrawStep(stepNumber:2,instruction:'Add a stem on top',instructionHi:'ऊपर तना बनाओ',shape:'line')],'A bunch of grapes!');

  static final _giraffe = _w('g_giraffe','Giraffe','जिराफ़','🦒','The tallest animal with a very long neck','सबसे लंबा जानवर जिसकी बहुत लंबी गर्दन है','animal',
    [ScriptLine(speaker:'character',textEn:'Stretch! I am Giraffe!',textHi:'स्ट्रेच! मैं जिराफ़ हूँ!'),ScriptLine(speaker:'character',textEn:'I have a very long neck.',textHi:'मेरी बहुत लंबी गर्दन है।'),ScriptLine(speaker:'character',textEn:'I eat leaves from tall trees.',textHi:'मैं ऊँचे पेड़ों से पत्ते खाता हूँ।'),ScriptLine(speaker:'character',textEn:'I have spots on my body!',textHi:'मेरे शरीर पर धब्बे हैं!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Giraffe!',textHi:'नमस्ते! मैं जिराफ़ हूँ!'),ScriptLine(speaker:'character',textEn:'I am the tallest animal in the world!',textHi:'मैं दुनिया का सबसे ऊँचा जानवर हूँ!'),ScriptLine(speaker:'character',textEn:'My tongue is 18 inches long!',textHi:'मेरी जीभ 18 इंच लंबी है!'),ScriptLine(speaker:'narrator',textEn:'Each giraffe has unique spots—like fingerprints!',textHi:'हर जिराफ़ के धब्बे अनोखे हैं—जैसे उंगलियों के निशान!')],
    'The giraffe is tall.','जिराफ़ लंबा है।',
    [DrawStep(stepNumber:1,instruction:'Draw tall rectangle for neck',instructionHi:'गर्दन के लिए लंबा आयत बनाओ',shape:'rectangle'),DrawStep(stepNumber:2,instruction:'Add oval head on top',instructionHi:'ऊपर अंडाकार सिर बनाओ',shape:'oval'),DrawStep(stepNumber:3,instruction:'Add body and legs',instructionHi:'शरीर और पैर बनाओ',shape:'rectangle')],'A tall giraffe!');

  static final _guitar = _w('g_guitar','Guitar','गिटार','🎸','A musical instrument with strings','तारों वाला एक संगीत वाद्ययंत्र','instrument',
    [ScriptLine(speaker:'character',textEn:'Strum! I am Guitar!',textHi:'झंकार! मैं गिटार हूँ!'),ScriptLine(speaker:'character',textEn:'I make beautiful music.',textHi:'मैं सुंदर संगीत बनाता हूँ।'),ScriptLine(speaker:'character',textEn:'I have strings you can pluck!',textHi:'मेरे तार हैं जो तुम छेड़ सकते हो!'),ScriptLine(speaker:'character',textEn:'People sing songs with me!',textHi:'लोग मेरे साथ गाने गाते हैं!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Guitar!',textHi:'नमस्ते! मैं गिटार हूँ!'),ScriptLine(speaker:'character',textEn:'I have 6 strings that make different sounds.',textHi:'मेरे 6 तार हैं जो अलग-अलग आवाज़ें निकालते हैं।'),ScriptLine(speaker:'character',textEn:'I can play rock, classical, and folk music!',textHi:'मैं रॉक, शास्त्रीय और लोक संगीत बजा सकता हूँ!'),ScriptLine(speaker:'narrator',textEn:'Guitar is one of the most popular instruments!',textHi:'गिटार सबसे लोकप्रिय वाद्ययंत्रों में से एक है!')],
    'I play guitar.','मैं गिटार बजाता हूँ।',
    [DrawStep(stepNumber:1,instruction:'Draw figure-8 body shape',instructionHi:'8 के आकार का शरीर बनाओ',shape:'curve'),DrawStep(stepNumber:2,instruction:'Add long neck on top',instructionHi:'ऊपर लंबी गर्दन बनाओ',shape:'rectangle'),DrawStep(stepNumber:3,instruction:'Draw strings',instructionHi:'तार बनाओ',shape:'line')],'A musical guitar!');

  static final _ghost = _w('g_ghost','Ghost','भूत','👻','A spooky character that says boo','एक डरावना किरदार जो बू बोलता है','fantasy',
    [ScriptLine(speaker:'character',textEn:'Boo! I am Ghost!',textHi:'बू! मैं भूत हूँ!'),ScriptLine(speaker:'character',textEn:'I am white and floaty.',textHi:'मैं सफेद और तैरने वाला हूँ।'),ScriptLine(speaker:'character',textEn:'But I am a friendly ghost!',textHi:'लेकिन मैं एक दोस्ताना भूत हूँ!'),ScriptLine(speaker:'character',textEn:'I like to play peek-a-boo!',textHi:'मुझे पीक-ए-बू खेलना पसंद है!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Ghost!',textHi:'नमस्ते! मैं भूत हूँ!'),ScriptLine(speaker:'character',textEn:'People dress up as ghosts on Halloween!',textHi:'हैलोवीन पर लोग भूत का वेश बनाते हैं!'),ScriptLine(speaker:'character',textEn:'I am just made of a bedsheet! Not scary at all!',textHi:'मैं बस एक चादर से बना हूँ! बिल्कुल डरावना नहीं!'),ScriptLine(speaker:'narrator',textEn:'Ghosts in stories teach us to be brave!',textHi:'कहानियों में भूत हमें बहादुर होना सिखाते हैं!')],
    'The ghost says boo.','भूत बू बोलता है।',
    [DrawStep(stepNumber:1,instruction:'Draw a round head shape',instructionHi:'गोल सिर बनाओ',shape:'curve'),DrawStep(stepNumber:2,instruction:'Add wavy body going down',instructionHi:'नीचे लहरदार शरीर बनाओ',shape:'curve'),DrawStep(stepNumber:3,instruction:'Add eyes and mouth',instructionHi:'आँखें और मुँह बनाओ',shape:'circle')],'A friendly ghost!');
}
