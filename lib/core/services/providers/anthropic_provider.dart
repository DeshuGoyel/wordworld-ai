import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ai_provider.dart';

/// Anthropic (Claude) provider implementation.
/// Supports: Claude 3.5 Sonnet, Claude 3 Haiku, Vision
class AnthropicProvider extends AIProvider {
  final String apiKey;
  final String _baseUrl = 'https://api.anthropic.com/v1';
  final http.Client _client = http.Client();

  AnthropicProvider({required this.apiKey});

  @override
  String get name => 'Anthropic';
  @override
  AIProviderType get type => AIProviderType.anthropic;

  Map<String, String> get _headers => {
    'x-api-key': apiKey,
    'Content-Type': 'application/json',
    'anthropic-version': '2023-06-01',
  };

  // ─── Text Generation ───
  @override
  Future<String> generateText(String prompt, {AIConfig? config}) async {
    final body = jsonEncode({
      'model': 'claude-sonnet-4-20250514',
      'max_tokens': config?.maxTokens ?? 1024,
      'messages': [{'role': 'user', 'content': prompt}],
      if (config?.systemPrompt != null) 'system': config!.systemPrompt,
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/messages'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return (json['content'] as List).where((b) => b['type'] == 'text').map((b) => b['text']).join();
  }

  // ─── Chat ───
  @override
  Future<String> chat(List<ChatMessage> messages, {AIConfig? config}) async {
    final systemMsgs = messages.where((m) => m.role == 'system').map((m) => m.content).join('\n');
    final apiMessages = messages.where((m) => m.role != 'system').map((m) {
      if (m.imageData != null) {
        return {
          'role': m.role,
          'content': [
            {'type': 'text', 'text': m.content},
            {'type': 'image', 'source': {'type': 'base64', 'media_type': 'image/png', 'data': base64Encode(m.imageData!)}},
          ],
        };
      }
      return {'role': m.role, 'content': m.content};
    }).toList();

    final body = jsonEncode({
      'model': 'claude-sonnet-4-20250514',
      'max_tokens': config?.maxTokens ?? 1024,
      'messages': apiMessages,
      if (systemMsgs.isNotEmpty) 'system': config?.systemPrompt ?? systemMsgs,
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/messages'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return (json['content'] as List).where((b) => b['type'] == 'text').map((b) => b['text']).join();
  }

  @override
  Stream<String> chatStream(List<ChatMessage> messages, {AIConfig? config}) async* {
    final apiMessages = messages.where((m) => m.role != 'system').map((m) {
      return {'role': m.role, 'content': m.content};
    }).toList();

    final body = jsonEncode({
      'model': 'claude-sonnet-4-20250514',
      'max_tokens': config?.maxTokens ?? 1024,
      'messages': apiMessages,
      'stream': true,
    });

    final request = http.Request('POST', Uri.parse('$_baseUrl/messages'));
    request.headers.addAll(_headers);
    request.body = body;

    final streamedResp = await _client.send(request);
    await for (final chunk in streamedResp.stream.transform(utf8.decoder)) {
      for (final line in chunk.split('\n')) {
        if (line.startsWith('data: ')) {
          try {
            final json = jsonDecode(line.substring(6));
            if (json['type'] == 'content_block_delta') {
              final text = json['delta']?['text'];
              if (text != null) yield text as String;
            }
          } catch (_) {}
        }
      }
    }
  }

  // ─── Image Generation (not natively supported) ───
  @override
  Future<Uint8List> generateImage(String prompt, {int width = 1024, int height = 1024}) async {
    return Uint8List(0); // Anthropic doesn't offer image generation
  }

  // ─── Image Animation ───
  @override
  Future<Uint8List> animateImage(Uint8List imageData, String motionPrompt) async {
    return imageData; // Not supported
  }

  // ─── Vision / Image Analysis ───
  @override
  Future<String> analyzeImage(Uint8List imageData, String question) async {
    final b64 = base64Encode(imageData);
    final body = jsonEncode({
      'model': 'claude-sonnet-4-20250514',
      'max_tokens': 500,
      'messages': [{
        'role': 'user',
        'content': [
          {'type': 'text', 'text': question},
          {'type': 'image', 'source': {'type': 'base64', 'media_type': 'image/png', 'data': b64}},
        ],
      }],
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/messages'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return (json['content'] as List).where((b) => b['type'] == 'text').map((b) => b['text']).join();
  }

  // ─── STT (not natively supported) ───
  @override
  Future<String> transcribeAudio(Uint8List audioData, {String? language}) async {
    return ''; // Not supported natively
  }

  // ─── Speech (not natively supported) ───
  @override
  Future<Uint8List> generateSpeech(String text, {String? voice, String? language}) async {
    return Uint8List(0); // Not supported
  }

  // ─── Video (not supported) ───
  @override
  Future<Uint8List> generateVideo(String prompt, {int durationSeconds = 10}) async => Uint8List(0);

  @override
  Future<String> analyzeVideo(Uint8List videoData, String question) async => '';

  // ─── Advanced Reasoning (Claude with extended thinking) ───
  @override
  Future<String> reason(String prompt, {AIConfig? config}) async {
    final body = jsonEncode({
      'model': 'claude-sonnet-4-20250514',
      'max_tokens': 16000,
      'thinking': {'type': 'enabled', 'budget_tokens': 4096},
      'messages': [{'role': 'user', 'content': prompt}],
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/messages'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return (json['content'] as List).where((b) => b['type'] == 'text').map((b) => b['text']).join();
  }

  // ─── Fast Response (Haiku) ───
  @override
  Future<String> fastResponse(String prompt, {AIConfig? config}) async {
    final body = jsonEncode({
      'model': 'claude-3-5-haiku-20241022',
      'max_tokens': config?.maxTokens ?? 256,
      'messages': [{'role': 'user', 'content': prompt}],
      if (config?.systemPrompt != null) 'system': config!.systemPrompt,
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/messages'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return (json['content'] as List).where((b) => b['type'] == 'text').map((b) => b['text']).join();
  }

  @override
  void dispose() {
    _client.close();
  }
}
