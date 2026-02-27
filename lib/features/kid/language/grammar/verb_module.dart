import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/widgets/tappable.dart';

/// VERA's Verb Module — action words, tenses, subject-verb agreement
class VerbModuleScreen extends StatefulWidget {
  const VerbModuleScreen({super.key});
  @override
  State<VerbModuleScreen> createState() => _VerbModuleScreenState();
}

class _VerbModuleScreenState extends State<VerbModuleScreen> {
  int _step = 0;
  int _score = 0;

  final _lessons = [
    _VerbLesson(
      title: 'What is a Verb?',
      explanation: 'A verb is an ACTION word!\nIt tells what someone DOES.',
      emoji: '🏃',
      examples: [('🏃', 'Run'), ('🍽️', 'Eat'), ('😴', 'Sleep'), ('🎮', 'Play')],
    ),
    _VerbLesson(
      title: 'Past, Present, Future',
      explanation: 'Verbs change with TIME!\nran (past) → run (now) → will run (future)',
      emoji: '⏰',
      examples: [('⬅️', 'walked'), ('⏺️', 'walk'), ('➡️', 'will walk'), ('🔄', 'walking')],
    ),
  ];

  final _fillBlanks = [
    _VerbFillBlank(before: 'The cat', after: 'the milk.', options: ['drinks', 'big', 'red', 'cat'], correct: 'drinks'),
    _VerbFillBlank(before: 'She', after: 'to school every day.', options: ['goes', 'beautiful', 'school', 'the'], correct: 'goes'),
    _VerbFillBlank(before: 'We', after: 'football in the park.', options: ['play', 'happy', 'park', 'big'], correct: 'play'),
  ];

  @override
  Widget build(BuildContext context) {
    final totalSteps = _lessons.length + _fillBlanks.length + 1;
    final progress = (_step + 1) / totalSteps;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Tappable(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.veraVerb.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, color: AppColors.veraVerb),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: DuoProgressBar(progress: progress, color: AppColors.veraVerb)),
                const SizedBox(width: 12),
                Text('🏃 VERA', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.veraVerb)),
              ]),
            ),
            Expanded(
              child: _step < _lessons.length
                  ? _buildLesson(_lessons[_step])
                  : _step < _lessons.length + _fillBlanks.length
                      ? _buildFillBlank(_fillBlanks[_step - _lessons.length])
                      : _buildScore(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLesson(_VerbLesson lesson) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const Spacer(),
        Text(lesson.emoji, style: const TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text(lesson.title, style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.veraVerb)),
        const SizedBox(height: 12),
        Text(lesson.explanation, textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 17, height: 1.5)),
        const SizedBox(height: 24),
        Wrap(spacing: 10, runSpacing: 10, children: lesson.examples.map((e) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: AppColors.veraVerb.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.veraVerb.withValues(alpha: 0.3))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(e.$1, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(e.$2, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.veraVerb)),
          ]),
        )).toList()),
        const Spacer(),
        PrimaryButton(label: 'Continue', onPressed: () => setState(() => _step++), color: AppColors.veraVerb),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _buildFillBlank(_VerbFillBlank fb) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Text('Fill in the verb!', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.veraVerb)),
        const SizedBox(height: 24),
        FillBlankWidget(
          sentenceBefore: fb.before,
          sentenceAfter: fb.after,
          options: fb.options,
          correctAnswer: fb.correct,
          onAnswer: (correct) {
            if (correct) _score++;
            Future.delayed(const Duration(seconds: 1), () { if (mounted) setState(() => _step++); });
          },
        ),
        const Spacer(),
      ]),
    );
  }

  Widget _buildScore() {
    final total = _fillBlanks.length;
    final stars = (_score / total * 3).round().clamp(0, 3);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const Spacer(),
        Text(stars >= 2 ? '🎉' : '💪', style: const TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text('$_score / $total correct!', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        StarRating(stars: stars, size: 36),
        const Spacer(),
        PrimaryButton(label: 'Continue', onPressed: () => context.pop(), color: AppColors.veraVerb),
        const SizedBox(height: 16),
      ]),
    );
  }
}

class _VerbLesson {
  final String title, explanation, emoji;
  final List<(String, String)> examples;
  const _VerbLesson({required this.title, required this.explanation, required this.emoji, required this.examples});
}

class _VerbFillBlank {
  final String before, after, correct;
  final List<String> options;
  const _VerbFillBlank({required this.before, required this.after, required this.options, required this.correct});
}
