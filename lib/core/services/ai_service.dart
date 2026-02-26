import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ai_provider.dart';
import 'providers/mock_ai_provider.dart';
import 'providers/openai_provider.dart';
import 'providers/gemini_provider.dart';
import 'providers/anthropic_provider.dart';
import 'storage_service.dart';

/// Central AI Service facade.
/// Delegates to the selected provider, adds caching, safety filters, and rate limiting.
class AIService {
  AIProvider _provider;
  final StorageService _storage;
  final Map<String, _CacheEntry> _cache = {};

  // Rate limiting
  int _requestCount = 0;
  DateTime _windowStart = DateTime.now();
  static const int _maxRequestsPerMinute = 30;

  // Safety
  static const List<String> _blockedTerms = [
    'violence', 'weapon', 'scary', 'horror', 'blood',
    'adult', 'inappropriate', 'dangerous',
  ];

  AIService({required StorageService storage, AIProvider? provider})
      : _storage = storage,
        _provider = provider ?? MockAIProvider();

  /// Current provider info
  String get providerName => _provider.name;
  AIProviderType get providerType => _provider.type;

  /// Switch provider at runtime
  void switchProvider(AIProviderType type, {String? apiKey}) {
    _provider.dispose();
    switch (type) {
      case AIProviderType.openai:
        _provider = OpenAIProvider(apiKey: apiKey ?? '');
        break;
      case AIProviderType.gemini:
        _provider = GeminiProvider(apiKey: apiKey ?? '');
        break;
      case AIProviderType.anthropic:
        _provider = AnthropicProvider(apiKey: apiKey ?? '');
        break;
      case AIProviderType.mock:
        _provider = MockAIProvider();
        break;
    }
    // Save preference
    _storage.saveSetting('ai_provider', type.name);
    if (apiKey != null) _storage.saveSetting('ai_api_key', apiKey);
  }

  /// Initialize from saved settings
  void initFromSettings() {
    final providerName = _storage.getSetting('ai_provider');
    final apiKey = _storage.getSetting('ai_api_key');
    if (providerName != null) {
      final type = AIProviderType.values.firstWhere(
        (t) => t.name == providerName,
        orElse: () => AIProviderType.mock,
      );
      switchProvider(type, apiKey: apiKey);
    }
  }

  // ═══════════════════════════════════════════════
  //  DELEGATED METHODS WITH CACHING & SAFETY
  // ═══════════════════════════════════════════════

  /// Generate text with caching and offline fallback
  Future<String> generateText(String prompt, {AIConfig? config, bool cache = true}) async {
    final cacheKey = 'text:${prompt.hashCode}';
    final online = await _isNetworkAvailable();
    
    if (cache || !online) {
      final cached = _getCache(cacheKey);
      if (cached != null) return cached as String;
    }

    if (!online) {
      return MockAIProvider().generateText(prompt, config: config);
    }

    await _checkRateLimit();
    final result = await _provider.generateText(_sanitizePrompt(prompt), config: config);
    final safe = _filterResponse(result);
    if (cache) _setCache(cacheKey, safe);
    return safe;
  }

  /// Chat with safety filters
  Future<String> chat(List<ChatMessage> messages, {AIConfig? config}) async {
    await _checkRateLimit();
    final safeMessages = messages.map((m) => ChatMessage(
      role: m.role,
      content: _sanitizePrompt(m.content),
      imageData: m.imageData,
    )).toList();
    final result = await _provider.chat(safeMessages, config: config);
    return _filterResponse(result);
  }

  /// Streaming chat
  Stream<String> chatStream(List<ChatMessage> messages, {AIConfig? config}) async* {
    await _checkRateLimit();
    await for (final chunk in _provider.chatStream(messages, config: config)) {
      yield chunk;
    }
  }

