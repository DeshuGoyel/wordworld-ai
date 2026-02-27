import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_keys.dart';
import '../models/story_models.dart';
import 'objectbox_service.dart';
import 'package:learn_app/core/models/objectbox_models.dart';
import '../../data/models/objectbox.dart';

class StoryService {
  static final instance = StoryService._();
  StoryService._();

  static const _baseUrl =
    'https://generativelanguage.googleapis.com'
    '/v1beta/models/gemini-1.5-flash'
    ':generateContent';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  // ── PUBLIC METHOD ──────────────────────────

  Future<StoryData> generateStory({
    required String heroName,
    required String heroEmoji,
    required String setting,
    required String problem,
    required String childName,
    required String languageMode, // 'en'|'hi'|'both'
    required String ageBand,
  }) async {
    // Check internet connectivity first:
    final connectivity = await Connectivity().checkConnectivity();
    final isOffline = connectivity == ConnectivityResult.none;

    if (isOffline) {
      debugPrint('StoryService: offline, returning fallback');
      return StoryData.fallback(
        heroName: heroName,
        heroEmoji: heroEmoji,
        childName: childName,
      );
    }

    try {
      final prompt = _buildPrompt(
        heroName: heroName,
        heroEmoji: heroEmoji,
        setting: setting,
        problem: problem,
        childName: childName,
        languageMode: languageMode,
        ageBand: ageBand,
      );

      final response = await _dio.post(
        '$_baseUrl?key=${ApiKeys.geminiApiKey}',
        data: {
          'contents': [
            {
              'parts': [{'text': prompt}]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'temperature': 0.75,
            'maxOutputTokens': 1200,
            'topP': 0.9,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_LOW_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_LOW_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_LOW_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_LOW_AND_ABOVE',
            },
          ],
        },
      );

      // Parse response:
      final candidates = response.data['candidates'];
      if (candidates == null || (candidates as List).isEmpty) {
        throw Exception('No candidates in response');
      }

      final text = candidates[0]['content']['parts'][0]['text'] as String;

      // Clean JSON (Gemini sometimes adds backticks):
      final cleanJson = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

      final jsonMap = jsonDecode(cleanJson) as Map<String, dynamic>;

      final story = StoryData.fromJson(
        jsonMap,
        heroName: heroName,
        heroEmoji: heroEmoji,
      );

      // Validate: must have 5 scenes (3 min):
      if (story.scenes.length < 3) {
        throw Exception('Too few scenes: ${story.scenes.length}');
      }

      // Save to ObjectBox:
      _saveStory(story);

      return story;

    } on DioException catch (e) {
      debugPrint('Gemini network error: ${e.message}');
      return StoryData.fallback(
        heroName: heroName,
        heroEmoji: heroEmoji,
        childName: childName,
      );
    } catch (e, stack) {
      debugPrint('Story error: $e\n$stack');
      return StoryData.fallback(
        heroName: heroName,
        heroEmoji: heroEmoji,
        childName: childName,
      );
    }
  }

  // ── GEMINI PROMPT ──────────────────────────

  String _buildPrompt({
    required String heroName,
    required String heroEmoji,
    required String setting,
    required String problem,
    required String childName,
    required String languageMode,
    required String ageBand,
  }) {
    return '''
You are a creative children's story writer.
Write a short story for a $ageBand-year-old child.
Output ONLY valid JSON. No extra text. No markdown code blocks.

Story parameters:
- Hero: $heroName $heroEmoji
- Setting: $setting
- Problem to solve: $problem
- Child reading it: $childName (include as helper character)
- Language mode: $languageMode

Return this exact JSON structure:
{
  "title": "Short catchy English title",
  "title_hi": "Hindi title यहाँ",
  "scenes": [
    {
      "id": 1,
      "text_en": "Scene 1 in English. Simple words. Max 30 words.",
      "text_hi": "Scene 1 in Hindi. Max 30 words.",
      "emotion": "happy",
      "has_choice": false
    },
    {
      "id": 2,
      "text_en": "Scene 2 English text.",
      "text_hi": "Scene 2 Hindi text.",
      "emotion": "excited",
      "has_choice": false
    },
    {
      "id": 3,
      "text_en": "Scene 3 creates a dilemma.",
      "text_hi": "Scene 3 Hindi.",
      "emotion": "thinking",
      "has_choice": true,
      "choice": {
        "question_en": "What should $heroName do?",
        "question_hi": "$heroName को क्या करना चाहिए?",
        "option_a_en": "Kind/helpful option",
        "option_a_hi": "Hindi option A",
        "option_b_en": "Alternative option",
        "option_b_hi": "Hindi option B"
      }
    },
    {
      "id": 4,
      "text_en": "Scene 4 after the choice.",
      "text_hi": "Scene 4 Hindi.",
      "emotion": "excited",
      "has_choice": false
    },
    {
      "id": 5,
      "text_en": "Happy ending! Include $childName clapping.",
      "text_hi": "Happy ending in Hindi!",
      "emotion": "proud",
      "has_choice": false
    }
  ],
  "moral_en": "Short lesson: 1 sentence",
  "moral_hi": "Hindi moral: 1 sentence"
}

STRICT RULES:
1. Exactly 5 scenes — no more, no less
2. Words appropriate for age $ageBand
3. Choice ONLY at scene id 3
4. Happy positive ending always
5. $childName must appear as helper character
6. Max 30 words per scene text
7. Both en and hi required for all text
8. Output ONLY the JSON object above
9. No text before or after the JSON
''';
  }

  // ── PERSIST ────────────────────────────────

  void _saveStory(StoryData story) {
    try {
      ObjectBoxService.storyBox.put(story.toEntity());
    } catch (e) {
      debugPrint('Failed to save story: $e');
    }
  }

  // ── HISTORY ────────────────────────────────

  List<StoryData> getSavedStories() {
    try {
      final entities = ObjectBoxService.storyBox
        .query()
        .order(StoryEntity_.createdAt, flags: Order.descending)
        .build()
        .find();

      return entities.map((e) {
        final scenesRaw = jsonDecode(e.scenesJson) as List;
        return StoryData(
          title: e.title,
          titleHi: e.titleHi,
          heroName: e.heroName,
          heroEmoji: '📖',
          moralEn: e.moralEn,
          moralHi: e.moralHi,
          createdAt: e.createdAt,
          scenes: scenesRaw
            .map((s) => StoryScene.fromJson(s as Map<String, dynamic>))
            .toList(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
