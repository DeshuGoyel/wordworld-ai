import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ai_provider.dart';

/// Google Gemini provider implementation.
/// Supports: Gemini 2.0 Flash, Gemini 2.0 Pro, Imagen 3, etc.
class GeminiProvider extends AIProvider {
  final String apiKey;
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  final http.Client _client = http.Client();

  GeminiProvider({required this.apiKey});

  @override
  String get name => 'Gemini';
  @override
  AIProviderType get type => AIProviderType.gemini;

  // ─── Text Generation ───
  @override
  Future<String> generateText(String prompt, {AIConfig? config}) async {
    final body = jsonEncode({
      'contents': [{'parts': [{'text': prompt}]}],
      'generationConfig': {
        'temperature': config?.temperature ?? 0.7,
        'maxOutputTokens': config?.maxTokens ?? 1024,
      },
      if (config?.systemPrompt != null)
        'systemInstruction': {'parts': [{'text': config!.systemPrompt}]},
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/gemini-2.0-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    return json['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  // ─── Chat ───
  @override
  Future<String> chat(List<ChatMessage> messages, {AIConfig? config}) async {
    final contents = messages.where((m) => m.role != 'system').map((m) {
      final parts = <Map<String, dynamic>>[{'text': m.content}];
      if (m.imageData != null) {
        parts.add({'inline_data': {'mime_type': 'image/png', 'data': base64Encode(m.imageData!)}});
      }
      return {'role': m.role == 'assistant' ? 'model' : 'user', 'parts': parts};
    }).toList();

    final systemMsg = messages.where((m) => m.role == 'system').map((m) => m.content).join('\n');

    final body = jsonEncode({
      'contents': contents,
      'generationConfig': {
        'temperature': config?.temperature ?? 0.7,
        'maxOutputTokens': config?.maxTokens ?? 1024,
      },
      if (systemMsg.isNotEmpty || config?.systemPrompt != null)
        'systemInstruction': {'parts': [{'text': config?.systemPrompt ?? systemMsg}]},
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/gemini-2.0-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    return json['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  @override
  Stream<String> chatStream(List<ChatMessage> messages, {AIConfig? config}) async* {
    final contents = messages.where((m) => m.role != 'system').map((m) {
      return {'role': m.role == 'assistant' ? 'model' : 'user', 'parts': [{'text': m.content}]};
    }).toList();

    final body = jsonEncode({
      'contents': contents,
      'generationConfig': {'temperature': config?.temperature ?? 0.7},
    });

    final request = http.Request('POST',
      Uri.parse('$_baseUrl/models/gemini-2.0-flash:streamGenerateContent?alt=sse&key=$apiKey'));
    request.headers['Content-Type'] = 'application/json';
    request.body = body;

    final streamedResp = await _client.send(request);
    await for (final chunk in streamedResp.stream.transform(utf8.decoder)) {
      for (final line in chunk.split('\n')) {
        if (line.startsWith('data: ')) {
          try {
            final json = jsonDecode(line.substring(6));
            final text = json['candidates']?[0]?['content']?['parts']?[0]?['text'];
            if (text != null) yield text as String;
          } catch (_) {}
        }
      }
    }
  }

  // ─── Image Generation (Imagen 3) ───
  @override
  Future<Uint8List> generateImage(String prompt, {int width = 1024, int height = 1024}) async {
    final body = jsonEncode({
      'contents': [{'parts': [{'text': prompt}]}],
      'generationConfig': {'responseModalities': ['IMAGE', 'TEXT']},
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/gemini-2.0-flash-exp:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    final parts = json['candidates'][0]['content']['parts'] as List;
    for (final part in parts) {
      if (part['inline_data'] != null) {
        return base64Decode(part['inline_data']['data'] as String);
      }
    }
    return Uint8List(0);
  }

  // ─── Image Animation (Veo) ───
  @override
  Future<Uint8List> animateImage(Uint8List imageData, String motionPrompt) async {
    final body = jsonEncode({
      'contents': [{
        'parts': [
          {'text': motionPrompt},
          {'inline_data': {'mime_type': 'image/png', 'data': base64Encode(imageData)}},
        ],
      }],
      'generationConfig': {'responseModalities': ['VIDEO']},
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/veo-2.0-generate-001:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    final parts = json['candidates']?[0]?['content']?['parts'] as List? ?? [];
    for (final part in parts) {
      if (part['inline_data'] != null) {
        return base64Decode(part['inline_data']['data'] as String);
      }
    }
    return imageData;
  }

  // ─── Vision / Image Analysis ───
  @override
  Future<String> analyzeImage(Uint8List imageData, String question) async {
    final body = jsonEncode({
      'contents': [{
        'parts': [
          {'text': question},
          {'inline_data': {'mime_type': 'image/png', 'data': base64Encode(imageData)}},
        ],
      }],
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/gemini-2.0-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    return json['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  // ─── Speech-to-Text ───
  @override
  Future<String> transcribeAudio(Uint8List audioData, {String? language}) async {
    final body = jsonEncode({
      'contents': [{
        'parts': [
          {'text': 'Transcribe this audio${language != null ? " (language: $language)" : ""}:'},
          {'inline_data': {'mime_type': 'audio/wav', 'data': base64Encode(audioData)}},
        ],
      }],
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/gemini-2.0-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    return json['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  // ─── Speech Generation ───
  @override
  Future<Uint8List> generateSpeech(String text, {String? voice, String? language}) async {
    final body = jsonEncode({
      'contents': [{'parts': [{'text': text}]}],
      'generationConfig': {
        'responseModalities': ['AUDIO'],
        'speechConfig': {
          'voiceConfig': {'prebuiltVoiceConfig': {'voiceName': voice ?? 'Kore'}},
        },
      },
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/gemini-2.5-flash-preview-tts:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    final parts = json['candidates']?[0]?['content']?['parts'] as List? ?? [];
    for (final part in parts) {
      if (part['inline_data'] != null) {
        return base64Decode(part['inline_data']['data'] as String);
      }
    }
    return Uint8List(0);
  }

  // ─── Video Generation (Veo) ───
  @override
  Future<Uint8List> generateVideo(String prompt, {int durationSeconds = 10}) async {
    final body = jsonEncode({
      'contents': [{'parts': [{'text': prompt}]}],
      'generationConfig': {'responseModalities': ['VIDEO']},
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/veo-2.0-generate-001:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    final parts = json['candidates']?[0]?['content']?['parts'] as List? ?? [];
    for (final part in parts) {
      if (part['inline_data'] != null) {
        return base64Decode(part['inline_data']['data'] as String);
      }
    }
    return Uint8List(0);
  }

  // ─── Video Understanding ───
  @override
  Future<String> analyzeVideo(Uint8List videoData, String question) async {
    final body = jsonEncode({
      'contents': [{
        'parts': [
          {'text': question},
          {'inline_data': {'mime_type': 'video/mp4', 'data': base64Encode(videoData)}},
        ],
      }],
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/gemini-2.0-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    return json['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  // ─── Advanced Reasoning (Gemini 2.5 Pro with thinking) ───
  @override
  Future<String> reason(String prompt, {AIConfig? config}) async {
    final body = jsonEncode({
      'contents': [{'parts': [{'text': prompt}]}],
      'generationConfig': {
        'temperature': config?.temperature ?? 0.7,
        'thinkingConfig': {'thinkingBudget': 2048},
      },
    });
    final resp = await _client.post(
      Uri.parse('$_baseUrl/models/gemini-2.5-pro-preview-06-05:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final json = jsonDecode(resp.body);
    final parts = json['candidates'][0]['content']['parts'] as List;
    // Return the non-thought part
    for (final part in parts.reversed) {
      if (part['text'] != null && part['thought'] != true) {
        return part['text'] as String;
      }
    }
    return parts.last['text'] as String;
  }

  // ─── Fast Response (Flash) ───
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
