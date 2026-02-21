import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';

/// Fill blank screen for grammar exercises
class FillBlankScreen extends StatefulWidget {
  const FillBlankScreen({super.key});
  @override
  State<FillBlankScreen> createState() => _FillBlankScreenState();
}

class _FillBlankScreenState extends State<FillBlankScreen> {
  int _step = 0;
  int _score = 0;

  final _questions = [
    _FBQuestion(before: 'The dog', after: 'in the garden.', options: ['runs', 'big', 'the', 'a'], correct: 'runs', hint: 'What does the dog do?'),
    _FBQuestion(before: 'She is a', after: 'girl.', options: ['tall', 'runs', 'the', 'go'], correct: 'tall', hint: 'Which word describes the girl?'),
    _FBQuestion(before: 'I', after: 'to school every day.', options: ['go', 'big', 'red', 'the'], correct: 'go', hint: 'What do you do?'),
    _FBQuestion(before: 'The ball is', after: 'the table.', options: ['on', 'eat', 'big', 'run'], correct: 'on', hint: 'Where is the ball?'),
    _FBQuestion(before: 'They', after: 'football after school.', options: ['play', 'happy', 'book', 'red'], correct: 'play', hint: 'What do they do?'),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = (_step + 1) / (_questions.length + 1);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.languageWorld.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, color: AppColors.languageWorld)),
                ),
                const SizedBox(width: 12),
                Expanded(child: DuoProgressBar(progress: progress, color: AppColors.languageWorld)),
                const SizedBox(width: 12),
                Text('📝', style: const TextStyle(fontSize: 20)),
              ]),
            ),
            Expanded(
              child: _step < _questions.length
                  ? _buildQuestion(_questions[_step])
                  : _buildScore(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(_FBQuestion q) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Fill in the blank!', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.languageWorld)),
          const SizedBox(height: 8),
          Text(q.hint, style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
          const SizedBox(height: 24),
          FillBlankWidget(
            sentenceBefore: q.before,
            sentenceAfter: q.after,
            options: q.options,
            correctAnswer: q.correct,
            onAnswer: (correct) {
              if (correct) _score++;
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) setState(() => _step++);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScore() {
    final total = _questions.length;
    final stars = (_score / total * 3).round().clamp(0, 3);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const Spacer(),
        Text(stars >= 2 ? '🎉' : '💪', style: const TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text('Grammar Star!', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('$_score / $total correct!', style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
        const SizedBox(height: 16),
        StarRating(stars: stars, size: 36),
        const Spacer(),
        PrimaryButton(label: 'Continue', onPressed: () => context.pop(), color: AppColors.languageWorld),
        const SizedBox(height: 16),
      ]),
    );
  }
}

class _FBQuestion {
  final String before, after, correct, hint;
  final List<String> options;
  const _FBQuestion({required this.before, required this.after, required this.options, required this.correct, required this.hint});
}
