import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../data/seed/content_seed.dart';
import 'storage_service.dart';
import 'progress_service.dart';
import 'ai_service.dart';
import 'ai_provider.dart';

class TutorBrainService {
  final StorageService _storage;
  final ProgressService _progress;
  final AIService _ai;
  final _random = Random();

  TutorBrainService(this._storage, this._progress, this._ai);

  // ════════════════════════════════════════════════
  // SMART NAVIGATION (Word & Tab Suggestions)
  // ════════════════════════════════════════════════

  /// Suggest "Today's Word" based on incomplete progress + variety
  WordData suggestTodaysWord(String childId) {
    final allWords = ContentSeed.getAllActiveWords();
    final progressMap = _storage.getAllWordProgress(childId);

    // First: find words that haven't been started
    final unstarted = allWords.where((w) {
      final wp = progressMap[w.id];
      return wp == null || wp.totalStars == 0;
    }).toList();

    if (unstarted.isNotEmpty) {
      unstarted.shuffle();
      return unstarted.first;
    }

    // Second: find words that are in progress but not mastered
    final inProgress = allWords.where((w) {
      final wp = progressMap[w.id];
      return wp != null && !wp.isMastered;
    }).toList();

    if (inProgress.isNotEmpty) {
      inProgress.shuffle();
      return inProgress.first;
    }

    // All mastered: return random
    allWords.shuffle();
    return allWords.first;
  }

