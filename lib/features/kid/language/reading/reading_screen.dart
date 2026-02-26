import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/xp_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';

/// Reading Screen — paragraph comprehension passages with questions
class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});
  @override ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  int _passage = 0;
  int _q = 0;
  int _score = 0;
  String? _sel;
  bool _ans = false;
  bool _showQ = false;

  static const _passages = [
    {
      'title': '🐕 Max the Dog',
      'text': 'Max is a brown dog. He lives with a family. Every morning, Max goes for a walk in the park. He likes to play with a red ball. Max wags his tail when he is happy. He is a good dog.',
      'questions': [
        {'q': 'What color is Max?', 'opts': ['Brown', 'White', 'Black'], 'a': 'Brown'},
        {'q': 'Where does Max go every morning?', 'opts': ['Park', 'School', 'Shop'], 'a': 'Park'},
        {'q': 'What does Max play with?', 'opts': ['Red ball', 'Blue toy', 'Stick'], 'a': 'Red ball'},
      ]
    },
    {
      'title': '🌸 The Garden',
      'text': 'Priya has a beautiful garden. She grows roses, sunflowers, and tulips. Every day she waters the plants. Butterflies visit her garden. Priya loves to sit in the garden and read books. The garden smells wonderful.',
      'questions': [
        {'q': 'Who has a garden?', 'opts': ['Priya', 'Riya', 'Maya'], 'a': 'Priya'},
        {'q': 'Which flowers grow in the garden?', 'opts': ['Roses, sunflowers, tulips', 'Only roses', 'Daisies'], 'a': 'Roses, sunflowers, tulips'},
        {'q': 'What visits the garden?', 'opts': ['Butterflies', 'Birds', 'Cats'], 'a': 'Butterflies'},
      ]
    },
    {
      'title': '🏫 School Day',
      'text': 'Arjun wakes up at 7 AM. He brushes his teeth and eats breakfast. He wears his school uniform. His mother packs his lunch box. Arjun walks to school with his friends. His favorite subject is math.',
      'questions': [
        {'q': 'What time does Arjun wake up?', 'opts': ['7 AM', '8 AM', '6 AM'], 'a': '7 AM'},
        {'q': 'Who packs his lunch?', 'opts': ['His mother', 'His father', 'Himself'], 'a': 'His mother'},
        {'q': 'What is his favorite subject?', 'opts': ['Math', 'English', 'Science'], 'a': 'Math'},
      ]
    },
    {
      'title': '🌧️ Rainy Day',
      'text': 'It was raining outside. Meera could not go to the park. She decided to draw pictures at home. She drew a rainbow with seven colors. Her brother Rohan made paper boats. They floated the boats in puddles later.',
      'questions': [
        {'q': 'Why could Meera not go to the park?', 'opts': ['It was raining', 'She was sick', 'Park was closed'], 'a': 'It was raining'},
        {'q': 'What did Meera draw?', 'opts': ['Rainbow', 'House', 'Dog'], 'a': 'Rainbow'},
        {'q': 'What did Rohan make?', 'opts': ['Paper boats', 'Paper planes', 'Paper hats'], 'a': 'Paper boats'},
      ]
    },
    {
      'title': '🎂 Birthday Party',
      'text': 'Today is Ananya\'s birthday. She is turning 6 years old. Her parents decorated the house with balloons. Ananya wore a pink dress. Her friends came and brought gifts. They ate cake and played games. Everyone had a wonderful time.',
      'questions': [
        {'q': 'How old is Ananya turning?', 'opts': ['6', '5', '7'], 'a': '6'},
        {'q': 'What color dress did she wear?', 'opts': ['Pink', 'Blue', 'Red'], 'a': 'Pink'},
        {'q': 'What was used to decorate?', 'opts': ['Balloons', 'Lights', 'Flowers'], 'a': 'Balloons'},
      ]
    },
    {
      'title': '🐘 Visit to the Zoo',
      'text': 'Rahul visited the zoo with his class. He saw lions, elephants, and monkeys. The elephants were eating bananas. The monkeys were jumping from tree to tree. The lion was sleeping in its den. Rahul\'s favorite animal was the elephant.',
      'questions': [
        {'q': 'Who did Rahul visit the zoo with?', 'opts': ['His class', 'His family', 'His friend'], 'a': 'His class'},
        {'q': 'What were the elephants eating?', 'opts': ['Bananas', 'Apples', 'Grass'], 'a': 'Bananas'},
        {'q': 'What was Rahul\'s favorite animal?', 'opts': ['Elephant', 'Lion', 'Monkey'], 'a': 'Elephant'},
      ]
    },
    {
      'title': '🌙 Bedtime Story',
      'text': 'Every night before bed, Grandma tells Sara a story. Tonight she told about a brave princess who saved a village. The princess used her wisdom to solve a riddle. Sara listened carefully. She fell asleep dreaming about being a princess too.',
      'questions': [
        {'q': 'Who tells Sara stories?', 'opts': ['Grandma', 'Mother', 'Father'], 'a': 'Grandma'},
        {'q': 'What did the princess save?', 'opts': ['A village', 'A castle', 'A forest'], 'a': 'A village'},
        {'q': 'How did the princess win?', 'opts': ['Solved a riddle', 'Used a sword', 'Called for help'], 'a': 'Solved a riddle'},
      ]
    },
    {
      'title': '🥕 The Market',
      'text': 'Amma took Lakshmi to the market. They bought vegetables – carrots, potatoes, and tomatoes. The market was very crowded. Lakshmi helped carry the bags. They also bought fresh fruit – mangoes and bananas. The mangoes were yellow and sweet.',
      'questions': [
        {'q': 'Where did they go?', 'opts': ['Market', 'School', 'Park'], 'a': 'Market'},
        {'q': 'Which vegetables did they buy?', 'opts': ['Carrots, potatoes, tomatoes', 'Only carrots', 'Onions'], 'a': 'Carrots, potatoes, tomatoes'},
        {'q': 'What color were the mangoes?', 'opts': ['Yellow', 'Green', 'Red'], 'a': 'Yellow'},
      ]
    },
  ];

  List<Map<String, dynamic>> get _currentQuestions =>
    (_passages[_passage]['questions'] as List<Map<String, dynamic>>);

  @override
  Widget build(BuildContext context) {
    if (_passage >= _passages.length) {
      return Scaffold(backgroundColor: AppColors.bgLight,
        body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('📚', style: TextStyle(fontSize: 60)),
          Text('All Passages Complete!', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w900)),
          Text('Score: $_score', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Done', onPressed: () => context.pop()),
        ]))));
    }

    final p = _passages[_passage];
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            GestureDetector(onTap: () => context.pop(),
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.primary))),
            const SizedBox(width: 12),
            Expanded(child: Text('📖 Reading ${_passage + 1}/${_passages.length}', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800))),
            Text('⭐ $_score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: (_passage + 1) / _passages.length, minHeight: 8,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
          const SizedBox(height: 16),

          Expanded(child: SingleChildScrollView(child: Column(children: [
            // Title
            Text(p['title'] as String, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            // Passage
            Container(width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
              child: Text(p['text'] as String, style: GoogleFonts.nunito(fontSize: 16, height: 1.8, color: AppColors.textDark))),
            const SizedBox(height: 16),

            if (!_showQ)
              PrimaryButton(label: '📝 Answer Questions', onPressed: () => setState(() => _showQ = true))
            else ...[
              // Questions
              _buildQuestion(),
            ],
          ]))),
        ]))),
    );
  }

  Widget _buildQuestion() {
    if (_q >= _currentQuestions.length) {
      return Column(children: [
        Container(padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            const Text('✅', style: TextStyle(fontSize: 36)),
            Text('Passage Complete!', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
          ])),
        const SizedBox(height: 12),
        PrimaryButton(label: 'Next Passage →', onPressed: () {
          setState(() { _passage++; _q = 0; _sel = null; _ans = false; _showQ = false; });
        }),
      ]);
    }

    final q = _currentQuestions[_q];
    return Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
        child: Text('Q${_q + 1}: ${q['q']}', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700))),
      const SizedBox(height: 10),
      ...(q['opts'] as List<String>).map((o) {
        final isSel = _sel == o; final isA = o == q['a'];
        Color bg = Colors.white, border = AppColors.textLight.withValues(alpha: 0.2);
        if (_ans) { if (isA) { bg = AppColors.success.withValues(alpha: 0.1); border = AppColors.success; }
          else if (isSel) { bg = AppColors.error.withValues(alpha: 0.1); border = AppColors.error; } }
        return Padding(padding: const EdgeInsets.only(bottom: 8), child: GestureDetector(
          onTap: () { if (_ans) return; HapticFeedback.lightImpact();
            setState(() { _sel = o; _ans = true; if (o == q['a']) { _score++; ref.read(xpServiceProvider).addXP(8); } }); },
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: border, width: 2)),
            child: Text(o, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)))));
      }),
      if (_ans) ...[
        const SizedBox(height: 8),
        PrimaryButton(label: _q < _currentQuestions.length - 1 ? 'Next Question' : 'Complete Passage', onPressed: () {
          setState(() { _q++; _sel = null; _ans = false; });
        }),
      ],
    ]);
  }
}
