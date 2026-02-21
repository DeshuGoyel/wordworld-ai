import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

/// Exercise data model
class Exercise {
  final String id;
  final String subject;    // grammar, math, evs, values
  final String topic;      // nouns, verbs, counting, etc.
  final int level;         // 1-10
  final String type;       // mcq, fill_blank, true_false, match, sentence_build
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String hint;
  final int xpReward;

  const Exercise({
    required this.id, required this.subject, required this.topic,
    required this.level, required this.type, required this.question,
    required this.options, required this.correctAnswer,
    this.hint = '', this.xpReward = 5,
  });
}

/// 100 exercises per subject, 10 levels of difficulty
class ExerciseBank {
  static final List<Exercise> _allExercises = [
    ..._grammarExercises,
    ..._mathExercises,
    ..._evsExercises,
    ..._valuesExercises,
  ];

  /// Get all exercises for a subject
  static List<Exercise> forSubject(String subject) =>
      _allExercises.where((e) => e.subject == subject).toList();

  /// Get exercises for a subject+topic at a given level
  static List<Exercise> forTopicLevel(String subject, String topic, int level) =>
      _allExercises.where((e) => e.subject == subject && e.topic == topic && e.level == level).toList();

  /// Get exercises for a level across all topics in a subject
  static List<Exercise> forLevel(String subject, int level) =>
      _allExercises.where((e) => e.subject == subject && e.level == level).toList();

  /// Get total count for a subject
  static int countForSubject(String subject) => forSubject(subject).length;

  // ═══════════ GRAMMAR EXERCISES (100) ═══════════
  static final List<Exercise> _grammarExercises = [
    // ── Nouns Level 1-3 (30 exercises) ──
    ..._nounExercises,
    // ── Verbs Level 1-3 (25 exercises) ──
    ..._verbExercises,
    // ── Adjectives Level 1-3 (20 exercises) ──
    ..._adjectiveExercises,
    // ── Sentences Level 4-7 (15 exercises) ──
    ..._sentenceExercises,
    // ── Advanced Level 8-10 (10 exercises) ──
    ..._advancedGrammarExercises,
  ];

