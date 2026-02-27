import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/widgets/tappable.dart';

/// ADA's Adjective Module — describing words, degrees of comparison
class AdjectiveModuleScreen extends StatefulWidget {
  const AdjectiveModuleScreen({super.key});
  @override
  State<AdjectiveModuleScreen> createState() => _AdjectiveModuleScreenState();
}

class _AdjectiveModuleScreenState extends State<AdjectiveModuleScreen> {
  int _step = 0;
  int _score = 0;

  final _lessons = [
    _AdjLesson(
      title: 'What is an Adjective?',
      explanation: 'An adjective DESCRIBES a noun.\nIt tells us more about people, animals, and things!',
      emoji: '🎨',
      examples: [('🔴', 'Red apple'), ('😊', 'Happy child'), ('📏', 'Tall tree'), ('🐰', 'Cute rabbit')],
    ),
    _AdjLesson(
      title: 'Comparing Things',
      explanation: 'Adjectives can compare!\nbig → bigger → biggest\ntall → taller → tallest',
      emoji: '📊',
      examples: [('📏', 'tall → taller'), ('🐘', 'big → bigger'), ('⚡', 'fast → faster'), ('😊', 'happy → happier')],
    ),
  ];

  final _sentences = [
    _AdjSentence(words: ['The', 'big', 'dog', 'runs', 'fast'], correct: ['The', 'big', 'dog', 'runs', 'fast']),
    _AdjSentence(words: ['She', 'has', 'a', 'red', 'ball'], correct: ['She', 'has', 'a', 'red', 'ball']),
  ];

  @override
  Widget build(BuildContext context) {
    final totalSteps = _lessons.length + _sentences.length + 1;
    final progress = (_step + 1) / totalSteps;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          Tappable(
            onTap: () => context.pop(),
            child: Container(width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.adaAdjective.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.close_rounded, color: AppColors.adaAdjective)),
          ),
          const SizedBox(width: 12),
          Expanded(child: DuoProgressBar(progress: progress, color: AppColors.adaAdjective)),
          const SizedBox(width: 12),
          Text('🎨 ADA', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.adaAdjective)),
        ])),
        Expanded(
          child: _step < _lessons.length
              ? _buildLesson(_lessons[_step])
              : _step < _lessons.length + _sentences.length
                  ? _buildSentenceBuilder(_sentences[_step - _lessons.length])
                  : _buildScore(),
        ),
      ])),
    );
  }

  Widget _buildLesson(_AdjLesson lesson) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const Spacer(),
      Text(lesson.emoji, style: const TextStyle(fontSize: 60)),
      const SizedBox(height: 16),
      Text(lesson.title, style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.adaAdjective)),
      const SizedBox(height: 12),
      Text(lesson.explanation, textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 17, height: 1.5)),
      const SizedBox(height: 24),
      Wrap(spacing: 10, runSpacing: 10, children: lesson.examples.map((e) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: AppColors.adaAdjective.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.adaAdjective.withValues(alpha: 0.3))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(e.$1, style: const TextStyle(fontSize: 20)), const SizedBox(width: 6),
          Text(e.$2, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.adaAdjective)),
        ]),
      )).toList()),
      const Spacer(),
      PrimaryButton(label: 'Continue', onPressed: () => setState(() => _step++), color: AppColors.adaAdjective),
      const SizedBox(height: 16),
    ]));
  }

  Widget _buildSentenceBuilder(_AdjSentence sentence) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      Text('Build the sentence!', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.adaAdjective)),
      const SizedBox(height: 8),
      Text('Put the words in the right order', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
      const SizedBox(height: 24),
      SentenceBuilderWidget(
        correctOrder: sentence.correct,
        onComplete: (correct) {
          if (correct) _score++;
          Future.delayed(const Duration(seconds: 1), () { if (mounted) setState(() => _step++); });
        },
      ),
      const Spacer(),
    ]));
  }

  Widget _buildScore() {
    final total = _sentences.length;
    final stars = (_score / total * 3).round().clamp(0, 3);
    return Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const Spacer(),
      Text(stars >= 2 ? '🎉' : '💪', style: const TextStyle(fontSize: 60)),
      const SizedBox(height: 16),
      Text('$_score / $total correct!', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      StarRating(stars: stars, size: 36),
      const Spacer(),
      PrimaryButton(label: 'Continue', onPressed: () => context.pop(), color: AppColors.adaAdjective),
      const SizedBox(height: 16),
    ]));
  }
}

class _AdjLesson {
  final String title, explanation, emoji;
  final List<(String, String)> examples;
  const _AdjLesson({required this.title, required this.explanation, required this.emoji, required this.examples});
}

class _AdjSentence {
  final List<String> words, correct;
  const _AdjSentence({required this.words, required this.correct});
}
