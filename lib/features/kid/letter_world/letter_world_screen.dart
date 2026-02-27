import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/progress_service.dart';
import '../../../data/seed/content_seed.dart';
import '../../../providers/app_providers.dart';
import '../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/widgets/tappable.dart';

class LetterWorldScreen extends ConsumerWidget {
  final String letter;
  const LetterWorldScreen({super.key, required this.letter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final letterData = ContentSeed.getAllLetters().firstWhere((l) => l.letter == letter);
    final child = ref.watch(activeChildProvider);
    final progressService = ref.read(progressServiceProvider);
    
    final letterColor = AppColors.letterColors[letter] ?? AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Tappable(
                onTap: () => context.pop(),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_rounded, size: 20),
                ),
              ),
              const Spacer(),
              Text('Letter World', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: letterColor, fontFamily: 'Nunito')),
              const Spacer(),
              const SizedBox(width: 40),
            ]),
          ),

          // Big Letter Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [letterColor, letterColor.withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: letterColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(children: [
              Text(letter, style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Nunito')),
              const SizedBox(height: 8),
              Tappable(
                onTap: () { tts.speakLetter(letter); tts.speakPhonetic(letter); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.volume_up_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text('${letterData.phonetic} as in ${letterData.phoneticExample}',
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Nunito')),
                  ]),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 24),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(alignment: Alignment.centerLeft,
              child: Text('Words in ${letter}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Nunito')))),
          const SizedBox(height: 12),

          // Word cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: letterData.words.length,
              itemBuilder: (ctx, i) {
                final word = letterData.words[i];
                final wp = child != null ? progressService.getProgress(child.id, word.id) : null;
                final progress = wp != null ? wp.totalStars / wp.maxStars : 0.0;

                return Tappable(
                  onTap: () => context.push('/word/${word.id}'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: letterColor.withValues(alpha: 0.2), width: 2),
                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Row(children: [
                      ProgressRing(
                        progress: progress, size: 56, color: letterColor,
                        child: Text(word.emoji, style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(word.word, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: letterColor, fontFamily: 'Nunito')),
                        Text(word.wordHi, style: const TextStyle(fontSize: 14, color: AppColors.textMedium, fontFamily: 'Nunito')),
                        const SizedBox(height: 4),
                        StarRating(current: wp?.totalStars ?? 0, max: 7, size: 14),
                      ])),
                      if (wp?.isMastered ?? false)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text('✅', style: TextStyle(fontSize: 16)),
                        )
                      else
                        Icon(Icons.chevron_right_rounded, color: letterColor),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