  static final _nounExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'g_n_1_$i', subject: 'grammar', topic: 'nouns', level: 1, type: 'mcq',
      question: ['Is "dog" a noun?', 'Is "cat" a noun?', 'Is "run" a noun?', 'Is "Apple" a noun?',
        'Is "jump" a noun?', 'Is "table" a noun?', 'Is "sing" a noun?', 'Is "book" a noun?',
        'Is "eat" a noun?', 'Is "flower" a noun?'][i],
      options: ['Yes', 'No'], correctAnswer: [true, true, false, true, false, true, false, true, false, true][i] ? 'Yes' : 'No',
      hint: 'A noun is a person, place, or thing', xpReward: 5),
    for (var i = 0; i < 10; i++) Exercise(id: 'g_n_2_$i', subject: 'grammar', topic: 'nouns', level: 2, type: 'mcq',
      question: ['Pick the noun: "The ___ is big"', 'Pick the noun: "A ___ ran fast"', 'Pick the noun: "I see a ___"',
        'Which is a proper noun?', 'Which is a common noun?', 'Plural of "box"?', 'Plural of "baby"?',
        'Plural of "child"?', 'Plural of "mouse"?', 'Plural of "foot"?'][i],
      options: [['house','big','is'],['dog','fast','ran'],['ball','see','the'],['India','book','run'],['cat','Delhi','Ravi'],
        ['boxs','boxes','boxies'],['babys','babyes','babies'],['childs','childrens','children'],
        ['mouses','mice','mousies'],['foots','feets','feet']][i],
      correctAnswer: ['house','dog','ball','India','cat','boxes','babies','children','mice','feet'][i],
      hint: 'Nouns name people, places, or things', xpReward: 8),
    for (var i = 0; i < 10; i++) Exercise(id: 'g_n_3_$i', subject: 'grammar', topic: 'nouns', level: 3, type: 'fill_blank',
      question: ['The ___ barked loudly.', 'She ate an ___.', 'The ___ shines at night.', 'I love my ___.', 'The ___ is on the hill.',
        'We saw a ___ at the zoo.', 'The ___ flows to the sea.', 'A ___ has four legs.', 'The ___ sang beautifully.', 'My ___ is blue.'][i],
      options: ['dog','apple','moon','school','castle','lion','river','table','bird','bag'],
      correctAnswer: ['dog','apple','moon','school','castle','lion','river','table','bird','bag'][i],
      hint: 'Fill in with the right noun', xpReward: 10),
  ];

  static final _verbExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'g_v_1_$i', subject: 'grammar', topic: 'verbs', level: 1, type: 'mcq',
      question: ['Is "run" an action word?', 'Is "big" an action word?', 'Is "eat" an action word?', 'Is "red" an action word?',
        'Is "jump" an action word?', 'Is "happy" an action word?', 'Is "swim" an action word?', 'Is "tall" an action word?',
        'Is "read" an action word?', 'Is "blue" an action word?'][i],
      options: ['Yes', 'No'], correctAnswer: [true, false, true, false, true, false, true, false, true, false][i] ? 'Yes' : 'No',
      hint: 'Verbs are doing/action words', xpReward: 5),
    for (var i = 0; i < 10; i++) Exercise(id: 'g_v_2_$i', subject: 'grammar', topic: 'verbs', level: 2, type: 'fill_blank',
      question: ['She ___ to school.', 'They ___ football.', 'He ___ a book.', 'We ___ mangoes.', 'I ___ my teeth.',
        'The bird ___.', 'The fish ___.', 'She ___ a song.', 'Dad ___ the car.', 'Mom ___ food.'][i],
      options: ['goes','play','reads','eat','brush','flies','swims','sings','drives','cooks'],
      correctAnswer: ['goes','play','reads','eat','brush','flies','swims','sings','drives','cooks'][i],
      hint: 'Pick the right action word', xpReward: 8),
    for (var i = 0; i < 5; i++) Exercise(id: 'g_v_3_$i', subject: 'grammar', topic: 'verbs', level: 3, type: 'mcq',
      question: ['Past tense of "go"?', 'Past tense of "eat"?', 'Past tense of "run"?', 'Past tense of "sing"?', 'Past tense of "write"?'][i],
      options: [['goed','went','goned'],['eated','ate','eatted'],['runned','ran','runed'],
        ['singed','sang','sungen'],['writed','wrote','writeed']][i],
      correctAnswer: ['went','ate','ran','sang','wrote'][i],
      hint: 'Think about how we say it happened before', xpReward: 10),
  ];

  static final _adjectiveExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'g_a_1_$i', subject: 'grammar', topic: 'adjectives', level: 1, type: 'mcq',
      question: ['Which word describes? "The ___ cat"', 'Which word describes? "A ___ house"', 'Is "red" a describing word?',
        'Is "run" a describing word?', 'Pick the adjective: "tall tree"', 'Pick the adjective: "cold water"',
        'Which describes size?', 'Which describes color?', 'Which describes feeling?', 'Which describes taste?'][i],
      options: [['big','run','eat'],['tall','go','jump'],['Yes','No'],['Yes','No'],['tall','tree'],['cold','water'],
        ['big','red','happy'],['green','fast','kind'],['sad','large','blue'],['sweet','tall','old']][i],
      correctAnswer: ['big','tall','Yes','No','tall','cold','big','green','sad','sweet'][i],
      hint: 'Adjectives describe nouns', xpReward: 5),
    for (var i = 0; i < 10; i++) Exercise(id: 'g_a_2_$i', subject: 'grammar', topic: 'adjectives', level: 2, type: 'fill_blank',
      question: ['The elephant is ___.', 'Ice cream is ___.', 'The sky is ___.', 'Honey is ___.', 'The baby is ___.',
        'Lions are ___.', 'Snow is ___.', 'Chili is ___.', 'The sun is ___.', 'Cotton is ___.'][i],
      options: ['big','cold','blue','sweet','small','brave','white','spicy','hot','soft'],
      correctAnswer: ['big','cold','blue','sweet','small','brave','white','spicy','hot','soft'][i],
      hint: 'Pick a word that describes', xpReward: 8),
  ];

  static final _sentenceExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'g_s_4_$i', subject: 'grammar', topic: 'sentences', level: 4, type: 'mcq',
      question: ['Which is a complete sentence?', 'Which is a question?', 'What type: "Wow!"', 'What type: "Close the door."',
        'Fix: "the cat is big"', 'Count the words: "I like dogs"', 'Which has correct punctuation?',
        'Pick the subject: "The dog runs."', 'Pick the predicate: "She sings."', 'Which is NOT a sentence?'][i],
      options: [['The cat.','The cat sat.','Cat sat'],['She ran.','Did she run?','Running!'],['Statement','Exclamation','Question'],
        ['Statement','Question','Command'],['the cat is big','The cat is big.','The Cat Is Big'],
        ['2','3','4'],['I like dogs.','i like dogs','I like Dogs'],['The dog','runs','The'],
        ['sings','She','She sings'],['He is happy.','Running fast.','I eat.']][i],
      correctAnswer: ['The cat sat.','Did she run?','Exclamation','Command','The cat is big.','3','I like dogs.','The dog','sings','Running fast.'][i],
      hint: 'A sentence has a subject and predicate', xpReward: 10),
    for (var i = 0; i < 5; i++) Exercise(id: 'g_s_5_$i', subject: 'grammar', topic: 'sentences', level: 5, type: 'mcq',
      question: ['Join: "I like apples" + "I like oranges"', 'Which conjunction? "She __ he went"',
        'Opposite: "The cat is big."', 'Add adjective: "___ ball bounced"', 'Which is a compound sentence?'][i],
      options: [['I like apples and oranges.','I like apples oranges.','I like and apples oranges.'],
        ['and','but','or'],['The cat is small.','The cat is not.','The big cat.'],
        ['The red','Red ball','A ball'],['She ran. He ate.','She ran and he ate.','Running eating.']][i],
      correctAnswer: ['I like apples and oranges.','and','The cat is small.','The red','She ran and he ate.'][i],
      hint: 'Think about sentence structure', xpReward: 12),
  ];

  static final _advancedGrammarExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'g_x_${i < 4 ? 8 : i < 7 ? 9 : 10}_$i', subject: 'grammar', topic: 'advanced',
      level: i < 4 ? 8 : i < 7 ? 9 : 10, type: 'mcq',
      question: ['Pick the preposition: "on the table"', 'Pick the pronoun that replaces "Ravi"',
        'Which is an adverb? "runs quickly"', 'Pick the conjunction: "and, but, or"',
        'Identify articles: "The dog ate a bone"', '"She reads well" — adverb?', 'Passive voice of "Cats drink milk"?',
        'Pick the interjection', 'Which is abstract noun?', 'Which is collective noun?'][i],
      options: [['on','table','the'],['he','cat','and'],['runs','quickly','the'],['all are conjunctions','none','only and'],
        ['The, a','dog, bone','ate'],['well','reads','she'],['Milk is drunk by cats.','Cats is drunk.','Milk drinks cats.'],
        ['Hurray!','Table','Running'],['happiness','chair','run'],['flock','bird','fly']][i],
      correctAnswer: ['on','he','quickly','all are conjunctions','The, a','well','Milk is drunk by cats.','Hurray!','happiness','flock'][i],
      hint: 'Advanced grammar concepts', xpReward: 15),
  ];

  // ═══════════ MATH EXERCISES (100) ═══════════
  static final List<Exercise> _mathExercises = [
    ..._countingExercises,
    ..._additionExercises,
    ..._subtractionExercises,
    ..._shapesExercises,
    ..._patternsExercises,
    ..._advancedMathExercises,
  ];

  static final _countingExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'm_c_1_$i', subject: 'math', topic: 'counting', level: 1, type: 'mcq',
      question: ['Count: 🍎🍎🍎', 'Count: 🌟🌟🌟🌟🌟', 'Count: 🐱🐱', 'Count: 🎈🎈🎈🎈',
        'Count: 🐶', 'Count: 🌸🌸🌸🌸🌸🌸', 'Count: 🐟🐟🐟🐟🐟🐟🐟', 'What comes after 3?',
        'What comes before 5?', 'What is between 6 and 8?'][i],
      options: [['2','3','4'],['4','5','6'],['1','2','3'],['3','4','5'],['1','2','0'],
        ['5','6','7'],['6','7','8'],['4','2','5'],['3','4','6'],['7','5','9']][i],
      correctAnswer: ['3','5','2','4','1','6','7','4','4','7'][i],
      hint: 'Count carefully!', xpReward: 5),
    for (var i = 0; i < 10; i++) Exercise(id: 'm_c_2_$i', subject: 'math', topic: 'counting', level: 2, type: 'mcq',
      question: ['Count by 2: 2, 4, 6, ___', 'Count by 5: 5, 10, 15, ___',
        'Count backwards: 10, 9, 8, ___', 'Which is more: 7 or 5?', 'Which is less: 3 or 9?',
        'How many tens in 20?', 'What is 10 + 0?', 'Skip count by 10: 10, 20, ___',
        'Ordinal: 1st, 2nd, ___', 'Even or odd: 6?'][i],
      options: [['7','8','10'],['20','25','18'],['7','6','5'],['7','5','same'],['3','9','same'],
        ['1','2','3'],['10','0','1'],['25','30','35'],['3rd','3th','3st'],['Even','Odd']][i],
      correctAnswer: ['8','20','7','7','3','2','10','30','3rd','Even'][i],
      hint: 'Think about number patterns', xpReward: 8),
  ];

  static final _additionExercises = [
    for (var i = 0; i < 15; i++) Exercise(id: 'm_a_${(i ~/ 5) + 3}_$i', subject: 'math', topic: 'addition',
      level: (i ~/ 5) + 3, type: 'mcq',
      question: ['1 + 1 = ?', '2 + 3 = ?', '4 + 1 = ?', '3 + 3 = ?', '5 + 2 = ?',
        '6 + 4 = ?', '8 + 5 = ?', '7 + 7 = ?', '9 + 6 = ?', '12 + 8 = ?',
        '15 + 15 = ?', '25 + 25 = ?', '34 + 16 = ?', '48 + 12 = ?', '99 + 1 = ?'][i],
      options: [['1','2','3'],['4','5','6'],['5','4','6'],['5','6','7'],['6','7','8'],
        ['9','10','11'],['12','13','14'],['13','14','15'],['14','15','16'],['19','20','21'],
        ['25','30','35'],['45','50','55'],['48','50','52'],['58','60','62'],['99','100','101']][i],
      correctAnswer: ['2','5','5','6','7','10','13','14','15','20','30','50','50','60','100'][i],
      hint: 'Add the numbers together', xpReward: [5,5,5,5,5, 8,8,8,8,8, 10,10,10,10,10][i]),
  ];

  static final _subtractionExercises = [
    for (var i = 0; i < 15; i++) Exercise(id: 'm_s_${(i ~/ 5) + 4}_$i', subject: 'math', topic: 'subtraction',
      level: (i ~/ 5) + 4, type: 'mcq',
      question: ['3 - 1 = ?', '5 - 2 = ?', '4 - 4 = ?', '7 - 3 = ?', '6 - 1 = ?',
        '10 - 4 = ?', '12 - 5 = ?', '15 - 8 = ?', '20 - 9 = ?', '18 - 6 = ?',
        '50 - 25 = ?', '100 - 50 = ?', '75 - 30 = ?', '63 - 28 = ?', '100 - 1 = ?'][i],
      options: [['1','2','3'],['2','3','4'],['0','1','4'],['3','4','5'],['4','5','6'],
        ['5','6','7'],['6','7','8'],['6','7','8'],['10','11','12'],['11','12','13'],
        ['20','25','30'],['40','50','60'],['40','45','50'],['33','35','37'],['98','99','101']][i],
      correctAnswer: ['2','3','0','4','5','6','7','7','11','12','25','50','45','35','99'][i],
      hint: 'Take away the second number', xpReward: [5,5,5,5,5, 8,8,8,8,8, 10,10,10,10,10][i]),
  ];

  static final _shapesExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'm_sh_2_$i', subject: 'math', topic: 'shapes', level: 2, type: 'mcq',
      question: ['How many sides does a triangle have?', 'How many sides does a square have?',
        'What shape is a ball?', 'What shape has no corners?', 'How many corners does a rectangle have?',
        'What shape is a dice?', 'How many sides does a hexagon have?', 'What shape is a pizza slice?',
        'What has 5 sides?', 'Shapes with all equal sides?'][i],
      options: [['2','3','4'],['3','4','5'],['cube','sphere','cylinder'],['circle','square','triangle'],
        ['3','4','5'],['cube','sphere','cone'],['5','6','7'],['circle','triangle','square'],
        ['pentagon','hexagon','octagon'],['square','rectangle','triangle']][i],
      correctAnswer: ['3','4','sphere','circle','4','cube','6','triangle','pentagon','square'][i],
      hint: 'Think about the shape properties', xpReward: 8),
  ];

  static final _patternsExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'm_p_3_$i', subject: 'math', topic: 'patterns', level: 3, type: 'mcq',
      question: ['🔴🔵🔴🔵🔴___', '🟡🟡🔵🟡🟡___', '1, 2, 3, 4, ___', '2, 4, 6, 8, ___',
        'A, B, A, B, ___', '🌟🌟⭐🌟🌟___', '1, 3, 5, 7, ___', '10, 20, 30, ___',
        '🔺🔺🔻🔺🔺___', '5, 10, 15, 20, ___'][i],
      options: [['🔴','🔵','🟢'],['🔵','🟡','🔴'],['5','6','7'],['9','10','12'],
        ['A','B','C'],['⭐','🌟','🌙'],['8','9','10'],['35','40','50'],
        ['🔻','🔺','🔵'],['22','25','30']][i],
      correctAnswer: ['🔵','🔵','5','10','A','⭐','9','40','🔻','25'][i],
      hint: 'Find the repeating pattern', xpReward: 10),
  ];

  static final _advancedMathExercises = [
    for (var i = 0; i < 10; i++) Exercise(id: 'm_x_${i < 4 ? 8 : i < 7 ? 9 : 10}_$i', subject: 'math', topic: 'advanced',
      level: i < 4 ? 8 : i < 7 ? 9 : 10, type: 'mcq',
      question: ['5 × 3 = ?', '4 × 4 = ?', '6 × 2 = ?', '7 × 3 = ?',
        '12 ÷ 3 = ?', '20 ÷ 4 = ?', '15 ÷ 5 = ?',
        'What is ½ of 10?', 'What is ¼ of 20?', '0.5 + 0.5 = ?'][i],
      options: [['12','15','18'],['12','16','20'],['10','12','14'],['18','21','24'],
        ['3','4','5'],['4','5','6'],['2','3','4'],
        ['4','5','6'],['4','5','6'],['0.5','1.0','1.5']][i],
      correctAnswer: ['15','16','12','21','4','5','3','5','5','1.0'][i],
      hint: 'Advanced math operations', xpReward: 15),
  ];

  // ═══════════ EVS EXERCISES (100) ═══════════
  static final List<Exercise> _evsExercises = [
    ..._bodyExercises,
    ..._familyExercises,
    ..._natureExercises,
    ..._safetyExercises,
  ];

  static final _bodyExercises = [
    for (var i = 0; i < 15; i++) Exercise(id: 'e_b_${(i ~/ 5) + 1}_$i', subject: 'evs', topic: 'my_body',
      level: (i ~/ 5) + 1, type: 'mcq',
      question: ['We see with our ___', 'We hear with our ___', 'We smell with our ___',
        'How many fingers on one hand?', 'We taste with our ___',
        'How many eyes do we have?', 'Which sense organ is for touch?', 'How many teeth does a child have?',
        'Which body part pumps blood?', 'Bones protect our ___',
        'How many bones in human body?', 'Which organ helps us breathe?', 'What covers our body?',
        'Which is the largest organ?', 'Food goes to the ___'][i],
      options: [['ears','eyes','nose'],['eyes','ears','mouth'],['ears','nose','tongue'],
        ['4','5','6'],['eyes','nose','tongue'],
        ['1','2','3'],['skin','eyes','ears'],['10','20','32'],
        ['brain','heart','lungs'],['brain','teeth','nails'],
        ['106','206','306'],['lungs','heart','brain'],['hair','skin','clothes'],
        ['skin','heart','brain'],['lungs','stomach','heart']][i],
      correctAnswer: ['eyes','ears','nose','5','tongue','2','skin','20','heart','brain','206','lungs','skin','skin','stomach'][i],
      hint: 'Think about your body!', xpReward: [5,5,5,5,5, 8,8,8,8,8, 10,10,10,10,10][i]),
  ];

  static final _familyExercises = [
    for (var i = 0; i < 15; i++) Exercise(id: 'e_f_${(i ~/ 5) + 1}_$i', subject: 'evs', topic: 'my_family',
      level: (i ~/ 5) + 1, type: 'mcq',
      question: ["Father's father is called?", "Mother's mother is called?", 'My sister is my parents ___',
        "Father's brother is called?", "Mother's sister is called?",
        'Joint family has ___ members', 'Nuclear family has ___', "Uncle's son is your ___",
        'Family gives us ___', 'We should ___ our elders',
        'A family tree shows ___', 'Siblings share same ___', 'Grandparents are ___ generation',
        'Festivals are celebrated with ___', 'We help in ___ chores'][i],
      options: [['uncle','grandfather','brother'],['aunt','grandmother','sister'],['son','daughter','child'],
        ['uncle','cousin','nephew'],['cousin','aunt','niece'],
        ['few','many','two'],['parents and kids','only parents','only kids'],
        ['brother','cousin','nephew'],['love','money','toys'],['respect','ignore','fight'],
        ['relationships','maps','pictures'],['parents','friends','teachers'],['older','same','newer'],
        ['family','strangers','alone'],['no','house','office']][i],
      correctAnswer: ['grandfather','grandmother','child','uncle','aunt','many','parents and kids',
        'cousin','love','respect','relationships','parents','older','family','house'][i],
      hint: 'Think about your family!', xpReward: [5,5,5,5,5, 8,8,8,8,8, 10,10,10,10,10][i]),
  ];

  static final _natureExercises = [
    for (var i = 0; i < 40; i++) Exercise(id: 'e_n_${(i ~/ 10) + 3}_$i', subject: 'evs', topic: 'nature',
      level: (i ~/ 10) + 3, type: 'mcq',
      question: ['Plants need ___ to grow', 'Animals that eat plants are ___', 'We get rain from ___',
        'Trees give us ___', 'Which animal gives milk?', 'Bees make ___', 'Fish live in ___',
        'Birds have ___ to fly', 'Caterpillar becomes a ___', 'Frogs live in water and ___',
        'Roots grow ___', 'Leaves are usually ___', 'Flowers attract ___', 'Seeds grow into ___',
        'Photosynthesis needs ___', 'Desert animals can survive without ___', 'Pandas eat ___',
        'Largest land animal?', 'Fastest land animal?', 'Tallest animal?',
        'Seasons in a year?', 'Earth revolves around ___', 'Rain comes from ___', 'Snow forms when water ___',
        'Wind is moving ___', 'Floods happen when ___ is too much', 'Drought means no ___',
        'Plants release ___', 'Animals breathe ___', 'Water cycle includes ___',
        'Endangered species need ___', 'Pollution harms ___', 'Recycling saves ___', 'Trees prevent ___',
        'Coral reefs are in ___', 'Rainforests have ___ trees', 'Deserts are ___', 'Arctic is ___',
        'Compost is made from ___', 'Solar energy comes from ___'][i],
      options: [['water','toys','paint'],['herbivores','carnivores','omnivores'],['clouds','ground','trees'],
        ['oxygen','carbon','helium'],['cow','tiger','eagle'],['honey','milk','sugar'],['water','air','sand'],
        ['fins','wings','legs'],['butterfly','snake','fish'],['land','air','space'],
        ['down','up','sideways'],['green','blue','red'],['insects','fish','humans'],['plants','rocks','water'],
        ['sunlight','moonlight','starlight'],['water','food','air'],['bamboo','meat','fish'],
        ['elephant','whale','giraffe'],['cheetah','lion','horse'],['giraffe','elephant','ostrich'],
        ['2','4','6'],['sun','moon','stars'],['clouds','ground','ocean'],['freezes','boils','melts'],
        ['air','water','fire'],['rain','wind','sun'],['rain','food','toys'],
        ['oxygen','carbon dioxide','nitrogen'],['oxygen','carbon dioxide','hydrogen'],
        ['evaporation','cooking','sleeping'],['protection','hunting','ignoring'],['environment','nothing','space'],
        ['resources','time','toys'],['soil erosion','rain','wind'],
        ['oceans','deserts','mountains'],['many','no','few'],['dry','wet','cold'],['cold','hot','wet'],
        ['waste','plastic','metal'],['sun','moon','wind']][i],
      correctAnswer: ['water','herbivores','clouds','oxygen','cow','honey','water','wings','butterfly','land',
        'down','green','insects','plants','sunlight','water','bamboo','elephant','cheetah','giraffe',
        '4','sun','clouds','freezes','air','rain','rain','oxygen','oxygen','evaporation',
        'protection','environment','resources','soil erosion','oceans','many','dry','cold','waste','sun'][i],
      hint: 'Think about nature and environment', xpReward: [5,5,5,5,5,5,5,5,5,5, 8,8,8,8,8,8,8,8,8,8, 10,10,10,10,10,10,10,10,10,10, 12,12,12,12,12,12,12,12,12,12][i]),
  ];

  static final _safetyExercises = [
    for (var i = 0; i < 30; i++) Exercise(id: 'e_s_${(i ~/ 10) + 7}_$i', subject: 'evs', topic: 'safety',
      level: (i ~/ 10) + 7, type: 'mcq',
      question: ['Cross the road at ___', 'Don\'t talk to ___', 'Call ___ in emergency', 'Wear ___ on a bike',
        'Don\'t touch ___ outlets', 'Sharp objects can ___', 'Medicines are kept by ___', 'Fire exit signs are ___',
        'Wash hands before ___', 'Don\'t play near ___',
        'Earthquake: go under a ___', 'Fire: stop, drop, and ___', 'Swimming: always with ___',
        'Online safety: don\'t share ___', 'Kitchen safety: stay away from ___',
        'Road sign 🛑 means?', 'Green light means?', 'Yellow light means?',
        'Pedestrian crossing is called?', 'Ambulance number in India?',
        'First aid for burns?', 'If lost, find a ___', 'Never ___ alone in deep water',
        'Seat belt is worn in ___', 'Sunscreen protects from ___', 'Helmet protects your ___',
        'Fire extinguisher is ___', 'Don\'t run with ___', 'Always tell parents your ___',
        'Emergency meeting point is ___'][i],
      options: [['zebra crossing','anywhere','middle'],['strangers','friends','parents'],['100','112','999'],
        ['helmet','cap','nothing'],['electrical','toy','food'],['cut','sing','fly'],['parents','children','pets'],
        ['red','green','blue'],['eating','sleeping','playing'],['water','park','school'],
        ['table','tree','door'],['roll','jump','run'],['adults','pets','toys'],['address','school name','homework'],
        ['stove','fridge','table'],['Stop','Go','Slow'],['Go','Stop','Caution'],['Slow down','Go faster','Stop'],
        ['zebra crossing','highway','roundabout'],['102','108','100'],
        ['cold water','ice','hot water'],['police officer','alone','hidden'],['swim','run','climb'],
        ['cars','buses','bikes'],['UV rays','rain','cold'],['head','hand','foot'],
        ['red','blue','green'],['scissors','pillows','books'],['location','homework','secrets'],
        ['pre-decided','random','secret']][i],
      correctAnswer: ['zebra crossing','strangers','112','helmet','electrical','cut','parents','red','eating','water',
        'table','roll','adults','address','stove','Stop','Go','Slow down','zebra crossing','108',
        'cold water','police officer','swim','cars','UV rays','head','red','scissors','location','pre-decided'][i],
      hint: 'Safety first!', xpReward: [5,5,5,5,5,5,5,5,5,5, 8,8,8,8,8,8,8,8,8,8, 10,10,10,10,10,10,10,10,10,10][i]),
  ];

  // ═══════════ VALUES EXERCISES (100) ═══════════
  static final List<Exercise> _valuesExercises = [
    ..._emotionsExercises,
    ..._lifeSkillsExercises,
    ..._socialExercises,
  ];

  static final _emotionsExercises = [
    for (var i = 0; i < 30; i++) Exercise(id: 'v_e_${(i ~/ 10) + 1}_$i', subject: 'values', topic: 'emotions',
      level: (i ~/ 10) + 1, type: 'mcq',
      question: ['😊 means?', '😢 means?', '😡 means?', '😨 means?', '🤩 means?',
        'What to do when angry?', 'Sharing makes us?', 'Being kind means?', 'When friend is sad we should?',
        'Saying sorry shows?',
        'Empathy means?', 'Self-control is about?', 'A good friend is?', 'How to handle bullying?',
        'Jealousy can be managed by?', 'Gratitude means?', 'Being patient means?',
        'Conflict can be resolved by?', 'Positive thinking helps?', 'Courage means?',
        'Mindfulness is about?', 'Resilience means?', 'Integrity is?', 'Compassion is showing?',
        'Responsibility means?', 'Honesty is always?', 'Forgiveness helps?', 'Teamwork means?',
        'Self-esteem is about?', 'Emotional intelligence is?'][i],
      options: [['happy','sad','angry'],['happy','sad','angry'],['happy','sad','angry'],
        ['scared','happy','proud'],['proud','sad','angry'],
        ['breathe deep','shout','break things'],['happy','sad','angry'],['helping others','fighting','ignoring'],
        ['comfort them','laugh','leave'],['strength','weakness','nothing'],
        ['understanding feelings','eating','sleeping'],['managing emotions','running','jumping'],
        ['kind','mean','selfish'],['tell an adult','fight back','stay quiet'],
        ['being grateful','being angry','ignoring'],['being thankful','being mean','being lazy'],
        ['waiting calmly','rushing','shouting'],['talking','fighting','ignoring'],
        ['feel better','feel worse','nothing'],['facing fears','running away','hiding'],
        ['being present','worrying','sleeping'],['bouncing back','giving up','running'],
        ['doing right','cheating','lying'],['caring','hurting','ignoring'],
        ['owning actions','blaming','hiding'],['the best policy','sometimes good','never good'],
        ['both people','nobody','only one'],['working together','alone','competing'],
        ['self-worth','pride','selfishness'],['understanding emotions','ignoring feelings','hiding emotions']][i],
      correctAnswer: ['happy','sad','angry','scared','proud','breathe deep','happy','helping others',
        'comfort them','strength','understanding feelings','managing emotions','kind','tell an adult',
        'being grateful','being thankful','waiting calmly','talking','feel better','facing fears',
        'being present','bouncing back','doing right','caring','owning actions','the best policy',
        'both people','working together','self-worth','understanding emotions'][i],
      hint: 'Think about feelings and values!', xpReward: [5,5,5,5,5,5,5,5,5,5, 8,8,8,8,8,8,8,8,8,8, 10,10,10,10,10,10,10,10,10,10][i]),
  ];

  static final _lifeSkillsExercises = [
    for (var i = 0; i < 40; i++) Exercise(id: 'v_l_${(i ~/ 10) + 4}_$i', subject: 'values', topic: 'life_skills',
      level: (i ~/ 10) + 4, type: 'mcq',
      question: ['Wash hands before?', 'Brush teeth ___ a day', 'Always say?', 'Wait for your?', 'Share your?',
        'Help at?', 'Be kind to?', 'Save?', 'Keep surroundings?', 'Eat?',
        'Wake up?', 'Sleep on?', 'Homework should be done?', 'Respect?', 'Follow?',
        'Exercise keeps us?', 'Drink enough?', 'Junk food is?', 'Greenvegetables are?', 'Breakfast is?',
        'Reading helps?', 'TV time should be?', 'Helping others makes us?', 'Cleaning room shows?',
        'Being on time means?', 'Saving money is?', 'Wasting food is?', 'Planting trees helps?',
        'Recycling saves?', 'Walking is good for?',
        'Goal setting helps?', 'Time management means?', 'Communication is?', 'Problem solving requires?',
        'Leadership means?', 'Creativity is about?', 'Critical thinking is?', 'Adaptability means?',
        'Perseverance means?', 'Decision making is?'][i],
      options: [['eating','sleeping','playing'],['once','twice','never'],['please/thank you','nothing','mean words'],
        ['turn','never','always first'],['toys','nothing','secrets'],['home','nowhere','only school'],
        ['everyone','no one','bullies'],['water','junk food','anger'],['clean','messy','dirty'],
        ['healthy food','only candy','nothing'],
        ['early','late','never'],['time','whenever','never'],['daily','never','sometimes'],
        ['elders','no one','only friends'],['rules','nobody','nothing'],
        ['healthy','sick','lazy'],['water','soda','no liquid'],['unhealthy','healthy','best'],
        ['healthy','unhealthy','tasteless'],['important','not needed','skip it'],
        ['learn','nothing','waste time'],['limited','unlimited','all day'],
        ['happy','sad','angry'],['responsibility','laziness','nothing'],
        ['punctuality','laziness','nothing'],['wise','wasteful','boring'],['wrong','okay','good'],
        ['environment','nothing','pollution'],['resources','nothing','time'],['health','nothing','nobody'],
        ['plan','nothing','confusion'],['using time well','wasting time','sleeping'],
        ['key skill','unnecessary','boring'],['thinking','guessing','ignoring'],
        ['guiding others','following','hiding'],['new ideas','copying','nothing'],
        ['analyzing','guessing','ignoring'],['adjusting','refusing','fighting'],
        ['not giving up','giving up','resting'],['important','unnecessary','easy']][i],
      correctAnswer: ['eating','twice','please/thank you','turn','toys','home','everyone','water','clean','healthy food',
        'early','time','daily','elders','rules','healthy','water','unhealthy','healthy','important',
        'learn','limited','happy','responsibility','punctuality','wise','wrong','environment','resources','health',
        'plan','using time well','key skill','thinking','guiding others','new ideas','analyzing','adjusting','not giving up','important'][i],
      hint: 'Think about good habits!', xpReward: [5,5,5,5,5,5,5,5,5,5, 8,8,8,8,8,8,8,8,8,8, 10,10,10,10,10,10,10,10,10,10, 12,12,12,12,12,12,12,12,12,12][i]),
  ];

  static final _socialExercises = [
    for (var i = 0; i < 30; i++) Exercise(id: 'v_s_${(i ~/ 10) + 7}_$i', subject: 'values', topic: 'social',
      level: (i ~/ 10) + 7, type: 'mcq',
      question: ['Good manners include?', 'In a line we should?', 'When someone sneezes say?',
        'Listening when others talk is?', 'Helping elderly is?',
        'Respecting differences means?', 'In a team we should?', 'When wrong, we should?',
        'Being polite means?', 'Greeting others is?',
        'Community means?', 'Volunteering is?', 'Charity means?', 'Environment care means?',
        'Cultural diversity is?', 'National symbols should be?', 'Elections are for?',
        'Rights come with?', 'Everyone deserves?', 'Peace starts with?',
        'Democracy means?', 'Constitution is?', 'Independence Day is on?',
        'Republic Day is on?', 'National anthem is?', 'National flag has?',
        'Mahatma Gandhi taught?', 'Non-violence means?', 'Unity in diversity is?',
        'Swachh Bharat means?'][i],
      options: [['please and thank you','shouting','being rude'],['wait','push','cut'],['Bless you','Nothing','Go away'],
        ['polite','rude','boring'],['kind','waste of time','boring'],
        ['accepting all','rejecting','fighting'],['cooperate','fight','ignore'],['apologize','hide','blame'],
        ['speaking kindly','shouting','ignoring'],['polite','waste','boring'],
        ['group of people','one person','animals only'],['helping freely','paid work','forced work'],
        ['giving','taking','hiding'],['protecting nature','polluting','ignoring'],
        ['beautiful','bad','same everywhere'],['respected','ignored','destroyed'],
        ['choosing leaders','fighting','money'],['responsibilities','nothing','excuses'],
        ['respect','nothing','money'],['us','others','weapons'],
        ['people\'s rule','king\'s rule','one person'],['law book','story book','recipe book'],
        ['August 15','January 26','October 2'],['January 26','August 15','November 14'],
        ['Jana Gana Mana','Vande Mataram','Saare Jahan Se'],['3 colors','5 colors','1 color'],
        ['non-violence','fighting','war'],['ahimsa','fighting','hurting'],
        ['India\'s strength','weakness','problem'],['Clean India','Rich India','Big India']][i],
      correctAnswer: ['please and thank you','wait','Bless you','polite','kind',
        'accepting all','cooperate','apologize','speaking kindly','polite',
        'group of people','helping freely','giving','protecting nature','beautiful',
        'respected','choosing leaders','responsibilities','respect','us',
        "people's rule",'law book','August 15','January 26','Jana Gana Mana','3 colors',
        'non-violence','ahimsa',"India's strength",'Clean India'][i],
      hint: 'Think about good social values!', xpReward: [5,5,5,5,5,5,5,5,5,5, 8,8,8,8,8,8,8,8,8,8, 10,10,10,10,10,10,10,10,10,10][i]),
  ];
}