  /// Generate image with caching
  Future<Uint8List> generateImage(String prompt, {int width = 512, int height = 512}) async {
    final cacheKey = 'img:${prompt.hashCode}';
    final online = await _isNetworkAvailable();
    
    final cached = _getCache(cacheKey);
    if (cached != null) return cached as Uint8List;

    if (!online) {
      return MockAIProvider().generateImage(prompt, width: width, height: height);
    }

    await _checkRateLimit();
    final result = await _provider.generateImage(
      '$prompt. Style: child-friendly, colorful, safe for children aged 2-7.',
      width: width,
      height: height,
    );
    _setCache(cacheKey, result);
    return result;
  }

  /// Animate an image
  Future<Uint8List> animateImage(Uint8List imageData, String motionPrompt) async {
    final online = await _isNetworkAvailable();
    if (!online) return MockAIProvider().animateImage(imageData, motionPrompt);
    
    await _checkRateLimit();
    return _provider.animateImage(imageData, motionPrompt);
  }

  /// Analyze image (vision)
  Future<String> analyzeImage(Uint8List imageData, String question) async {
    final online = await _isNetworkAvailable();
    if (!online) return MockAIProvider().analyzeImage(imageData, question);

    await _checkRateLimit();
    return _provider.analyzeImage(imageData, question);
  }

  /// Transcribe audio
  Future<String> transcribeAudio(Uint8List audioData, {String? language}) async {
    final online = await _isNetworkAvailable();
    if (!online) return MockAIProvider().transcribeAudio(audioData, language: language);

    await _checkRateLimit();
    return _provider.transcribeAudio(audioData, language: language);
  }

  /// Generate speech
  Future<Uint8List> generateSpeech(String text, {String? voice, String? language}) async {
    final cacheKey = 'speech:${text.hashCode}:$voice';
    final online = await _isNetworkAvailable();

    final cached = _getCache(cacheKey);
    if (cached != null) return cached as Uint8List;

    if (!online) {
      return MockAIProvider().generateSpeech(text, voice: voice, language: language);
    }

    await _checkRateLimit();
    final result = await _provider.generateSpeech(text, voice: voice, language: language);
    _setCache(cacheKey, result);
    return result;
  }

  /// Generate video
  Future<Uint8List> generateVideo(String prompt, {int durationSeconds = 10}) async {
    final online = await _isNetworkAvailable();
    if (!online) return MockAIProvider().generateVideo(prompt, durationSeconds: durationSeconds);

    await _checkRateLimit();
    return _provider.generateVideo(
      '$prompt. Child-friendly animation, bright colors, no scary content.',
      durationSeconds: durationSeconds,
    );
  }

  /// Analyze video
  Future<String> analyzeVideo(Uint8List videoData, String question) async {
    final online = await _isNetworkAvailable();
    if (!online) return MockAIProvider().analyzeVideo(videoData, question);

    await _checkRateLimit();
    return _provider.analyzeVideo(videoData, question);
  }

  /// Advanced reasoning
  Future<String> reason(String prompt, {AIConfig? config}) async {
    final online = await _isNetworkAvailable();
    if (!online) return MockAIProvider().reason(prompt, config: config);

    await _checkRateLimit();
    return _provider.reason(prompt, config: config);
  }

  /// Fast AI response
  Future<String> fastResponse(String prompt, {AIConfig? config}) async {
    final online = await _isNetworkAvailable();
    final cacheKey = 'fast:${prompt.hashCode}';

    if (!online) {
      final cached = _getCache(cacheKey);
      if (cached != null) return cached as String;
      return MockAIProvider().fastResponse(prompt, config: config);
    }

    await _checkRateLimit();
    final result = await _provider.fastResponse(_sanitizePrompt(prompt), config: config);
    _setCache(cacheKey, result);
    return result;
  }

  // ═══════════════════════════════════════════════
  //  CHILD-SPECIFIC CONVENIENCE METHODS
  // ═══════════════════════════════════════════════

  /// Get the "Ask Buddy" system prompt
  AIConfig buddyChatConfig(int childAge) => AIConfig(
    temperature: 0.8,
    maxTokens: 150,
    systemPrompt: '''You are Buddy, a friendly learning helper for kids aged $childAge.
Rules:
- Keep answers to 1-2 short sentences
- Use simple words a ${childAge}-year-old understands
- Be very encouraging and enthusiastic
- Use emojis liberally
- Only discuss educational topics (letters, words, animals, colors, shapes, nature)
- Never share URLs, personal info, or anything inappropriate
- If asked about anything not educational, redirect gently to learning topics
- Relate answers back to letters and words when possible''',
  );

