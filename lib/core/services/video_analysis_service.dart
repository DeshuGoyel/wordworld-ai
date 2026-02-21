import 'dart:typed_data';
import 'ai_service.dart';

/// Video understanding / analysis service.
/// Analyzes recorded activities, tutorials, classroom sessions.
class VideoAnalysisService {
  final AIService _ai;

  VideoAnalysisService(this._ai);

  /// Analyze a child's recorded screen activity
  Future<Map<String, dynamic>> analyzeActivity(Uint8List videoData) async {
    final result = await _ai.analyzeVideo(videoData,
      'This video shows a child using an educational app. '
      'Analyze their engagement level, time spent on activities, and learning patterns. '
      'Reply as JSON: {"engagement": "low|medium|high", "focusAreas": ["list"], '
      '"suggestions": ["list of improvement suggestions"]}');
    try {
      return Map<String, dynamic>.from(
        (result as String).isNotEmpty ? {} : {},
      );
    } catch (_) {
      return {'engagement': 'medium', 'focusAreas': [], 'suggestions': []};
    }
  }

  /// Analyze a drawing replay to assess technique
  Future<String> analyzeDrawingReplay(Uint8List videoData, String word) async {
    return _ai.analyzeVideo(videoData,
      'This video shows a child drawing "$word". '
      'Analyze their stroke order, technique, and creativity. '
      'Give encouraging feedback suitable for a young child.');
  }

  /// Teacher: Analyze a classroom lesson
  Future<String> analyzeLesson(Uint8List videoData) async {
    return _ai.analyzeVideo(videoData,
      'This video shows a classroom teaching session for young children (ages 2-7). '
      'Summarize the topics covered, teaching methods used, and suggest follow-up activities.');
  }
}