  /// Suggest the best next activity Tab based on time of day and weak skills
  Future<Map<String, dynamic>> suggestNextActivity(String childId) async {
    final hour = DateTime.now().hour;
    final skills = _progress.getSkillsBreakdown(childId);
    final mastered = _progress.getMasteredLettersCount(childId);

    // Time-based preferences
    String timeContext;
    if (hour < 10) {
      timeContext = 'morning — great for active learning (Think, Talk)';
    } else if (hour < 14) {
      timeContext = 'midday — great for creative activities (Draw, Story)';
    } else if (hour < 17) {
      timeContext = 'afternoon — great for practice (Write, Meet)';
    } else {
      timeContext = 'evening — great for gentle review (Story, Meet)';
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
    final nextLetterIndex = mastered.clamp(0, 25);
    final nextLetter = String.fromCharCode(65 + nextLetterIndex);

    // Mix: 70% weak areas, 30% new content
    final focusOnWeak = _random.nextDouble() < 0.7;
    final suggestedTab = focusOnWeak ? weakestTab : _bestTabForTime(hour);

    return {
      'letter': focusOnWeak ? _getWeakLetter(childId) : nextLetter,
      'tab': suggestedTab,
      'reason': focusOnWeak
          ? 'Practicing $weakestTab helps improve (score: ${(weakestScore * 100).round()}%).'
          : 'Great time for ${_bestTabForTime(hour)} — $timeContext.',
      'difficulty': _getDifficulty(weakestScore),
      'tabColor': _getThemeForTab(suggestedTab),
    };
  }

  /// Get weak areas as list of strings for dashboard display
  List<String> getWeakAreas(String childId) {
    final allProgress = _storage.getAllWordProgress(childId);
    if (allProgress.isEmpty) return [];

    int meetMissing = 0, thinkMissing = 0, talkMissing = 0;
    int writeMissing = 0, drawMissing = 0;
    int total = allProgress.length;

    for (final wp in allProgress.values) {
      if (!wp.meetCompleted) meetMissing++;
      if (wp.thinkStars < 2) thinkMissing++;
      if (!wp.talkCompleted) talkMissing++;
      if (!wp.writeCompleted) writeMissing++;
      if (!wp.drawCompleted) drawMissing++;
    }

    final areas = <String>[];
    if (meetMissing > total * 0.5) areas.add('Listening');
    if (thinkMissing > total * 0.5) areas.add('Thinking');
    if (talkMissing > total * 0.5) areas.add('Speaking');
    if (writeMissing > total * 0.5) areas.add('Writing');
    if (drawMissing > total * 0.5) areas.add('Drawing');
    return areas;
  }

  // ════════════════════════════════════════════════
  // AI-POWERED REPORTS AND ANALYSIS (Gemini)
  // ════════════════════════════════════════════════

  /// Generate a natural language progress report for parents
  Future<String> generateProgressReport(String childId, String childName, int childAge) async {
    final skills = _progress.getSkillsBreakdown(childId);
    final mastered = _progress.getMasteredLettersCount(childId);
    final totalStars = _progress.getTotalStars(childId);

    // Convert skills map to readable string
    final skillsStr = skills.entries.map((e) => '${e.key}: ${(e.value * 100).round()}%').join(', ');

    return _ai.reason(
      'Write a warm, encouraging progress report for the parents of $childName (age $childAge).\n'
      'Data: $mastered/26 letters mastered, $totalStars total stars\n'
      'Skills Completion: $skillsStr\n\n'
      'Write 3-4 short paragraphs describing:\n'
      '1. Amazing achievements.\n'
      '2. Suggested areas to improve.\n'
      '3. One simple home activity the parent can do to help with the weakest skill.\n'
      'Keep the tone positive, concise, and supportive.',
      config: const AIConfig(temperature: 0.7, maxTokens: 400),
    );
  }

  /// Generate optimal next activities for a child as JSON
  Future<List<String>> getOptimalLearningPath(String childId, int count) async {
    final skills = _progress.getSkillsBreakdown(childId);
    final mastered = _progress.getMasteredLettersCount(childId);
    final totalStars = _progress.getTotalStars(childId);
    final skillsStr = skills.entries.map((e) => '${e.key}=${e.value.toStringAsFixed(2)}').join(', ');

    final result = await _ai.reason(
      'A child (ID: $childId) learning the alphabet has:\n'
      '- Mastered $mastered/26 letters\n'
      '- Total stars: $totalStars\n'
      '- Skills: $skillsStr\n\n'
      'Recommend the next $count activities as a strict JSON array of objects exactly like this example:\n'
      '[{"letter": "A", "word": "Apple", "tab": "write", "reason": "Needs practice"}]\n'
      'Focus on weak areas, mix in mastered content for confidence, and introduce new letters gradually.',
      config: const AIConfig(temperature: 0.5, maxTokens: 400),
    );

    try {
      final list = jsonDecode(result) as List;
      return list.map((item) => '${item['letter']}: ${item['word']} (${item['tab']})').toList();
    } catch (_) {
      // Fallback
      return ['Practice your weakest skills!'];
    }
  }

  /// Calibrate difficulty dynamically based on AI Assessment
  Future<Map<String, dynamic>> calibrateDifficulty(String childId, String tabName) async {
    final skills = _progress.getSkillsBreakdown(childId);
    final score = skills[tabName.toLowerCase()] ?? 0.5;

    final result = await _ai.reason(
      'A child has skill level $score in "$tabName" (0.0-1.0 scale).\n'
      'Current difficulty: normal.\n'
      'Recommend difficulty adjustment.\n'
      'Reply as strict JSON: {"difficulty": "easy|normal|hard", "adjustments": "specific change description", "reason": "why"}',
      config: const AIConfig(temperature: 0.3, maxTokens: 150),
    );

    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (_) {
      return {'difficulty': 'normal', 'adjustments': 'No changes needed', 'reason': 'Fallback to default'};
    }
  }

  // ════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ════════════════════════════════════════════════

  String _bestTabForTime(int hour) {
    if (hour < 10) return 'think'; // Active morning
    if (hour < 14) return 'draw';  // Creative midday
    if (hour < 17) return 'write'; // Practice afternoon
    return 'story'; // Gentle evening
  }

  String _getThemeForTab(String tab) {
    switch(tab.toLowerCase()) {
      case 'meet': return '0xFFFF6B6B'; // red
      case 'think': return '0xFF6C5CE7'; // purple
      case 'talk': return '0xFF00D2D3'; // teal
      case 'write': return '0xFF1DD1A1'; // green
      case 'draw': return '0xFFFFA502'; // orange
      case 'story': return '0xFFFF9FF3'; // pink
      default: return '0xFF6C5CE7';
    }
  }

  String _getWeakLetter(String childId) {
    for (int i = 0; i < 26; i++) {
        final letter = String.fromCharCode(65 + i);
        if (!_progress.isLetterMastered(childId, letter)) {
          return letter;
        }
    }
    return 'A'; // Default to A for review if all mastered
  }

  String _getDifficulty(double skillScore) {
    if (skillScore < 0.3) return 'easy';
    if (skillScore > 0.8) return 'hard';
    return 'normal';
  }
}
