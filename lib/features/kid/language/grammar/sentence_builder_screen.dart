import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';

/// FRED's Sentence Builder Screen — drag word blocks
class SentenceBuilderScreen extends StatefulWidget {
  const SentenceBuilderScreen({super.key});
  @override
  State<SentenceBuilderScreen> createState() => _SentenceBuilderScreenState();
}

class _SentenceBuilderScreenState extends State<SentenceBuilderScreen> {
  int _step = 0;
  int _score = 0;

  final _sentences = [
    _SentenceQ(prompt: 'Build: A bird can fly', words: ['A', 'bird', 'can', 'fly', '.']),
    _SentenceQ(prompt: 'Build: The cat drinks milk', words: ['The', 'cat', 'drinks', 'milk', '.']),
    _SentenceQ(prompt: 'Build: I like to play', words: ['I', 'like', 'to', 'play', '.']),
    _SentenceQ(prompt: 'Build: She reads a book', words: ['She', 'reads', 'a', 'book', '.']),
    _SentenceQ(prompt: 'Build: We go to school', words: ['We', 'go', 'to', 'school', '.']),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = (_step + 1) / (_sentences.length + 1);

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
                    decoration: BoxDecoration(color: AppColors.fredFull.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, color: AppColors.fredFull)),
                ),
                const SizedBox(width: 12),
                Expanded(child: DuoProgressBar(progress: progress, color: AppColors.fredFull)),
                const SizedBox(width: 12),
                Text('🏗️ FRED', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.fredFull)),
              ]),
            ),
            Expanded(
              child: _step < _sentences.length
                  ? _buildQuestion(_sentences[_step])
                  : _buildScore(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(_SentenceQ q) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('🏗️', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(q.prompt, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.fredFull)),
          const SizedBox(height: 8),
          Text('Tap words in the right order', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
          const SizedBox(height: 24),
          SentenceBuilderWidget(
            correctOrder: q.words,
            onComplete: (correct) {
              if (correct) _score++;
              Future.delayed(const Duration(milliseconds: 1200), () {
                if (mounted) setState(() => _step++);
              });
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildScore() {
    final total = _sentences.length;
    final stars = (_score / total * 3).round().clamp(0, 3);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const Spacer(),
        Text(stars >= 2 ? '🎉' : '💪', style: const TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text('Sentence Master!', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('$_score / $total sentences built correctly', style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
        const SizedBox(height: 16),
        StarRating(stars: stars, size: 36),
        const Spacer(),
        PrimaryButton(label: 'Continue', onPressed: () => context.pop(), color: AppColors.fredFull),
        const SizedBox(height: 16),
      ]),
    );
  }
}

class _SentenceQ {
  final String prompt;
  final List<String> words;
  const _SentenceQ({required this.prompt, required this.words});
}
