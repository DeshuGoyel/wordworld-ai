import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/exercise_bank.dart';
import '../../../core/services/xp_service.dart';
import '../../../shared/widgets/shared_widgets.dart';

/// Universal Exercise Player — plays exercises from ExerciseBank
class ExercisePlayerScreen extends ConsumerStatefulWidget {
  final String subject;
  final String topic;
  final int level;

  const ExercisePlayerScreen({super.key, required this.subject, required this.topic, this.level = 0});

  @override
  ConsumerState<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

class _ExercisePlayerScreenState extends ConsumerState<ExercisePlayerScreen> {
  late List<Exercise> _exercises;
  int _current = 0;
  int _score = 0;
  String? _selected;
  bool _answered = false;
  bool _showResults = false;
  late LevelTracker _tracker;

  @override
  void initState() {
    super.initState();
    _tracker = ref.read(levelTrackerProvider);
    if (widget.level > 0) {
      _exercises = ExerciseBank.forTopicLevel(widget.subject, widget.topic, widget.level);
    } else {
      _exercises = ExerciseBank.forSubject(widget.subject)
          .where((e) => e.topic == widget.topic)
          .toList();
    }
    if (_exercises.isEmpty) {
      _exercises = ExerciseBank.forSubject(widget.subject);
    }
    _exercises.shuffle();
    if (_exercises.length > 10) _exercises = _exercises.sublist(0, 10);
  }

  static const _subjectColors = {
    'grammar': AppColors.languageWorld,
    'math': AppColors.mathWorld,
    'evs': AppColors.evsWorld,
    'values': AppColors.valuesWorld,
  };

  Color get _color => _subjectColors[widget.subject] ?? AppColors.primary;

  void _answer(String option) {
    if (_answered) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selected = option;
      _answered = true;
      final correct = option == _exercises[_current].correctAnswer;
      if (correct) _score++;
      _tracker.recordCompletion(widget.subject, widget.topic, _exercises[_current].xpReward, correct);
      if (correct) {
        ref.read(xpServiceProvider).addXP(5);
      }
    });
  }

  void _next() {
    if (_current < _exercises.length - 1) {
      setState(() { _current++; _selected = null; _answered = false; });
    } else {
      setState(() => _showResults = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) return _buildResults();
    if (_exercises.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No exercises found', style: GoogleFonts.nunito(fontSize: 18))),
      );
    }

    final ex = _exercises[_current];
    final progress = (_current + 1) / _exercises.length;
    final isCorrect = _selected == ex.correctAnswer;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Top bar
            Row(children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: _color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.close_rounded, color: _color)),
              ),
              const SizedBox(width: 12),
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: progress, minHeight: 10,
                  backgroundColor: _color.withValues(alpha: 0.15), valueColor: AlwaysStoppedAnimation(_color)),
              )),
              const SizedBox(width: 12),
              Text('${_current + 1}/${_exercises.length}', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: _color)),
            ]),
            const SizedBox(height: 8),

            // Level & Score
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Text('Level ${ex.level}', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: _color)),
              ),
              const Spacer(),
              Text('⭐ $_score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
            ]),
            const SizedBox(height: 24),

            // Question card
            Expanded(
              child: Column(children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(children: [
                    Text(_topicEmoji(widget.topic), style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(ex.question, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark),
                      textAlign: TextAlign.center),
                    if (_answered && !isCorrect && ex.hint.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('💡 ${ex.hint}', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium, fontStyle: FontStyle.italic)),
                    ],
                  ]),
                ),
                const SizedBox(height: 20),

                // Options
                ...ex.options.map((opt) {
                  final isSelected = _selected == opt;
                  final isCorrectOpt = opt == ex.correctAnswer;
                  Color bgColor = Colors.white;
                  Color borderColor = AppColors.textLight.withValues(alpha: 0.2);
                  if (_answered) {
                    if (isCorrectOpt) { bgColor = AppColors.success.withValues(alpha: 0.1); borderColor = AppColors.success; }
                    else if (isSelected) { bgColor = AppColors.error.withValues(alpha: 0.1); borderColor = AppColors.error; }
                  } else if (isSelected) {
                    borderColor = _color;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => _answer(opt),
                      child: AnimatedContainer(
                        duration: AppDurations.fast,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: bgColor, borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(children: [
                          Expanded(child: Text(opt, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark))),
                          if (_answered && isCorrectOpt) const Icon(Icons.check_circle, color: AppColors.success),
                          if (_answered && isSelected && !isCorrectOpt) const Icon(Icons.cancel, color: AppColors.error),
                        ]),
                      ),
                    ),
                  );
                }),
              ]),
            ),

            // Next / Continue
            if (_answered)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: PrimaryButton(
                  label: _current < _exercises.length - 1 ? 'Next →' : 'See Results',
                  onPressed: _next,
                  color: isCorrect ? AppColors.success : _color,
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final pct = _exercises.isNotEmpty ? _score / _exercises.length : 0.0;
    final stars = pct >= 0.9 ? 3 : pct >= 0.6 ? 2 : pct >= 0.3 ? 1 : 0;
    final tp = _tracker.getProgress(widget.subject, widget.topic);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(stars >= 3 ? '🏆' : stars >= 2 ? '⭐' : stars >= 1 ? '👍' : '💪', style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(stars >= 3 ? 'Perfect!' : stars >= 2 ? 'Great Job!' : stars >= 1 ? 'Good Try!' : 'Keep Practicing!',
                style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textDark)),
              const SizedBox(height: 24),

              // Score card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    for (int i = 0; i < 3; i++)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.star_rounded, size: 36, color: i < stars ? AppColors.starActive : AppColors.starInactive)),
                  ]),
                  const SizedBox(height: 16),
                  Text('$_score / ${_exercises.length}', style: GoogleFonts.nunito(fontSize: 40, fontWeight: FontWeight.w900, color: _color)),
                  Text('correct answers', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  _resultStat('🎯', 'Accuracy', '${(pct * 100).toInt()}%'),
                  _resultStat('📊', 'Topic Level', '${tp.levelEmoji} ${tp.levelName} (Lv ${tp.currentLevel})'),
                  _resultStat('⭐', 'Total XP', '${tp.xpEarned}'),
                  _resultStat('🏅', 'Total Solved', '${tp.totalAttempts}'),
                ]),
              ),
              const SizedBox(height: 24),

              Row(children: [
                Expanded(child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    side: BorderSide(color: _color)),
                  child: Text('Back', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: _color)),
                )),
                const SizedBox(width: 12),
                Expanded(child: PrimaryButton(label: 'Play Again', onPressed: () {
                  setState(() { _current = 0; _score = 0; _selected = null; _answered = false; _showResults = false; _exercises.shuffle(); });
                }, color: _color)),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _resultStat(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Text(label, style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
        const Spacer(),
        Text(value, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textDark)),
      ]),
    );
  }

  String _topicEmoji(String topic) {
    const map = {
      'nouns': '📝', 'verbs': '🏃', 'adjectives': '🌈', 'sentences': '📜', 'advanced': '🎓',
      'counting': '🔢', 'addition': '➕', 'subtraction': '➖', 'shapes': '🔷', 'patterns': '🔄',
      'my_body': '🧍', 'my_family': '👨‍👩‍👧‍👦', 'nature': '🌿', 'safety': '🛡️',
      'emotions': '😊', 'life_skills': '🌟', 'social': '🤝',
    };
    return map[topic] ?? '📚';
  }
}
