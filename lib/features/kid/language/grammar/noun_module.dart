import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';

/// NORA's Noun Module — common/proper, singular/plural, is-it-a-noun game
class NounModuleScreen extends StatefulWidget {
  const NounModuleScreen({super.key});
  @override
  State<NounModuleScreen> createState() => _NounModuleScreenState();
}

class _NounModuleScreenState extends State<NounModuleScreen> {
  int _step = 0;
  int _score = 0;

  final _lessons = [
    _NounLesson(
      title: 'What is a Noun?',
      explanation: 'A noun is a NAMING word.\nIt names people, places, animals, and things!',
      emoji: '🏷️',
      examples: [('🧒', 'Boy'), ('🏫', 'School'), ('🐕', 'Dog'), ('🍎', 'Apple')],
    ),
    _NounLesson(
      title: 'Common vs Proper',
      explanation: 'Common nouns are general: boy, city, dog\nProper nouns are special: Rahul, Delhi, Rex',
      emoji: '📋',
      examples: [('🧒', 'boy → Rahul'), ('🏙️', 'city → Mumbai'), ('🐕', 'dog → Rex'), ('📖', 'book → Harry Potter')],
    ),
    _NounLesson(
      title: 'One or Many?',
      explanation: 'Singular = ONE thing: cat, book\nPlural = MANY things: cats, books',
      emoji: '🔢',
      examples: [('🐱', 'cat → cats'), ('📚', 'book → books'), ('🌸', 'flower → flowers'), ('👦', 'boy → boys')],
    ),
  ];

  final _quizQuestions = [
    _NounQuiz(word: 'Apple', emoji: '🍎', isNoun: true),
    _NounQuiz(word: 'Run', emoji: '🏃', isNoun: false),
    _NounQuiz(word: 'School', emoji: '🏫', isNoun: true),
    _NounQuiz(word: 'Beautiful', emoji: '🎨', isNoun: false),
    _NounQuiz(word: 'Cat', emoji: '🐱', isNoun: true),
    _NounQuiz(word: 'Jump', emoji: '🦘', isNoun: false),
  ];

  @override
  Widget build(BuildContext context) {
    final totalSteps = _lessons.length + _quizQuestions.length;
    final progress = (_step + 1) / totalSteps;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.noraNoun.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, color: AppColors.noraNoun),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: DuoProgressBar(progress: progress, color: AppColors.noraNoun)),
                  const SizedBox(width: 12),
                  Text('🏷️ NORA', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.noraNoun)),
                ],
              ),
            ),

            Expanded(
              child: _step < _lessons.length
                  ? _buildLessonCard(_lessons[_step])
                  : _step < _lessons.length + _quizQuestions.length
                      ? _buildQuizCard(_quizQuestions[_step - _lessons.length])
                      : _buildScoreCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(_NounLesson lesson) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Text(lesson.emoji, style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(lesson.title, style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.noraNoun)),
          const SizedBox(height: 12),
          Text(lesson.explanation, textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 17, height: 1.5, color: AppColors.textDark)),
          const SizedBox(height: 24),
          // Examples
          Wrap(
            spacing: 10, runSpacing: 10,
            children: lesson.examples.map((e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.noraNoun.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.noraNoun.withValues(alpha: 0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(e.$1, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
                Text(e.$2, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.noraNoun)),
              ]),
            )).toList(),
          ),
          const Spacer(),
          PrimaryButton(label: 'Continue', onPressed: () => setState(() => _step++), color: AppColors.noraNoun),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuizCard(_NounQuiz quiz) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Text(quiz.emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('Is "${quiz.word}" a noun?', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('A noun names a person, place, animal, or thing',
              textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 15, color: AppColors.textMedium)),
          const Spacer(),
          Row(children: [
            Expanded(child: PrimaryButton(
              label: '✅ Yes!', color: AppColors.success,
              onPressed: () {
                _answer(quiz.isNoun);
              },
            )),
            const SizedBox(width: 12),
            Expanded(child: PrimaryButton(
              label: '❌ No!', color: AppColors.error,
              onPressed: () {
                _answer(!quiz.isNoun);
              },
            )),
          ]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _answer(bool correct) {
    if (correct) {
      _score++;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
    setState(() => _step++);
  }

  Widget _buildScoreCard() {
    final total = _quizQuestions.length;
    final stars = (_score / total * 3).round().clamp(0, 3);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Text(stars >= 2 ? '🎉' : '💪', style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(stars >= 2 ? 'Great job!' : 'Keep trying!',
              style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('$_score / $total correct', style: GoogleFonts.nunito(fontSize: 18, color: AppColors.textMedium)),
          const SizedBox(height: 16),
          StarRating(stars: stars, size: 36),
          const Spacer(),
          PrimaryButton(label: 'Continue', onPressed: () => context.pop(), color: AppColors.noraNoun),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _NounLesson {
  final String title, explanation, emoji;
  final List<(String, String)> examples;
  const _NounLesson({required this.title, required this.explanation, required this.emoji, required this.examples});
}

class _NounQuiz {
  final String word, emoji;
  final bool isNoun;
  const _NounQuiz({required this.word, required this.emoji, required this.isNoun});
}
