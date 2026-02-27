import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/xp_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../../shared/widgets/quiz_result_screen.dart';
import 'package:learn_app/core/widgets/tappable.dart';

/// Coding World — visual block coding for kids (sequences, loops, conditions, debugging)
class CodingWorldScreen extends ConsumerStatefulWidget {
  const CodingWorldScreen({super.key});
  @override
  ConsumerState<CodingWorldScreen> createState() => _CodingWorldScreenState();
}

class _CodingWorldScreenState extends ConsumerState<CodingWorldScreen> {
  int _selectedModule = -1;

  static const _modules = [
    {'emoji': '🔢', 'title': 'Sequences', 'desc': 'Put steps in order', 'color': 0xFF00CEC9, 'locked': false},
    {'emoji': '🔁', 'title': 'Loops', 'desc': 'Repeat actions', 'color': 0xFF6C5CE7, 'locked': false},
    {'emoji': '❓', 'title': 'Conditions', 'desc': 'If this, then that', 'color': 0xFFFF9F43, 'locked': false},
    {'emoji': '🐛', 'title': 'Debugging', 'desc': 'Find the bug!', 'color': 0xFFFF6B6B, 'locked': false},
    {'emoji': '🧩', 'title': 'Patterns', 'desc': 'Code patterns', 'color': 0xFF1DD1A1, 'locked': false},
    {'emoji': '🚀', 'title': 'Projects', 'desc': 'Build something!', 'color': 0xFF0984E3, 'locked': false},
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedModule >= 0) return _buildModule(_selectedModule);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Row(children: [
              Tappable(onTap: () => context.pop(),
                child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.codingWorld.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.codingWorld))),
              const SizedBox(width: 12),
              Text('💻 Coding World', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 20),

            // Hero banner
            Container(
              width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.codingWorld, AppColors.codingWorld.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🤖', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text('Learn to Think Like a Computer!', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Visual coding puzzles — no typing needed!', style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70)),
              ]),
            ),
            const SizedBox(height: 24),

            Text('Modules', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            // Module grid
            ...List.generate(_modules.length, (i) {
              final m = _modules[i];
              final color = Color(m['color'] as int);
              return Padding(padding: const EdgeInsets.only(bottom: 12),
                child: Tappable(
                  onTap: () => setState(() => _selectedModule = i),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card,
                      border: Border.all(color: color.withValues(alpha: 0.2))),
                    child: Row(children: [
                      Container(width: 50, height: 50,
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                        child: Center(child: Text(m['emoji'] as String, style: const TextStyle(fontSize: 24)))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(m['title'] as String, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
                        Text(m['desc'] as String, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
                      ])),
                      Icon(Icons.play_circle_filled_rounded, size: 36, color: color),
                    ]),
                  ),
                ),
              );
            }),
          ]),
        ),
      ),
    );
  }

  Widget _buildModule(int moduleIndex) {
    switch (moduleIndex) {
      case 0: return _SequencesModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 1: return _LoopsModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 2: return _ConditionsModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 3: return _DebuggingModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 4: return _PatternsModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 5: return _ProjectsModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      default: return const SizedBox();
    }
  }
}

// ═══════════ SEQUENCES MODULE ═══════════
class _SequencesModule extends StatefulWidget {
  final VoidCallback onBack;
  final XPService xpService;
  const _SequencesModule({required this.onBack, required this.xpService});
  @override
  State<_SequencesModule> createState() => _SequencesModuleState();
}

class _SequencesModuleState extends State<_SequencesModule> {
  int _q = 0; int _score = 0;
  List<String> _userOrder = [];
  bool _checked = false;
  bool _done = false;

