import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/xp_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';

/// Sight Words Screen — Dolch word levels with flashcard + quiz modes
class SightWordsScreen extends ConsumerStatefulWidget {
  const SightWordsScreen({super.key});
  @override
  ConsumerState<SightWordsScreen> createState() => _SightWordsScreenState();
}

class _SightWordsScreenState extends ConsumerState<SightWordsScreen> {
  int _level = 0; // 0 = Pre-K, 1 = K, 2 = Grade 1
  bool _quizMode = false;
  int _currentCard = 0;
  int _quizQ = 0;
  int _quizScore = 0;
  String? _selected;
  bool _answered = false;

  static const _levelNames = ['Pre-K (Age 3-4)', 'Kindergarten (Age 5)', 'Grade 1 (Age 6-7)'];
  static const _levelEmojis = ['🌱', '🌿', '🌳'];

  // Dolch Sight Words by level
  static const _words = <List<String>>[
    ['a', 'and', 'away', 'big', 'blue', 'can', 'come', 'down', 'find', 'for',
     'funny', 'go', 'help', 'here', 'I', 'in', 'is', 'it', 'jump', 'little',
     'look', 'make', 'me', 'my', 'not', 'one', 'play', 'red', 'run', 'said',
     'see', 'the', 'three', 'to', 'two', 'up', 'we', 'where', 'yellow', 'you'],
    ['all', 'am', 'are', 'at', 'ate', 'be', 'black', 'brown', 'but', 'came',
     'did', 'do', 'eat', 'four', 'get', 'good', 'have', 'he', 'into', 'like',
     'must', 'new', 'no', 'now', 'on', 'our', 'out', 'please', 'pretty', 'ran',
     'ride', 'saw', 'say', 'she', 'so', 'soon', 'that', 'there', 'they', 'this'],
    ['after', 'again', 'an', 'any', 'ask', 'as', 'by', 'could', 'every', 'fly',
     'from', 'give', 'going', 'had', 'has', 'her', 'him', 'his', 'how', 'just',
     'know', 'let', 'live', 'may', 'of', 'old', 'once', 'open', 'over', 'put',
     'round', 'some', 'stop', 'take', 'thank', 'them', 'then', 'think', 'walk', 'were'],
  ];

