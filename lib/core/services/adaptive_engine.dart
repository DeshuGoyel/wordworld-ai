import 'dart:math';
import 'ai_service.dart';
import 'ai_provider.dart';
import 'storage_service.dart';
import 'progress_service.dart';

/// Adaptive Engine — cross-cutting intelligence layer.
/// Smart content selection, difficulty adjustment, session optimization,
/// predictive preloading, and personalized experience.
class AdaptiveEngine {
  final AIService _ai;
  final StorageService _storage;
  final ProgressService _progress;
  final _random = Random();

  AdaptiveEngine(this._ai, this._storage, this._progress);

  /// Get the best activity for this moment
  /// Considers: time of day, recent activity, skill gaps, mood estimation
  Future<Map<String, dynamic>> suggestNextActivity(String childId) async {
    final hour = DateTime.now().hour;
    final skills = _progress.getSkillsBreakdown(childId);
    final mastered = _progress.getMasteredLettersCount(childId);

    // Time-based preferences
    String timeContext;
    if (hour < 10) {
      timeContext = 'morning — good for active learning (Think, Talk)';
    } else if (hour < 14) {
      timeContext = 'midday — good for creative activities (Draw, Story)';
    } else if (hour < 17) {
      timeContext = 'afternoon — good for practice (Write, Meet)';
    } else {
      timeContext = 'evening — good for gentle review (Story, Meet)';
    }

    // Find weakest skill
    String weakestTab = 'meet';
    double weakestScore = 1.0;
    skills.forEach((tab, score) {
      if (score < weakestScore) {
        weakestScore = score;
        weakestTab = tab;
      }
    });

    // Determine next letter to learn
    final nextLetterIndex = mastered.clamp(0, 25) as int;
    final nextLetter = String.fromCharCode(65 + nextLetterIndex);

    // Mix: 70% weak areas, 30% new content
    final focusOnWeak = _random.nextDouble() < 0.7;

    return {
      'letter': focusOnWeak ? _getWeakLetter(childId) : nextLetter,
      'tab': focusOnWeak ? weakestTab : _bestTabForTime(hour),
      'reason': focusOnWeak
        ? 'Practicing $weakestTab to improve (score: ${(weakestScore * 100).round()}%).'
        : 'Great time for ${_bestTabForTime(hour)} — $timeContext.',
      'difficulty': _getDifficulty(weakestScore),
    };
  }

  /// Estimate if the child should take a break
  bool shouldTakeBreak(String childId, Duration sessionDuration, int activitiesCompleted) {
    // Young children: break every 10-15 minutes or 5 activities
    if (sessionDuration.inMinutes >= 15) return true;
    if (activitiesCompleted >= 5) return true;
    return false;
  }

  /// Get break suggestion
  String getBreakSuggestion() {
    final suggestions = [
      '🌟 Great work! Time for a little break. How about stretching like a cat?',
      '🎉 You\'re amazing! Let\'s rest our eyes. Look out the window!',
      '💪 Super learning! Take a break and drink some water.',
      '🌈 Awesome job! Let\'s dance for 30 seconds!',
      '🧸 Learning break! Give your favorite toy a big hug!',
    ];
    return suggestions[_random.nextInt(suggestions.length)];
  }

  /// Get content to preload based on predicted next activities
  List<Map<String, String>> getPreloadList(String childId) {
    final mastered = _progress.getMasteredLettersCount(childId);
    final nextLetters = <Map<String, String>>[];

    // Preload next 2 unmastered letters
    for (int i = mastered; i < (mastered + 2).clamp(0, 26); i++) {
      final letter = String.fromCharCode(65 + i);
      nextLetters.add({'letter': letter, 'type': 'images_and_audio'});
    }

    return nextLetters;
  }

  /// Adjust difficulty dynamically based on success rate
  String _getDifficulty(double skillScore) {
    if (skillScore < 0.3) return 'easy';
    if (skillScore > 0.8) return 'hard';
    return 'normal';
  }

  /// Get the best tab for the time of day
  String _bestTabForTime(int hour) {
    if (hour < 10) return 'think'; // Active morning
    if (hour < 14) return 'draw';  // Creative midday
    if (hour < 17) return 'write'; // Practice afternoon
    return 'story'; // Gentle evening
  }

  /// Find a letter the child struggles with
  String _getWeakLetter(String childId) {
    for (int i = 0; i < 26; i++) {
      final letter = String.fromCharCode(65 + i);
      if (!_progress.isLetterMastered(childId, letter)) {
        return letter;
      }
    }
    return 'A'; // All mastered, default to A for review
  }

  /// Generate smart notification text for parents
  Future<String> getParentNotification(String childId, String childName) async {
    final skills = _progress.getSkillsBreakdown(childId);
    final mastered = _progress.getMasteredLettersCount(childId);

    // Find what hasn't been practiced recently
    String weakest = 'all areas';
    double lowest = 1.0;
    skills.forEach((skill, score) {
      if (score < lowest) {
        lowest = score;
        weakest = skill;
      }
    });

    if (lowest < 0.3) {
      return '📝 $childName hasn\'t practiced $weakest much this week. A 5-minute session could help!';
    }
    if (mastered > 0 && mastered % 5 == 0) {
      return '🎉 Amazing! $childName has mastered $mastered letters! Keep the streak going!';
    }
    return '📚 $childName is making great progress! Encourage them to try the ${_bestTabForTime(DateTime.now().hour)} tab today.';
  }
}
