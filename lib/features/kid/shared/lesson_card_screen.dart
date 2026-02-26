import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';

/// Mimo-style lesson card screen — swipeable card stack
class LessonCardScreen extends ConsumerStatefulWidget {
  final String subject;
  final String topic;
  const LessonCardScreen({super.key, required this.subject, required this.topic});
  @override ConsumerState<LessonCardScreen> createState() => _LessonCardScreenState();
}

class _LessonCardScreenState extends ConsumerState<LessonCardScreen> {
  int _currentCard = 0;
  bool _completed = false;

  // Pre-built lesson card data for different subjects
  List<Map<String, dynamic>> get _cards {
    return _lessonData[widget.subject]?[widget.topic] ?? _defaultCards;
  }

  static const _defaultCards = [
    {'type': 'concept', 'emoji': '📖', 'title': 'Introduction', 'body': 'Welcome to this lesson! Let\'s learn something new today.'},
    {'type': 'example', 'emoji': '💡', 'title': 'Example', 'body': 'Here\'s an example to understand better.'},
    {'type': 'quiz', 'emoji': '🧠', 'title': 'Quick Quiz', 'body': 'Let\'s test what you learned!',
      'q': 'Did you understand the lesson?', 'opts': ['Yes!', 'Not yet'], 'a': 'Yes!'},
    {'type': 'summary', 'emoji': '⭐', 'title': 'Summary', 'body': 'Great job! You\'ve completed this lesson.'},
  ];

  static const Map<String, Map<String, List<Map<String, dynamic>>>> _lessonData = {
    'grammar': {
      'nouns': [
        {'type': 'concept', 'emoji': '📖', 'title': 'What is a Noun?', 'body': 'A noun is a word that names a person, place, thing, or idea.\n\n👤 Person: boy, girl, teacher\n📍 Place: school, park, city\n📦 Thing: book, ball, chair\n💭 Idea: love, happiness, freedom'},
        {'type': 'example', 'emoji': '💡', 'title': 'Examples', 'body': '✅ "The DOG runs fast." — Dog is a noun!\n✅ "INDIA is beautiful." — India is a noun!\n✅ "She feels JOY." — Joy is a noun!'},
        {'type': 'concept', 'emoji': '🏷️', 'title': 'Common vs Proper', 'body': '📝 Common Nouns: general names\n→ city, river, boy\n\n📝 Proper Nouns: specific names (Capital letter!)\n→ Delhi, Ganga, Arjun'},
        {'type': 'quiz', 'emoji': '🧠', 'title': 'Quick Check!', 'body': 'Is "book" a noun?', 'q': 'Is "book" a noun?', 'opts': ['Yes ✅', 'No ❌'], 'a': 'Yes ✅'},
        {'type': 'summary', 'emoji': '⭐', 'title': 'Well Done!', 'body': '🎯 Nouns name people, places, things, ideas!\n📌 Common nouns = general (city)\n📌 Proper nouns = specific (Delhi)'},
      ],
      'verbs': [
        {'type': 'concept', 'emoji': '🏃', 'title': 'What is a Verb?', 'body': 'A verb is an action word — it tells what someone DOES.\n\n🏃 Run, Jump, Swim\n📖 Read, Write, Draw\n🎤 Sing, Dance, Play'},
        {'type': 'example', 'emoji': '💡', 'title': 'Spot the Verb', 'body': '✅ "She RUNS fast." — Runs is the verb!\n✅ "He EATS rice." — Eats is the verb!\n✅ "They PLAY cricket." — Play is the verb!'},
        {'type': 'concept', 'emoji': '⏰', 'title': 'Tenses', 'body': '📌 Past: She walked (already done)\n📌 Present: She walks (happening now)\n📌 Future: She will walk (will happen)'},
        {'type': 'quiz', 'emoji': '🧠', 'title': 'Quick Check!', 'body': 'Which is a verb?', 'q': 'Which is a verb?', 'opts': ['Run 🏃', 'Book 📖', 'Happy 😊'], 'a': 'Run 🏃'},
        {'type': 'summary', 'emoji': '⭐', 'title': 'Fantastic!', 'body': '🎯 Verbs are action words!\n📌 Past, Present, Future tenses\n📌 Every sentence needs a verb!'},
      ],
    },
    'math': {
      'addition': [
        {'type': 'concept', 'emoji': '➕', 'title': 'Addition', 'body': 'Addition means putting things TOGETHER.\n\n🍎🍎 + 🍎 = 🍎🍎🍎\n2 + 1 = 3'},
        {'type': 'example', 'emoji': '💡', 'title': 'Let\'s Add!', 'body': '3 + 2 = 5 ✅\n4 + 4 = 8 ✅\n7 + 3 = 10 ✅'},
        {'type': 'concept', 'emoji': '🔄', 'title': 'Order Doesn\'t Matter', 'body': '3 + 5 = 8\n5 + 3 = 8\n\nSame answer! This is the Commutative Property.'},
        {'type': 'quiz', 'emoji': '🧠', 'title': 'Quick Check!', 'body': 'What is 6 + 4?', 'q': '6 + 4 = ?', 'opts': ['10', '9', '11'], 'a': '10'},
        {'type': 'summary', 'emoji': '⭐', 'title': 'Great!', 'body': '📌 Addition = combining numbers\n📌 Order doesn\'t change the sum\n📌 Practice makes perfect!'},
      ],
      'subtraction': [
        {'type': 'concept', 'emoji': '➖', 'title': 'Subtraction', 'body': 'Subtraction means TAKING AWAY.\n\n🍎🍎🍎 - 🍎 = 🍎🍎\n3 - 1 = 2'},
        {'type': 'example', 'emoji': '💡', 'title': 'Let\'s Subtract!', 'body': '5 - 2 = 3 ✅\n8 - 3 = 5 ✅\n10 - 4 = 6 ✅'},
        {'type': 'quiz', 'emoji': '🧠', 'title': 'Quick Check!', 'body': 'What is 9 - 5?', 'q': '9 - 5 = ?', 'opts': ['4', '3', '5'], 'a': '4'},
        {'type': 'summary', 'emoji': '⭐', 'title': 'Well Done!', 'body': '📌 Subtraction = taking away\n📌 The bigger number comes first\n📌 You\'re getting great at this!'},
      ],
    },
  };