  static const _questions = [
    {'title': '🤖 Robot walks to the flower', 'steps': ['Start', 'Walk Forward', 'Walk Forward', 'Pick Flower', 'Done!'],
      'hint': 'Put the steps in order to help the robot'},
    {'title': '🍳 Make a sandwich', 'steps': ['Get bread', 'Add butter', 'Add filling', 'Close bread', 'Eat!'],
      'hint': 'What comes first when making a sandwich?'},
    {'title': '🧹 Clean your room', 'steps': ['Pick up toys', 'Make bed', 'Sweep floor', 'Dust shelf', 'All clean!'],
      'hint': 'Think about what to do first'},
    {'title': '🦷 Brush teeth', 'steps': ['Get toothbrush', 'Add paste', 'Brush teeth', 'Rinse mouth', 'Smile!'],
      'hint': 'Morning routine steps'},
    {'title': '🎨 Paint a picture', 'steps': ['Get paper', 'Get paint', 'Dip brush', 'Paint picture', 'Let it dry!'],
      'hint': 'Art class steps'},
    {'title': '📬 Send a letter', 'steps': ['Write letter', 'Put in envelope', 'Add stamp', 'Go to mailbox', 'Post it!'],
      'hint': 'Mail delivery steps'},
    {'title': '🌱 Plant a seed', 'steps': ['Dig hole', 'Put seed', 'Cover soil', 'Water it', 'Watch grow!'],
      'hint': 'Gardening steps'},
    {'title': '🐕 Walk the dog', 'steps': ['Get leash', 'Attach to dog', 'Open door', 'Walk outside', 'Come home!'],
      'hint': 'Pet care steps'},
    {'title': '📱 Make a phone call', 'steps': ['Pick up phone', 'Dial number', 'Wait for answer', 'Say hello', 'Talk!'],
      'hint': 'Communication steps'},
    {'title': '🚿 Take a bath', 'steps': ['Turn on water', 'Get in tub', 'Use soap', 'Rinse off', 'Dry with towel!'],
      'hint': 'Hygiene steps'},
  ];

  List<String> get _shuffled {
    final s = List<String>.from(_questions[_q]['steps'] as List);
    s.shuffle();
    return s;
  }

  @override
  void initState() { super.initState(); _userOrder = []; }

  void _check() {
    final correct = _questions[_q]['steps'] as List<String>;
    final isCorrect = _userOrder.length == correct.length &&
        List.generate(correct.length, (i) => _userOrder[i] == correct[i]).every((e) => e);
    setState(() { _checked = true; if (isCorrect) { _score++; widget.xpService.addXP(8); } });
  }

  void _next() {
    if (_q < _questions.length - 1) {
      setState(() { _q++; _userOrder = []; _checked = false; });
    } else {
      setState(() => _done = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return QuizResultScreen(
        score: _score, total: _questions.length, title: '🔢 Sequences', color: const Color(0xFF00CEC9),
        onBack: widget.onBack,
        onRetry: () => setState(() { _q = 0; _score = 0; _userOrder = []; _checked = false; _done = false; }));
    }
    final q = _questions[_q];
    final correctSteps = q['steps'] as List<String>;
    // Available steps = all steps not yet placed
    final available = List<String>.from(correctSteps);
    for (final placed in _userOrder) { available.remove(placed); }

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            Tappable(onTap: widget.onBack,
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF00CEC9).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF00CEC9)))),
            const SizedBox(width: 12),
            Expanded(child: Text('🔢 Sequences ${_q + 1}/${_questions.length}', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800))),
            Text('⭐ $_score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
          ]),
          const SizedBox(height: 12),

          Container(width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
            child: Column(children: [
              Text(q['title'] as String, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(q['hint'] as String, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
            ])),
          const SizedBox(height: 16),

          // User's ordered sequence
          Text('Your Order:', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (int i = 0; i < _userOrder.length; i++)
              Tappable(
                onTap: _checked ? null : () => setState(() => _userOrder.removeAt(i)),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _checked ? (_userOrder[i] == correctSteps[i] ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1)) : const Color(0xFF00CEC9).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _checked ? (_userOrder[i] == correctSteps[i] ? AppColors.success : AppColors.error) : const Color(0xFF00CEC9))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('${i + 1}. ', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF00CEC9))),
                    Text(_userOrder[i], style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700)),
                  ]))),
          ]),
          const SizedBox(height: 16),

          // Available blocks
          if (!_checked) ...[
            Text('Tap blocks to add:', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: available.map((step) =>
              Tappable(
                onTap: () { HapticFeedback.lightImpact(); setState(() => _userOrder.add(step)); },
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.textLight.withValues(alpha: 0.3))),
                  child: Text(step, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600))),
              )).toList()),
          ],

          const Spacer(),

          if (!_checked && _userOrder.length == correctSteps.length)
            PrimaryButton(label: '✅ Check Order', onPressed: _check, color: const Color(0xFF00CEC9)),
          if (_checked)
            PrimaryButton(label: _q < _questions.length - 1 ? 'Next →' : 'Finish!', onPressed: _next),
        ]))),
    );
  }
}