/// Per-topic level tracking service
class LevelTracker {
  // subject -> topic -> {level, xp, exercisesCompleted}
  final Map<String, Map<String, TopicProgress>> _progress = {};

  TopicProgress getProgress(String subject, String topic) {
    return _progress[subject]?[topic] ?? TopicProgress();
  }

  void recordCompletion(String subject, String topic, int xpEarned, bool correct) {
    _progress.putIfAbsent(subject, () => {});
    _progress[subject]!.putIfAbsent(topic, () => TopicProgress());
    final tp = _progress[subject]![topic]!;
    tp.totalAttempts++;
    if (correct) {
      tp.correctAnswers++;
      tp.xpEarned += xpEarned;
    }
    // Level up every 10 correct answers
    tp.currentLevel = (tp.correctAnswers ~/ 10) + 1;
    if (tp.currentLevel > 10) tp.currentLevel = 10;
  }

  int getTotalExercisesCompleted(String subject) {
    if (!_progress.containsKey(subject)) return 0;
    return _progress[subject]!.values.fold(0, (sum, tp) => sum + tp.totalAttempts);
  }

  int getTotalCorrect(String subject) {
    if (!_progress.containsKey(subject)) return 0;
    return _progress[subject]!.values.fold(0, (sum, tp) => sum + tp.correctAnswers);
  }

  Map<String, TopicProgress> getSubjectProgress(String subject) {
    return _progress[subject] ?? {};
  }
}

class TopicProgress {
  int currentLevel;
  int xpEarned;
  int totalAttempts;
  int correctAnswers;

  TopicProgress({this.currentLevel = 1, this.xpEarned = 0, this.totalAttempts = 0, this.correctAnswers = 0});

  double get accuracy => totalAttempts > 0 ? correctAnswers / totalAttempts : 0;
  String get levelName => _levelNames[(currentLevel - 1).clamp(0, 9)];
  String get levelEmoji => _levelEmojis[(currentLevel - 1).clamp(0, 9)];

  static const _levelNames = ['Beginner', 'Learner', 'Explorer', 'Builder', 'Achiever',
    'Expert', 'Master', 'Champion', 'Legend', 'Genius'];
  static const _levelEmojis = ['🌱', '📖', '🔍', '🏗️', '⭐', '🎯', '🏆', '👑', '🌟', '🧠'];
}

final exerciseBankProvider = Provider<ExerciseBank>((ref) => ExerciseBank());
final levelTrackerProvider = Provider<LevelTracker>((ref) => LevelTracker());