  /// Get a pronunciation score prompt
  String pronunciationPrompt(String expectedWord, String transcribed) =>
    'A child tried to say "$expectedWord" and said "$transcribed". '
    'Rate the pronunciation 1-3 (1=attempt, 2=close, 3=perfect). '
    'Reply as JSON: {"score": N, "feedback": "short encouraging feedback for a child"}';

  /// Get a handwriting grading prompt
  String handwritingPrompt(String letter) =>
    'This image shows a child\'s attempt to write the letter "$letter". '
    'Rate it 1-5 stars. Focus on: line quality, shape accuracy, and size consistency. '
    'Reply as JSON: {"stars": N, "feedback": "encouraging tip for a child"}';

  /// Get a drawing assessment prompt
  String drawingPrompt(String word) =>
    'This image shows a child\'s drawing of "$word". '
    'Give encouraging feedback. '
    'Reply as JSON: {"stars": N, "feedback": "encouraging comment", "nextTip": "one simple improvement tip"}';

  // ═══════════════════════════════════════════════
  //  SAFETY & RATE LIMITING
  // ═══════════════════════════════════════════════

  String _sanitizePrompt(String prompt) {
    // Append child-safety instruction
    return '$prompt\n[This content is for children aged 2-7. Keep it safe, educational, and age-appropriate.]';
  }

  String _filterResponse(String response) {
    // Basic blocked term check
    final lower = response.toLowerCase();
    for (final term in _blockedTerms) {
      if (lower.contains(term)) {
        return 'Let\'s learn something fun instead! 🌟';
      }
    }
    return response;
  }

  Future<void> _checkRateLimit() async {
    final now = DateTime.now();
    if (now.difference(_windowStart).inMinutes >= 1) {
      _requestCount = 0;
      _windowStart = now;
    }
    _requestCount++;
    if (_requestCount > _maxRequestsPerMinute) {
      throw Exception('Rate limit exceeded. Please wait a moment before trying again.');
    }
  }

  // ═══════════════════════════════════════════════
  //  PERSISTENT OFFLINE CACHE & NETWORK
  // ═══════════════════════════════════════════════

  Future<bool> _isNetworkAvailable() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    } catch (_) {
      return true; // Assume online if check fails
    }
  }

  Box get _cacheBox => Hive.box('ai_cache');

  dynamic _getCache(String key) {
    // 1. Check persistent offline cache (lasts 7 days)
    if (_cacheBox.containsKey(key)) {
      final data = _cacheBox.get(key);
      if (data != null && data is Map) {
        final createdStr = data['created'] as String?;
        if (createdStr != null) {
          final timestamp = DateTime.parse(createdStr);
          if (DateTime.now().difference(timestamp).inDays < 7) {
            return data['value'];
          } else {
            _cacheBox.delete(key);
          }
        }
      }
    }

    // 2. Check fast memory cache
    final entry = _cache[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.created).inHours > 24) {
      _cache.remove(key);
      return null;
    }
    return entry.data;
  }

  void _setCache(String key, dynamic data) {
    if (data == null) return;
    
    // Save to Hive for persistent offline mode
    try {
      _cacheBox.put(key, {
        'value': data,
        'created': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Ignore Hive serialization errors if data is too complex
    }

    // Also fast memory cache
    if (_cache.length > 200) {
      final oldest = _cache.entries.reduce((a, b) => a.value.created.isBefore(b.value.created) ? a : b);
      _cache.remove(oldest.key);
    }
    _cache[key] = _CacheEntry(data: data, created: DateTime.now());
  }

  void clearCache() {
    _cache.clear();
    _cacheBox.clear();
  }

  void dispose() {
    _provider.dispose();
    _cache.clear();
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime created;
  _CacheEntry({required this.data, required this.created});
}
