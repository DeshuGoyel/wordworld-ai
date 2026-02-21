import '../models/models.dart';

class WordsD {
  static List<WordData> get words => [_dog, _duck, _drum, _dinosaur];

  static WordData _w(String id, String word, String hi, String emoji, String desc, String descHi, String cat,
      List<ScriptLine> y, List<ScriptLine> o, List<ThinkGame> g, String te, String th, List<DrawStep> d, String dd) {
    return WordData(id:id,word:word,wordHi:hi,letter:'D',emoji:emoji,description:desc,descriptionHi:descHi,category:cat,
      meetContent:MeetContent(linesYoung:y,linesOlder:o),thinkGames:g,
      talkLines:[TalkLine(textEn:te,textHi:th)],writeContent:WriteContent(letters:['D','d'],word:word),
      drawContent:DrawContent(steps:d,finalDescription:dd));
  }

  static final _dog = _w('d_dog','Dog','कुत्ता','🐶','A loyal pet that barks','एक वफादार पालतू जो भौंकता है','animal',
    [ScriptLine(speaker:'character',textEn:'Woof! I am Dog!',textHi:'भौं! मैं कुत्ता हूँ!'),ScriptLine(speaker:'character',textEn:'I wag my tail when happy.',textHi:'मैं खुश होने पर पूँछ हिलाता हूँ।'),ScriptLine(speaker:'character',textEn:'I love to play fetch!',textHi:'मुझे गेंद लाना पसंद है!'),ScriptLine(speaker:'character',textEn:'I am your best friend.',textHi:'मैं तुम्हारा सबसे अच्छा दोस्त हूँ।')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Dog!',textHi:'नमस्ते! मैं कुत्ता हूँ!'),ScriptLine(speaker:'character',textEn:'Dogs are called man\'s best friend.',textHi:'कुत्तों को इंसान का सबसे अच्छा दोस्त कहते हैं।'),ScriptLine(speaker:'character',textEn:'I can learn tricks and commands!',textHi:'मैं तरकीबें और आदेश सीख सकता हूँ!'),ScriptLine(speaker:'narrator',textEn:'Dogs teach us loyalty and love!',textHi:'कुत्ते हमें वफादारी और प्यार सिखाते हैं!')],
    [ThinkGame(id:'d_dog_find',type:'find',title:'Find the Dog',instruction:'Tap the dog!',instructionHi:'कुत्ते पर टैप करो!',config:{'correct':'🐶','options':['🐶','🐱','🐰','🐻']})],
    'The dog is happy.','कुत्ता खुश है।',
    [DrawStep(stepNumber:1,instruction:'Draw circle for head',instructionHi:'सिर के लिए गोला बनाओ',shape:'circle'),DrawStep(stepNumber:2,instruction:'Add oval body',instructionHi:'अंडाकार शरीर बनाओ',shape:'oval'),DrawStep(stepNumber:3,instruction:'Add floppy ears and tail',instructionHi:'लटके कान और पूँछ बनाओ',shape:'curve')],'A happy dog!');

  static final _duck = _w('d_duck','Duck','बत्तख','🦆','A bird that swims and says quack','एक पक्षी जो तैरता है और क्वैक बोलता है','bird',
    [ScriptLine(speaker:'character',textEn:'Quack! I am Duck!',textHi:'क्वैक! मैं बत्तख हूँ!'),ScriptLine(speaker:'character',textEn:'I swim in the pond.',textHi:'मैं तालाब में तैरती हूँ।'),ScriptLine(speaker:'character',textEn:'I have webbed feet.',textHi:'मेरे जालीदार पैर हैं।'),ScriptLine(speaker:'character',textEn:'I waddle when I walk!',textHi:'मैं चलते समय लड़खड़ाती हूँ!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Duck!',textHi:'नमस्ते! मैं बत्तख हूँ!'),ScriptLine(speaker:'character',textEn:'My feathers are waterproof!',textHi:'मेरे पंख पानीरोधक हैं!'),ScriptLine(speaker:'character',textEn:'I can fly, swim, and walk!',textHi:'मैं उड़, तैर और चल सकती हूँ!'),ScriptLine(speaker:'narrator',textEn:'Ducks are amazing multi-talented birds!',textHi:'बत्तखें अद्भुत बहुप्रतिभावान पक्षी हैं!')],
    [ThinkGame(id:'d_duck_find',type:'find',title:'Find the Duck',instruction:'Tap the duck!',instructionHi:'बत्तख पर टैप करो!',config:{'correct':'🦆','options':['🦆','🐔','🦅','🦉']})],
    'The duck swims.','बत्तख तैरती है।',
    [DrawStep(stepNumber:1,instruction:'Draw oval body',instructionHi:'अंडाकार शरीर बनाओ',shape:'oval'),DrawStep(stepNumber:2,instruction:'Add small circle head',instructionHi:'छोटा गोल सिर बनाओ',shape:'circle'),DrawStep(stepNumber:3,instruction:'Add flat beak',instructionHi:'चपटी चोंच बनाओ',shape:'line')],'A swimming duck!');

  static final _drum = _w('d_drum','Drum','ढोल','🥁','A musical instrument you hit to make sound','एक संगीत वाद्ययंत्र जिसे बजाने पर आवाज़ आती है','instrument',
    [ScriptLine(speaker:'character',textEn:'Boom! I am Drum!',textHi:'बूम! मैं ढोल हूँ!'),ScriptLine(speaker:'character',textEn:'Hit me and I make sound!',textHi:'मुझे मारो और मैं आवाज़ करता हूँ!'),ScriptLine(speaker:'character',textEn:'I am round like a bucket.',textHi:'मैं बाल्टी जैसा गोल हूँ।'),ScriptLine(speaker:'character',textEn:'Tap tap tap!',textHi:'ताप ताप ताप!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Drum!',textHi:'नमस्ते! मैं ढोल हूँ!'),ScriptLine(speaker:'character',textEn:'I am one of the oldest instruments in the world!',textHi:'मैं दुनिया के सबसे पुराने वाद्ययंत्रों में से एक हूँ!'),ScriptLine(speaker:'character',textEn:'People use sticks to play me.',textHi:'लोग मुझे बजाने के लिए छड़ियों का उपयोग करते हैं।'),ScriptLine(speaker:'narrator',textEn:'Drums bring rhythm to music!',textHi:'ढोल संगीत में ताल लाता है!')],
    [ThinkGame(id:'d_drum_find',type:'find',title:'Find the Drum',instruction:'Tap the drum!',instructionHi:'ढोल पर टैप करो!',config:{'correct':'🥁','options':['🥁','🎸','🎺','🎹']})],
    'I play the drum.','मैं ढोल बजाता हूँ।',
    [DrawStep(stepNumber:1,instruction:'Draw a cylinder shape',instructionHi:'एक बेलन आकार बनाओ',shape:'rectangle'),DrawStep(stepNumber:2,instruction:'Add oval on top',instructionHi:'ऊपर अंडाकार बनाओ',shape:'oval'),DrawStep(stepNumber:3,instruction:'Add drumsticks',instructionHi:'ढोल की छड़ियाँ बनाओ',shape:'line')],'A loud drum!');

  static final _dinosaur = _w('d_dinosaur','Dinosaur','डायनासोर','🦕','A giant animal from long long ago','बहुत पहले का एक विशाल जानवर','animal',
    [ScriptLine(speaker:'character',textEn:'Rawr! I am Dinosaur!',textHi:'रॉर! मैं डायनासोर हूँ!'),ScriptLine(speaker:'character',textEn:'I am very very big!',textHi:'मैं बहुत बहुत बड़ा हूँ!'),ScriptLine(speaker:'character',textEn:'I lived long ago.',textHi:'मैं बहुत पहले रहता था।'),ScriptLine(speaker:'character',textEn:'I ate lots and lots of plants!',textHi:'मैं बहुत सारे पौधे खाता था!')],
    [ScriptLine(speaker:'character',textEn:'Hello! I am Dinosaur!',textHi:'नमस्ते! मैं डायनासोर हूँ!'),ScriptLine(speaker:'character',textEn:'I lived millions of years ago!',textHi:'मैं लाखों साल पहले रहता था!'),ScriptLine(speaker:'character',textEn:'Some of us were as tall as buildings!',textHi:'हम में से कुछ इमारतों जितने ऊँचे थे!'),ScriptLine(speaker:'narrator',textEn:'We learn about dinosaurs from fossils!',textHi:'हम जीवाश्मों से डायनासोर के बारे में सीखते हैं!')],
    [ThinkGame(id:'d_dino_find',type:'find',title:'Find the Dinosaur',instruction:'Tap the dinosaur!',instructionHi:'डायनासोर पर टैप करो!',config:{'correct':'🦕','options':['🦕','🐘','🦒','🦏']})],
    'The dinosaur is big.','डायनासोर बड़ा है।',
    [DrawStep(stepNumber:1,instruction:'Draw long oval body',instructionHi:'लंबा अंडाकार शरीर बनाओ',shape:'oval'),DrawStep(stepNumber:2,instruction:'Add long neck and small head',instructionHi:'लंबी गर्दन और छोटा सिर बनाओ',shape:'curve'),DrawStep(stepNumber:3,instruction:'Add 4 thick legs and tail',instructionHi:'4 मोटे पैर और पूँछ बनाओ',shape:'line')],'A giant dinosaur!');
}
