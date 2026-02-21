import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/exercise_bank.dart';
import '../../../core/services/freemium_service.dart';
import '../../../shared/widgets/shared_widgets.dart';

/// Exercise Hub — browse & play exercises by subject/topic/level
class ExerciseHubScreen extends ConsumerWidget {
  final String subject;
  const ExerciseHubScreen({super.key, required this.subject});

  static const _subjectData = {
    'grammar': {'name': 'Grammar', 'emoji': '📝', 'color': 'purple',
      'topics': {'nouns': 'Nouns', 'verbs': 'Verbs', 'adjectives': 'Adjectives', 'sentences': 'Sentences', 'advanced': 'Advanced'}},
    'math': {'name': 'Math', 'emoji': '🔢', 'color': 'blue',
      'topics': {'counting': 'Counting', 'addition': 'Addition', 'subtraction': 'Subtraction', 'shapes': 'Shapes', 'patterns': 'Patterns', 'advanced': 'Advanced'}},
    'evs': {'name': 'EVS', 'emoji': '🌿', 'color': 'green',
      'topics': {'my_body': 'My Body', 'my_family': 'My Family', 'nature': 'Nature', 'safety': 'Safety'}},
    'values': {'name': 'Values', 'emoji': '💝', 'color': 'orange',
      'topics': {'emotions': 'Emotions', 'life_skills': 'Life Skills', 'social': 'Social Values'}},
  };

  static const _colorMap = {'purple': AppColors.languageWorld, 'blue': AppColors.mathWorld, 'green': AppColors.evsWorld, 'orange': AppColors.valuesWorld};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = _subjectData[subject] ?? _subjectData['grammar']!;
    final topics = (data['topics'] as Map<String, String>?) ?? {};
    final color = _colorMap[data['color']] ?? AppColors.primary;
    final freemium = ref.read(freemiumServiceProvider);
    final tracker = ref.read(levelTrackerProvider);
    final totalDone = tracker.getTotalExercisesCompleted(subject);
    final totalCorrect = tracker.getTotalCorrect(subject);
    final subjectProgress = tracker.getSubjectProgress(subject);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Row(children: [
              GestureDetector(onTap: () => context.pop(),
                child: Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.arrow_back_rounded, color: color))),
              const SizedBox(width: 12),
              Text('${data['emoji']} ${data['name']} Exercises', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 20),

            // Overall stats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                _stat('✅', '$totalCorrect', 'Correct'),
                _divider(),
                _stat('📝', '$totalDone', 'Attempted'),
                _divider(),
                _stat('🎯', totalDone > 0 ? '${(totalCorrect / totalDone * 100).toInt()}%' : '0%', 'Accuracy'),
                _divider(),
                _stat('📚', '${ExerciseBank.countForSubject(subject)}', 'Total'),
              ]),
            ),
            const SizedBox(height: 24),

            Text('Choose a Topic', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            // Topic cards
            ...topics.entries.map((entry) {
              final tp = subjectProgress[entry.key];
              final level = tp?.currentLevel ?? 1;
              final levelEmoji = tp?.levelEmoji ?? '🌱';
              final levelName = tp?.levelName ?? 'Beginner';
              final exerciseCount = ExerciseBank.forSubject(subject).where((e) => e.topic == entry.key).length;
              final solved = tp?.totalAttempts ?? 0;
              final isLocked = !freemium.isPremium && entry.key == 'advanced';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    if (isLocked) {
                      context.push('/membership');
                      return;
                    }
                    context.push('/exercises/${subject}/${entry.key}');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppShadows.card,
                      border: Border.all(color: isLocked ? AppColors.lockedGrey : color.withOpacity(0.2)),
                    ),
                    child: Row(children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: isLocked ? Colors.grey.shade200 : color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                        child: Center(child: Text(isLocked ? '🔒' : _topicEmoji(entry.key), style: const TextStyle(fontSize: 24))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(entry.value, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700,
                            color: isLocked ? AppColors.lockedGrey : AppColors.textDark)),
                          if (isLocked) ...[
                            const SizedBox(width: 6),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.starActive, borderRadius: BorderRadius.circular(6)),
                              child: Text('PRO', style: GoogleFonts.nunito(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))),
                          ],
                        ]),
                        const SizedBox(height: 4),
                        Text('$levelEmoji $levelName • Lv $level • $solved/$exerciseCount solved',
                          style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
                        const SizedBox(height: 6),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: exerciseCount > 0 ? solved / exerciseCount : 0,
                            minHeight: 6,
                            backgroundColor: color.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation(isLocked ? AppColors.lockedGrey : color),
                          ),
                        ),
                      ])),
                      const SizedBox(width: 8),
                      Icon(Icons.play_circle_filled_rounded, size: 36, color: isLocked ? AppColors.lockedGrey : color),
                    ]),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            // Play All button
            PrimaryButton(label: '🎮 Play All ${data['name']} Exercises', onPressed: () {
              if (!freemium.isPremium) {
                context.push('/membership');
              } else {
                context.push('/exercises/$subject/all');
              }
            }, color: color),

            // 10 Level guide
            const SizedBox(height: 24),
            Text('📈 Level System', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (int i = 0; i < 10; i++)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: i < (subjectProgress.values.isNotEmpty ? subjectProgress.values.first.currentLevel : 1) ? color.withOpacity(0.15) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: i < (subjectProgress.values.isNotEmpty ? subjectProgress.values.first.currentLevel : 1) ? color : Colors.grey.shade300),
                  ),
                  child: Text('${TopicProgress(currentLevel: i + 1).levelEmoji} Lv ${i + 1}',
                    style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700)),
                ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _stat(String emoji, String value, String label) {
    return Expanded(child: Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 16)),
      Text(value, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
      Text(label, style: GoogleFonts.nunito(fontSize: 10, color: Colors.white70)),
    ]));
  }

  Widget _divider() => Container(width: 1, height: 40, color: Colors.white24);

  String _topicEmoji(String topic) {
    const map = {'nouns': '📝', 'verbs': '🏃', 'adjectives': '🌈', 'sentences': '📜', 'advanced': '🎓',
      'counting': '🔢', 'addition': '➕', 'subtraction': '➖', 'shapes': '🔷', 'patterns': '🔄',
      'my_body': '🧍', 'my_family': '👨‍👩‍👧‍👦', 'nature': '🌿', 'safety': '🛡️',
      'emotions': '😊', 'life_skills': '🌟', 'social': '🤝'};
    return map[topic] ?? '📚';
  }
}