// ═══════════ LOOPS MODULE ═══════════
class _LoopsModule extends StatefulWidget {
  final VoidCallback onBack;
  final XPService xpService;
  const _LoopsModule({required this.onBack, required this.xpService});
  @override
  State<_LoopsModule> createState() => _LoopsModuleState();
}

class _LoopsModuleState extends State<_LoopsModule> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': '🔁 Repeat "clap" 3 times. How many claps?', 'opts': ['2', '3', '4'], 'ans': '3'},
    {'q': '🔁 Repeat "jump" 5 times. How many jumps?', 'opts': ['4', '5', '6'], 'ans': '5'},
    {'q': '🤖 Robot: repeat(Walk, 4). Where is robot after 4 walks?', 'opts': ['2 steps away', '4 steps away', '3 steps away'], 'ans': '4 steps away'},
    {'q': '🎵 Repeat "la la" 2 times = ?', 'opts': ['la la', 'la la la la', 'la'], 'ans': 'la la la la'},
    {'q': '🖍️ Draw a square. How many times repeat "draw line + turn"?', 'opts': ['3', '4', '5'], 'ans': '4'},
    {'q': '🌸 Plant 1 flower, repeat 6 times. Total flowers?', 'opts': ['5', '6', '7'], 'ans': '6'},
    {'q': '📦 Pack 2 items each loop, loop 3 times. Total items?', 'opts': ['5', '6', '8'], 'ans': '6'},
    {'q': '🔁 while(hungry) { eat }. When does it stop?', 'opts': ['Never', 'When full', 'After 3 times'], 'ans': 'When full'},
    {'q': '🔁 for(i=1 to 3) { say "hi" }. How many "hi"s?', 'opts': ['2', '3', '4'], 'ans': '3'},
    {'q': '🎯 repeat(score a goal, 2). Total goals?', 'opts': ['1', '2', '3'], 'ans': '2'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) {
      return QuizResultScreen(
        score: _score, total: _questions.length, title: '🔁 Loops', color: const Color(0xFF6C5CE7),
        onBack: widget.onBack,
        onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    }
    final q = _questions[_q];
    return _QuizShell(
      emoji: '🔁', title: 'Loops', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      onSelect: (v) { if (_answered) return;
        HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } });
      },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }),
    );
  }
}

// ═══════════ CONDITIONS MODULE ═══════════
class _ConditionsModule extends StatefulWidget {
  final VoidCallback onBack;
  final XPService xpService;
  const _ConditionsModule({required this.onBack, required this.xpService});
  @override
  State<_ConditionsModule> createState() => _ConditionsModuleState();
}