  // Quiz: "Which word is ___?"
  List<Map<String, dynamic>> get _quizQuestions {
    final words = _words[_level];
    final qs = <Map<String, dynamic>>[];
    for (int i = 0; i < 10 && i < words.length; i++) {
      final correct = words[i];
      final others = (List<String>.from(words)..remove(correct)..shuffle()).take(2).toList();
      qs.add({'q': 'Find the word: "$correct"', 'opts': ([correct, ...others]..shuffle()), 'ans': correct});
    }
    return qs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Header
            Row(children: [
              GestureDetector(onTap: () => context.pop(),
                child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.accent2.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.accent2))),
              const SizedBox(width: 12),
              Text('📖 Sight Words', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 16),

            // Level tabs
            Row(children: List.generate(3, (i) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() { _level = i; _currentCard = 0; _quizMode = false; _quizQ = 0; _quizScore = 0; _selected = null; _answered = false; }),
                child: AnimatedContainer(duration: AppDurations.fast,
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _level == i ? AppColors.accent2 : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _level == i ? AppColors.accent2 : AppColors.textLight.withValues(alpha: 0.3))),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(_levelEmojis[i], style: const TextStyle(fontSize: 16)),
                    Text(_levelNames[i], style: GoogleFonts.nunito(fontSize: 9, fontWeight: FontWeight.w700,
                      color: _level == i ? Colors.white : AppColors.textMedium)),
                  ])),
              ),
            ))),
            const SizedBox(height: 16),

            // Mode toggle
            Row(children: [
              Expanded(child: GestureDetector(onTap: () => setState(() => _quizMode = false),
                child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: !_quizMode ? AppColors.accent2 : Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text('📚 Flashcards', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700,
                    color: !_quizMode ? Colors.white : AppColors.textMedium)))))),
              const SizedBox(width: 8),
              Expanded(child: GestureDetector(onTap: () => setState(() { _quizMode = true; _quizQ = 0; _quizScore = 0; _selected = null; _answered = false; }),
                child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: _quizMode ? AppColors.accent2 : Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text('🎯 Quiz', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700,
                    color: _quizMode ? Colors.white : AppColors.textMedium)))))),
            ]),
            const SizedBox(height: 16),

            Expanded(child: _quizMode ? _buildQuiz() : _buildFlashcards()),
          ]),
        ),
      ),
    );
  }

  Widget _buildFlashcards() {
    final words = _words[_level];
    return Column(children: [
      // Big word card
      Expanded(child: GestureDetector(
        onHorizontalDragEnd: (d) {
          if (d.velocity.pixelsPerSecond.dx < 0 && _currentCard < words.length - 1) {
            setState(() => _currentCard++);
          } else if (d.velocity.pixelsPerSecond.dx > 0 && _currentCard > 0) {
            setState(() => _currentCard--);
          }
        },
        child: AnimatedSwitcher(
          duration: AppDurations.fast,
          child: Container(
            key: ValueKey(_currentCard),
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.accent2, AppColors.accent2.withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(32),
              boxShadow: AppShadows.card),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${_currentCard + 1}/${words.length}', style: GoogleFonts.nunito(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 16),
              Text(words[_currentCard], style: GoogleFonts.nunito(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
              const SizedBox(height: 16),
              Text('⬅️ swipe ➡️', style: GoogleFonts.nunito(fontSize: 12, color: Colors.white54)),
            ]),
          ),
        ),
      )),
      const SizedBox(height: 16),
      // Word grid
      SizedBox(height: 100, child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 6, crossAxisSpacing: 6, childAspectRatio: 0.5),
        itemCount: words.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => setState(() => _currentCard = i),
          child: Container(
            decoration: BoxDecoration(
              color: _currentCard == i ? AppColors.accent2 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _currentCard == i ? AppColors.accent2 : AppColors.textLight.withValues(alpha: 0.2))),
            child: Center(child: Text(words[i], style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700,
              color: _currentCard == i ? Colors.white : AppColors.textDark))),
          ),
        ),
      )),
    ]);
  }

  Widget _buildQuiz() {
    final qs = _quizQuestions;
    if (_quizQ >= qs.length) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🎉', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 12),
        Text('$_quizScore / ${qs.length} correct!', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Play Again', onPressed: () => setState(() { _quizQ = 0; _quizScore = 0; _selected = null; _answered = false; })),
      ]));
    }

    final q = qs[_quizQ];
    final isCorrect = _selected == q['ans'];

    return Column(children: [
      ClipRRect(borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(value: (_quizQ + 1) / qs.length, minHeight: 8,
          backgroundColor: AppColors.accent2.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation(AppColors.accent2))),
      const SizedBox(height: 16),
      Container(
        width: double.infinity, padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
        child: Text(q['q'] as String, style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800), textAlign: TextAlign.center)),
      const SizedBox(height: 16),
      ...(q['opts'] as List<String>).map((opt) {
        final isThis = _selected == opt;
        final isAns = opt == q['ans'];
        Color bg = Colors.white;
        Color border = AppColors.textLight.withValues(alpha: 0.2);
        if (_answered) {
          if (isAns) { bg = AppColors.success.withValues(alpha: 0.1); border = AppColors.success; }
          else if (isThis) { bg = AppColors.error.withValues(alpha: 0.1); border = AppColors.error; }
        }
        return Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(onTap: () {
            if (_answered) return;
            HapticFeedback.lightImpact();
            setState(() { _selected = opt; _answered = true;
              if (opt == q['ans']) { _quizScore++; ref.read(xpServiceProvider).addXP(5); }
            });
          },
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 2)),
            child: Text(opt, style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: 2)))));
      }),
      const Spacer(),
      if (_answered)
        PrimaryButton(label: _quizQ < qs.length - 1 ? 'Next →' : 'See Results', onPressed: () {
          setState(() { _quizQ++; _selected = null; _answered = false; });
        }, color: isCorrect ? AppColors.success : AppColors.accent2),
    ]);
  }
}
