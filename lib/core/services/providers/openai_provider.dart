import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ai_provider.dart';

/// OpenAI provider implementation.
/// Supports: GPT-4o, GPT-4o-mini, DALL-E 3, Whisper, TTS, etc.
class OpenAIProvider extends AIProvider {
  final String apiKey;
  final String _baseUrl = 'https://api.openai.com/v1';
  final http.Client _client = http.Client();

  OpenAIProvider({required this.apiKey});

  @override
  String get name => 'OpenAI';
  @override
  AIProviderType get type => AIProviderType.openai;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  // ─── Text Generation ───
  @override
  Future<String> generateText(String prompt, {AIConfig? config}) async {
    final body = jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        if (config?.systemPrompt != null) {'role': 'system', 'content': config!.systemPrompt},
        {'role': 'user', 'content': prompt},
      ],
      'temperature': config?.temperature ?? 0.7,
      'max_tokens': config?.maxTokens ?? 1024,
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/chat/completions'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return json['choices'][0]['message']['content'] as String;
  }

  // ─── Chat ───
  @override
  Future<String> chat(List<ChatMessage> messages, {AIConfig? config}) async {
    final apiMessages = messages.map((m) {
      if (m.imageData != null) {
        return {
          'role': m.role,
          'content': [
            {'type': 'text', 'text': m.content},
            {'type': 'image_url', 'image_url': {'url': 'data:image/png;base64,${base64Encode(m.imageData!)}'}},
          ],
        };
      }
      return {'role': m.role, 'content': m.content};
    }).toList();

    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        if (config?.systemPrompt != null) {'role': 'system', 'content': config!.systemPrompt},
        ...apiMessages,
      ],
      'temperature': config?.temperature ?? 0.7,
      'max_tokens': config?.maxTokens ?? 1024,
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/chat/completions'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return json['choices'][0]['message']['content'] as String;
  }

  @override
  Stream<String> chatStream(List<ChatMessage> messages, {AIConfig? config}) async* {
    final apiMessages = messages.map((m) => {'role': m.role, 'content': m.content}).toList();
    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        if (config?.systemPrompt != null) {'role': 'system', 'content': config!.systemPrompt},
        ...apiMessages,
      ],
      'stream': true,
      'temperature': config?.temperature ?? 0.7,
    });

    final request = http.Request('POST', Uri.parse('$_baseUrl/chat/completions'));
    request.headers.addAll(_headers);
    request.body = body;

    final streamedResp = await _client.send(request);
    await for (final chunk in streamedResp.stream.transform(utf8.decoder)) {
      for (final line in chunk.split('\n')) {
        if (line.startsWith('data: ') && !line.contains('[DONE]')) {
          try {
            final json = jsonDecode(line.substring(6));
            final delta = json['choices']?[0]?['delta']?['content'];
            if (delta != null) yield delta as String;
          } catch (_) {}
        }
      }
    }
  }

  // ─── Image Generation (DALL-E 3) ───
  @override
  Future<Uint8List> generateImage(String prompt, {int width = 1024, int height = 1024}) async {
    final size = '${width}x$height';
    final body = jsonEncode({
      'model': 'dall-e-3',
      'prompt': prompt,
      'n': 1,
      'size': size,
      'response_format': 'b64_json',
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/images/generations'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return base64Decode(json['data'][0]['b64_json'] as String);
  }

  // ─── Image Animation (not natively supported — fallback) ───
  @override
  Future<Uint8List> animateImage(Uint8List imageData, String motionPrompt) async {
    // OpenAI doesn't have native image animation — return original
    return imageData;
  }

  // ─── Vision / Image Analysis (GPT-4o) ───
  @override
  Future<String> analyzeImage(Uint8List imageData, String question) async {
    final b64 = base64Encode(imageData);
    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [{
        'role': 'user',
        'content': [
          {'type': 'text', 'text': question},
          {'type': 'image_url', 'image_url': {'url': 'data:image/png;base64,$b64'}},
        ],
      }],
      'max_tokens': 500,
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/chat/completions'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return json['choices'][0]['message']['content'] as String;
  }

  // ─── Speech-to-Text (Whisper) ───
  @override
  Future<String> transcribeAudio(Uint8List audioData, {String? language}) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/audio/transcriptions'));
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.fields['model'] = 'whisper-1';
    if (language != null) request.fields['language'] = language;
    request.files.add(http.MultipartFile.fromBytes('file', audioData, filename: 'audio.wav'));
    final resp = await request.send();
    final body = await resp.stream.bytesToString();
    final json = jsonDecode(body);
    return json['text'] as String;
  }

  // ─── Speech Generation (TTS) ───
  @override
  Future<Uint8List> generateSpeech(String text, {String? voice, String? language}) async {
    final body = jsonEncode({
      'model': 'tts-1',
      'input': text,
      'voice': voice ?? 'nova', // kid-friendly voice
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/audio/speech'), headers: _headers, body: body);
    return resp.bodyBytes;
  }

  // ─── Video Generation (not natively supported) ───
  @override
  Future<Uint8List> generateVideo(String prompt, {int durationSeconds = 10}) async {
    return Uint8List(0); // Not supported yet
  }

  // ─── Video Understanding (not natively supported) ───
  @override
  Future<String> analyzeVideo(Uint8List videoData, String question) async {
    return 'Video analysis is not yet supported with OpenAI.';
  }

  // ─── Advanced Reasoning (o3) ───
  @override
  Future<String> reason(String prompt, {AIConfig? config}) async {
    final body = jsonEncode({
      'model': 'o3-mini',
      'messages': [
        if (config?.systemPrompt != null) {'role': 'system', 'content': config!.systemPrompt},
        {'role': 'user', 'content': prompt},
      ],
    });
    final resp = await _client.post(Uri.parse('$_baseUrl/chat/completions'), headers: _headers, body: body);
    final json = jsonDecode(resp.body);
    return json['choices'][0]['message']['content'] as String;
  }

  // ─── Fast Response (GPT-4o-mini) ───
  @override
  Future<String> fastResponse(String prompt, {AIConfig? config}) async {
    return generateText(prompt, config: AIConfig(
      temperature: config?.temperature ?? 0.5,
      maxTokens: config?.maxTokens ?? 256,
      systemPrompt: config?.systemPrompt,
    ));
  }

  @override
  void dispose() {
    _client.close();
  }
}