class _ConditionsModuleState extends State<_ConditionsModule> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': 'IF it rains THEN take ___', 'opts': ['umbrella ☂️', 'sunglasses 🕶️', 'hat 🎩'], 'ans': 'umbrella ☂️'},
    {'q': 'IF hungry THEN ___', 'opts': ['eat 🍕', 'sleep 😴', 'run 🏃'], 'ans': 'eat 🍕'},
    {'q': 'IF traffic light is red THEN ___', 'opts': ['stop 🛑', 'go 🟢', 'turn 🔄'], 'ans': 'stop 🛑'},
    {'q': 'IF it is cold THEN wear ___', 'opts': ['jacket 🧥', 'shorts 🩳', 'sandals 🩴'], 'ans': 'jacket 🧥'},
    {'q': 'IF age >= 18 THEN can ___', 'opts': ['vote 🗳️', 'fly ✈️', 'swim 🏊'], 'ans': 'vote 🗳️'},
    {'q': 'IF dark outside THEN ___', 'opts': ['turn on light 💡', 'go outside 🚶', 'cook 🍳'], 'ans': 'turn on light 💡'},
    {'q': 'IF score > 90 THEN grade = ___', 'opts': ['A ⭐', 'B 📗', 'C 📙'], 'ans': 'A ⭐'},
    {'q': 'IF battery low THEN ___', 'opts': ['charge phone 🔌', 'play games 🎮', 'call friend 📞'], 'ans': 'charge phone 🔌'},
    {'q': 'IF weekend THEN ___', 'opts': ['play 🎉', 'go to school 🏫', 'do office work 💼'], 'ans': 'play 🎉'},
    {'q': 'IF flower wilted THEN ___', 'opts': ['water it 💧', 'paint it 🎨', 'eat it 🍽️'], 'ans': 'water it 💧'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) {
      return QuizResultScreen(
        score: _score, total: _questions.length, title: '❓ Conditions', color: const Color(0xFFFF9F43),
        onBack: widget.onBack,
        onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    }
    final q = _questions[_q];
    return _QuizShell(
      emoji: '❓', title: 'Conditions', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      onSelect: (v) { if (_answered) return;
        HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } });
      },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }),
    );
  }
}

// ═══════════ DEBUGGING MODULE ═══════════
class _DebuggingModule extends StatefulWidget {
  final VoidCallback onBack;
  final XPService xpService;
  const _DebuggingModule({required this.onBack, required this.xpService});
  @override
  State<_DebuggingModule> createState() => _DebuggingModuleState();
}

class _DebuggingModuleState extends State<_DebuggingModule> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': '🐛 Bug: "1 + 1 = 3". What\'s wrong?', 'opts': ['Answer should be 2', 'Question is wrong', 'Nothing wrong'], 'ans': 'Answer should be 2'},
    {'q': '🐛 Robot should turn LEFT but goes RIGHT. Fix?', 'opts': ['Change RIGHT to LEFT', 'Add more steps', 'Remove robot'], 'ans': 'Change RIGHT to LEFT'},
    {'q': '🐛 Loop runs forever! Fix?', 'opts': ['Add a stop condition', 'Add more loops', 'Delete everything'], 'ans': 'Add a stop condition'},
    {'q': '🐛 Code: IF sunny THEN wear coat. Bug?', 'opts': ['Should wear sunglasses', 'Coat is correct', 'Remove IF'], 'ans': 'Should wear sunglasses'},
    {'q': '🐛 Sequence: Eat → Brush → Wake up. Bug?', 'opts': ['Wake up should be first', 'Eat should be last', 'No bug'], 'ans': 'Wake up should be first'},
    {'q': '🐛 print("Hello Wolrd"). What\'s the bug?', 'opts': ['Spelling: "World"', 'Should be "Hi"', 'No bug'], 'ans': 'Spelling: "World"'},
    {'q': '🐛 for(i=0; i<5) — missing what?', 'opts': ['i++ (increment)', 'i-- (decrement)', 'Nothing'], 'ans': 'i++ (increment)'},
    {'q': '🐛 IF age > 18... but baby can vote. Bug?', 'opts': ['Should be >= 18', 'Logic is correct', 'Remove condition'], 'ans': 'Should be >= 18'},
    {'q': '🐛 Recipe says: Bake → Mix → Get ingredients. Fix?', 'opts': ['Reverse the order', 'Add more steps', 'Skip mixing'], 'ans': 'Reverse the order'},
    {'q': '🐛 Calculator: 5 × 0 = 5. What\'s the bug?', 'opts': ['Answer should be 0', 'Answer should be 5', 'Answer should be 50'], 'ans': 'Answer should be 0'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) {
      return QuizResultScreen(
        score: _score, total: _questions.length, title: '🐛 Bug Hunter', color: const Color(0xFFFF6B6B),
        onBack: widget.onBack,
        onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    }
    final q = _questions[_q];
    return _QuizShell(
      emoji: '🐛', title: 'Debugging', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      onSelect: (v) { if (_answered) return;
        HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(8); } });
      },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }),
    );
  }
}

