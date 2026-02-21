import 'dart:typed_data';
import 'dart:convert';
import 'ai_service.dart';

/// Vision / Image Analysis service.
/// Grades handwriting, assesses drawings, scans worksheets, identifies objects.
class VisionService {
  final AIService _ai;

  VisionService(this._ai);

  /// Grade a child's handwriting attempt
  /// Returns: {stars: 1-5, feedback: String}
  Future<Map<String, dynamic>> gradeHandwriting(Uint8List image, String letter) async {
    final result = await _ai.analyzeImage(image, _ai.handwritingPrompt(letter));
    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (_) {
      return {'stars': 3, 'feedback': 'Good try! Keep practicing!'};
    }
  }

  /// Assess a child's drawing
  /// Returns: {stars: 1-5, feedback: String, nextTip: String}
  Future<Map<String, dynamic>> assessDrawing(Uint8List image, String word) async {
    final result = await _ai.analyzeImage(image, _ai.drawingPrompt(word));
    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (_) {
      return {'stars': 3, 'feedback': 'Wonderful drawing!', 'nextTip': 'Try adding more details!'};
    }
  }

  /// Scan and grade a printed worksheet
  Future<Map<String, dynamic>> scanWorksheet(Uint8List image) async {
    final result = await _ai.analyzeImage(image,
      'This is a children\'s learning worksheet that has been filled out. '
      'Grade each answer. Reply as JSON: {"total": N, "correct": N, "feedback": "summary"}');
    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (_) {
      return {'total': 0, 'correct': 0, 'feedback': 'Could not analyze worksheet.'};
    }
  }

  /// Identify an object from camera (AR mode)
  /// Returns: {label: String, letter: String, description: String}
  Future<Map<String, dynamic>> identifyObject(Uint8List image) async {
    final result = await _ai.analyzeImage(image,
      'What object is this? Reply as JSON: '
      '{"label": "object name", "letter": "first letter", '
      '"description": "fun fact for a 4-year-old, 1 sentence"}');
    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (_) {
      return {'label': 'something', 'letter': '?', 'description': 'I see something interesting!'};
    }
  }
}