  void _nextCard() {
    if (_currentCard < _cards.length - 1) {
      setState(() => _currentCard++);
    } else {
      setState(() => _completed = true);
    }
  }

  void _prevCard() {
    if (_currentCard > 0) setState(() => _currentCard--);
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return Scaffold(backgroundColor: AppColors.bgLight,
        body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text('Lesson Complete!', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900)),
            Text('${widget.subject} → ${widget.topic}', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Done', onPressed: () => context.pop()),
          ])))));
    }

    final card = _cards[_currentCard];
    final isQuiz = card['type'] == 'quiz';

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Header
          Row(children: [
            GestureDetector(onTap: () => context.pop(),
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.primary))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${widget.subject} / ${widget.topic}', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
              Text('Card ${_currentCard + 1} of ${_cards.length}', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800)),
            ])),
          ]),
          const SizedBox(height: 16),

          // Progress
          ClipRRect(borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: (_currentCard + 1) / _cards.length, minHeight: 8,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
          const SizedBox(height: 20),

          // Card
          Expanded(child: GestureDetector(
            onHorizontalDragEnd: (d) {
              if (d.velocity.pixelsPerSecond.dx < -100) _nextCard();
              if (d.velocity.pixelsPerSecond.dx > 100) _prevCard();
            },
            child: AnimatedSwitcher(
              duration: AppDurations.normal,
              child: Container(
                key: ValueKey(_currentCard),
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))]),
                child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text((card['emoji'] ?? '') as String, style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text((card['title'] ?? '') as String, style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                  const Divider(height: 24),
                  Text((card['body'] ?? '') as String, style: GoogleFonts.nunito(fontSize: 16, height: 1.8, color: AppColors.textDark)),

                  if (isQuiz) ...[
                    const SizedBox(height: 20),
                    ...((card['opts'] as List?)?.cast<String>() ?? <String>[]).map((opt) =>
                      Padding(padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            final correct = opt == (card['a'] as String?);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(correct ? '✅ Correct!' : '❌ Try: ${card['a'] ?? ''}'),
                              backgroundColor: correct ? AppColors.success : AppColors.error,
                              duration: const Duration(seconds: 1)));
                          },
                          child: Container(width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primary.withValues(alpha: 0.2))),
                            child: Text(opt, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)))))),
                  ],
                ])),
              ),
            ),
          )),
          const SizedBox(height: 16),

          // Navigation
          Row(children: [
            if (_currentCard > 0)
              Expanded(child: OutlinedButton(onPressed: _prevCard,
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: const BorderSide(color: AppColors.primary)),
                child: Text('← Back', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary))))
            else const Spacer(),
            const SizedBox(width: 12),
            Expanded(child: PrimaryButton(label: _currentCard < _cards.length - 1 ? 'Next →' : '✅ Complete', onPressed: _nextCard)),
          ]),

          const SizedBox(height: 8),
          Text('⬅️ swipe to navigate ➡️', style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textLight)),
        ]))),
    );
  }
}