// ═══════════ PATTERNS MODULE ═══════════
class _PatternsModule extends StatefulWidget {
  final VoidCallback onBack;
  final XPService xpService;
  const _PatternsModule({required this.onBack, required this.xpService});
  @override
  State<_PatternsModule> createState() => _PatternsModuleState();
}

class _PatternsModuleState extends State<_PatternsModule> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': 'What pattern? ⬆️➡️⬆️➡️⬆️___', 'opts': ['➡️', '⬆️', '⬇️'], 'ans': '➡️'},
    {'q': 'Complete: 🔴🔵🔴🔵🔴___', 'opts': ['🔴', '🔵', '🟢'], 'ans': '🔵'},
    {'q': 'Code: AB AB AB ___', 'opts': ['AB', 'BA', 'AA'], 'ans': 'AB'},
    {'q': 'Pattern: 1 2 1 2 1 ___', 'opts': ['1', '2', '3'], 'ans': '2'},
    {'q': 'Nested: (AB)(AB)(AB) = repeat(___, 3)', 'opts': ['AB', 'A', 'B'], 'ans': 'AB'},
    {'q': 'Growing: ⭐ ⭐⭐ ⭐⭐⭐ ___', 'opts': ['⭐⭐⭐⭐', '⭐⭐⭐', '⭐⭐'], 'ans': '⭐⭐⭐⭐'},
    {'q': 'Shrinking: 🔵🔵🔵 🔵🔵 🔵 ___', 'opts': ['(empty)', '🔵', '🔵🔵'], 'ans': '(empty)'},
    {'q': 'Mirror: ABCBA. Middle is?', 'opts': ['C', 'B', 'A'], 'ans': 'C'},
    {'q': 'Fibonacci: 1, 1, 2, 3, 5, ___', 'opts': ['7', '8', '6'], 'ans': '8'},
    {'q': 'Binary: 0, 1, 0, 1, 0, ___', 'opts': ['0', '1', '2'], 'ans': '1'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) {
      return QuizResultScreen(
        score: _score, total: _questions.length, title: '🧩 Patterns', color: const Color(0xFF1DD1A1),
        onBack: widget.onBack,
        onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    }
    final q = _questions[_q];
    return _QuizShell(
      emoji: '🧩', title: 'Patterns', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      onSelect: (v) { if (_answered) return;
        HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } });
      },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }),
    );
  }
}

// ═══════════ PROJECTS MODULE ═══════════
class _ProjectsModule extends StatefulWidget {
  final VoidCallback onBack;
  final XPService xpService;
  const _ProjectsModule({required this.onBack, required this.xpService});
  @override
  State<_ProjectsModule> createState() => _ProjectsModuleState();
}

