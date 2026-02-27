import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'ai_service.dart';

/// Vision / Image Analysis service using Google ML Kit.
/// Grades handwriting, assesses drawings, scans worksheets, identifies objects.
class VisionService {
  final AIService _ai;
  late final ImageLabeler _imageLabeler;
  late final TextRecognizer _textRecognizer;

  VisionService(this._ai) {
    _imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  void dispose() {
    _imageLabeler.close();
    _textRecognizer.close();
  }

  /// Helper to convert UI bytes to a File so ML Kit can process it safely.
  Future<File> _saveTempFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_vision_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Grade a child's handwriting attempt
  /// Returns: {stars: 1-5, feedback: String, text: String}
  Future<Map<String, dynamic>> gradeHandwriting(Uint8List imageBytes, String expectedLetter) async {
    final file = await _saveTempFile(imageBytes);
    final inputImage = InputImage.fromFilePath(file.path);
    
    try {
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      final text = recognizedText.text.toUpperCase();
      final expected = expectedLetter.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
      
      int stars = 1;
      String feedback = "Keep practicing!";
      
      if (text.contains(expected)) {
        stars = 5;
        feedback = "Perfect! You wrote $expectedLetter beautifully! ⭐⭐⭐⭐⭐";
      } else if (text.isNotEmpty) {
        stars = 3;
        feedback = "Good try! I saw '$text' instead of $expectedLetter.";
      }
      
      return {'stars': stars, 'feedback': feedback, 'text': text};
    } catch (e) {
      return {'stars': 3, 'feedback': 'Good try! Keep practicing!'};
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  /// Assess a child's drawing
  /// Returns: {stars: 1-5, feedback: String, nextTip: String}
  Future<Map<String, dynamic>> assessDrawing(Uint8List imageBytes, String expectedWord) async {
    final file = await _saveTempFile(imageBytes);
    final inputImage = InputImage.fromFilePath(file.path);
    
    try {
      final labels = await _imageLabeler.processImage(inputImage);
      
      bool found = false;
      List<String> seenLabels = [];
      for (ImageLabel label in labels) {
        seenLabels.add(label.label);
        if (label.label.toLowerCase().contains(expectedWord.toLowerCase())) {
          found = true;
          break;
        }
      }
      
      if (found) {
        return {'stars': 5, 'feedback': 'Wonderful! I see a $expectedWord! ⭐⭐⭐⭐⭐', 'nextTip': 'Try adding more details!'};
      } else {
        // Just return the top found item safely
        final topMatch = seenLabels.isNotEmpty ? seenLabels.first : "a great picture";
        return {'stars': 3, 'feedback': 'Great drawing! I see $topMatch.', 'nextTip': 'Keep exploring!'};
      }
    } catch (e) {
      return {'stars': 3, 'feedback': 'Wonderful drawing!', 'nextTip': 'Try adding more details!'};
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
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
    final file = await _saveTempFile(image);
    final inputImage = InputImage.fromFilePath(file.path);
    try {
      final labels = await _imageLabeler.processImage(inputImage);
      if (labels.isNotEmpty) {
         final label = labels.first.label;
         return {'label': label, 'letter': label.substring(0, 1).toUpperCase(), 'description': 'I see a $label!'};
      }
      return {'label': 'something', 'letter': '?', 'description': 'I see something interesting!'};
    } catch (_) {
      return {'label': 'something', 'letter': '?', 'description': 'I see something interesting!'};
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
