import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

/// Daily challenge service — cross-subject challenges with 3× XP
class DailyChallengeService {
  DateTime? _lastChallengeDate;
  bool _completed = false;
  late DailyChallenge _todayChallenge;

  DailyChallengeService() {
    _generateChallenge();
  }

  DailyChallenge get todayChallenge => _todayChallenge;
  bool get isCompleted => _completed;

  /// Generate today's challenge
  void _generateChallenge() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (_lastChallengeDate != null && _lastChallengeDate == todayDate && _completed) return;

    final random = Random(todayDate.millisecondsSinceEpoch);
    final challenges = DailyChallenge.templates;
    _todayChallenge = challenges[random.nextInt(challenges.length)];
    _lastChallengeDate = todayDate;
    _completed = false;
  }

  /// Complete the daily challenge
  void complete() => _completed = true;

  /// Refresh for new day
  void checkNewDay() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    if (_lastChallengeDate != todayDate) _generateChallenge();
  }
}

/// Daily challenge template
class DailyChallenge {
  final String emoji;
  final String title;
  final String description;
  final String subject; // language, math, evs, values, mixed
  final int xpReward;

  const DailyChallenge({
    required this.emoji,
    required this.title,
    required this.description,
    required this.subject,
    this.xpReward = 30,
  });

  static const List<DailyChallenge> templates = [
    DailyChallenge(emoji: '🔤', title: 'Word Master', description: 'Complete 3 word lessons', subject: 'language'),
    DailyChallenge(emoji: '📝', title: 'Sentence Star', description: 'Build 2 sentences correctly', subject: 'language'),
    DailyChallenge(emoji: '🔢', title: 'Number Ninja', description: 'Count to 10 and match shapes', subject: 'math'),
    DailyChallenge(emoji: '🧩', title: 'Pattern Pro', description: 'Complete 2 pattern games', subject: 'math'),
    DailyChallenge(emoji: '🌿', title: 'Nature Explorer', description: 'Learn about 3 body parts', subject: 'evs'),
    DailyChallenge(emoji: '👨‍👩‍👧', title: 'Family Fun', description: 'Complete the family tree', subject: 'evs'),
    DailyChallenge(emoji: '🧘', title: 'Feelings Friend', description: 'Identify 3 emotions correctly', subject: 'values'),
    DailyChallenge(emoji: '🌟', title: 'Super Scholar', description: 'Complete 1 lesson in each subject', subject: 'mixed', xpReward: 50),
    DailyChallenge(emoji: '🎯', title: 'Perfect Score', description: 'Get 3 answers right in a row', subject: 'mixed'),
    DailyChallenge(emoji: '📖', title: 'Story Time', description: 'Create an AI story', subject: 'language'),
  ];
}

final dailyChallengeServiceProvider = Provider<DailyChallengeService>((ref) => DailyChallengeService());