class _ProjectsModuleState extends State<_ProjectsModule> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': '🏠 Build a house: What block type for the base?', 'opts': ['Rectangle', 'Triangle', 'Circle'], 'ans': 'Rectangle'},
    {'q': '🏠 What goes on top of a house?', 'opts': ['Roof (triangle)', 'Wheel', 'Wing'], 'ans': 'Roof (triangle)'},
    {'q': '🚗 Build a car: Wheels are what shape?', 'opts': ['Circle', 'Square', 'Triangle'], 'ans': 'Circle'},
    {'q': '🌈 Rainbow colors order: Red, Orange, ___', 'opts': ['Yellow', 'Blue', 'Green'], 'ans': 'Yellow'},
    {'q': '🎮 Game: Player gets a coin → score + ___', 'opts': ['1', '0', '-1'], 'ans': '1'},
    {'q': '🎮 Game over when lives = ___', 'opts': ['0', '3', '10'], 'ans': '0'},
    {'q': '🤖 Robot dance: spin + jump = 1 move. 4 moves = ?', 'opts': ['4 spins + 4 jumps', '4 spins', '8 spins'], 'ans': '4 spins + 4 jumps'},
    {'q': '📐 Draw a triangle: How many lines?', 'opts': ['3', '4', '2'], 'ans': '3'},
    {'q': '🎵 Music app: Play note, wait, play note. What concept?', 'opts': ['Sequence', 'Loop', 'Condition'], 'ans': 'Sequence'},
    {'q': '🎯 Complete project badge earned! What did you learn?', 'opts': ['All concepts!', 'Only loops', 'Nothing'], 'ans': 'All concepts!'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) {
      return QuizResultScreen(
        score: _score, total: _questions.length, title: '🚀 Projects', color: const Color(0xFF0984E3),
        onBack: widget.onBack,
        onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    }
    final q = _questions[_q];
    return _QuizShell(
      emoji: '🚀', title: 'Projects', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      onSelect: (v) { if (_answered) return;
        HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(8); } });
      },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }),
    );
  }
}

// ═══════════ SHARED QUIZ SHELL ═══════════
class _QuizShell extends StatelessWidget {
  final String emoji, title, question, answer;
  final int q, total, score;
  final List<String> options;
  final String? selected;
  final bool answered;
  final VoidCallback onBack, onNext;
  final ValueChanged<String> onSelect;

  const _QuizShell({required this.emoji, required this.title, required this.q, required this.total,
    required this.score, required this.question, required this.options, required this.answer,
    required this.selected, required this.answered, required this.onBack, required this.onNext, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isCorrect = selected == answer;
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            Tappable(onTap: onBack,
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.codingWorld.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.codingWorld))),
            const SizedBox(width: 12),
            Expanded(child: Text('$emoji $title ${q + 1}/$total', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800))),
            Text('⭐ $score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: (q + 1) / total, minHeight: 8,
              backgroundColor: AppColors.codingWorld.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation(AppColors.codingWorld))),
          const SizedBox(height: 20),

          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
            child: Text(question, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark), textAlign: TextAlign.center)),
          const SizedBox(height: 16),

          ...options.map((opt) {
            final isThis = selected == opt;
            final isAns = opt == answer;
            Color bg = Colors.white, border = AppColors.textLight.withValues(alpha: 0.2);
            if (answered) {
              if (isAns) { bg = AppColors.success.withValues(alpha: 0.1); border = AppColors.success; }
              else if (isThis) { bg = AppColors.error.withValues(alpha: 0.1); border = AppColors.error; }
            }
            return Padding(padding: const EdgeInsets.only(bottom: 10),
              child: Tappable(onTap: () => onSelect(opt),
                child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 2)),
                  child: Row(children: [
                    Expanded(child: Text(opt, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700))),
                    if (answered && isAns) const Icon(Icons.check_circle, color: AppColors.success),
                    if (answered && isThis && !isAns) const Icon(Icons.cancel, color: AppColors.error),
                  ]))));
          }),

          const Spacer(),
          if (answered)
            PrimaryButton(label: q < total - 1 ? 'Next →' : 'See Results', onPressed: onNext,
              color: isCorrect ? AppColors.success : AppColors.codingWorld),
        ]))),
    );
  }
}

