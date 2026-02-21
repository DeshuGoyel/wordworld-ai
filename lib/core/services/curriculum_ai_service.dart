import 'dart:convert';
import 'ai_service.dart';
import 'ai_provider.dart';
import 'storage_service.dart';
import 'progress_service.dart';

/// Curriculum AI service — uses advanced reasoning for deep analysis.
/// Learning path optimization, weakness analysis, curriculum generation, reports.
class CurriculumAIService {
  final AIService _ai;
  final StorageService _storage;
  final ProgressService _progress;

  CurriculumAIService(this._ai, this._storage, this._progress);

  /// Generate optimal next activities for a child
  Future<List<String>> getOptimalLearningPath(String childId, int count) async {
    final skills = _progress.getSkillsBreakdown(childId);
    final mastered = _progress.getMasteredLettersCount(childId);
    final totalStars = _progress.getTotalStars(childId);

    final result = await _ai.reason(
      'A child (ID: $childId) learning the alphabet has:\n'
      '- Mastered $mastered/26 letters\n'
      '- Total stars: $totalStars\n'
      '- Skills: listen=${skills['listen']}, think=${skills['think']}, '
      'speak=${skills['speak']}, write=${skills['write']}, draw=${skills['draw']}\n\n'
      'Recommend the next $count activities as a JSON array of objects:\n'
      '[{"letter": "A", "word": "Apple", "tab": "write", "reason": "..."}]\n'
      'Focus on weak areas, mix in mastered content for confidence, and introduce new letters gradually.',
      config: const AIConfig(temperature: 0.5, maxTokens: 500),
    );

    try {
      final list = jsonDecode(result) as List;
      return list.map((item) => '${item['letter']}: ${item['word']} (${item['tab']})').toList();
    } catch (_) {
      return ['Practice your weakest skills!'];
    }
  }

  /// Detailed weakness analysis with remediation plan
  Future<Map<String, dynamic>> getWeaknessAnalysis(String childId) async {
    final skills = _progress.getSkillsBreakdown(childId);

    final result = await _ai.reason(
      'Analyze this child\'s learning data and provide a remediation plan:\n'
      'Skills breakdown: $skills\n\n'
      'Reply as JSON: {"weakAreas": [{"skill": "...", "score": 0.0, "plan": "..."}], '
      '"strengths": ["..."], "overallLevel": "beginner|intermediate|advanced", '
      '"parentTip": "one actionable tip for parents"}',
      config: const AIConfig(temperature: 0.3, maxTokens: 500),
    );

    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (_) {
      return {
        'weakAreas': [],
        'strengths': ['Showing great enthusiasm!'],
        'overallLevel': 'beginner',
        'parentTip': 'Keep encouraging regular practice!',
      };
    }
  }

  /// Generate a teacher's weekly lesson plan
  Future<String> generateLessonPlan(
    List<String> studentNames,
    String currentLetters,
    String goals,
    int weekNumber,
  ) async {
    return _ai.reason(
      'Create a week $weekNumber lesson plan for a pre-school class of ${studentNames.length} students.\n'
      'Currently teaching letters: $currentLetters\n'
      'Teacher\'s goals: $goals\n\n'
      'Include: daily activities (30 min each), group activities, individual practice, '
      'materials needed, and assessment criteria. Format as a readable markdown plan.',
      config: const AIConfig(temperature: 0.5, maxTokens: 1500),
    );
  }

  /// Generate a natural language progress report for parents
  Future<String> generateProgressReport(String childId, String childName, int childAge) async {
    final skills = _progress.getSkillsBreakdown(childId);
    final mastered = _progress.getMasteredLettersCount(childId);
    final totalStars = _progress.getTotalStars(childId);

    return _ai.reason(
      'Write a warm, encouraging progress report for the parents of $childName (age $childAge).\n'
      'Data: $mastered/26 letters mastered, $totalStars total stars\n'
      'Skills: $skills\n\n'
      'Write 3-4 short paragraphs: achievements, areas to improve, suggested home activities, '
      'and an encouraging closing. Keep the tone positive and supportive.',
      config: const AIConfig(temperature: 0.7, maxTokens: 600),
    );
  }

  /// Calibrate difficulty for a specific child and tab
  Future<Map<String, dynamic>> calibrateDifficulty(String childId, String tabName) async {
    final skills = _progress.getSkillsBreakdown(childId);

    final result = await _ai.reason(
      'A child has skill level ${skills[tabName.toLowerCase()] ?? 0.5} in "$tabName" (0.0-1.0 scale).\n'
      'Current difficulty: normal.\n'
      'Recommend difficulty adjustment.\n'
      'Reply as JSON: {"difficulty": "easy|normal|hard", "adjustments": "specific change description", '
      '"reason": "why"}',
      config: const AIConfig(temperature: 0.3, maxTokens: 200),
    );

    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (_) {
      return {'difficulty': 'normal', 'adjustments': 'No changes needed', 'reason': 'Default'};
    }
  }
}
