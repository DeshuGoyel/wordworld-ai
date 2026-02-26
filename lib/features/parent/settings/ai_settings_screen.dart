import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/ai_provider.dart';

/// AI Settings screen — choose AI provider and configure API key.
class AISettingsScreen extends ConsumerStatefulWidget {
  const AISettingsScreen({super.key});

  @override
  ConsumerState<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends ConsumerState<AISettingsScreen> {
  AIProviderType _selectedProvider = AIProviderType.mock;
  final _apiKeyController = TextEditingController();
  bool _showApiKey = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final aiService = ref.read(aiServiceProvider);
      final storage = ref.read(storageServiceProvider);
      setState(() {
        _selectedProvider = aiService.providerType;
        _apiKeyController.text = storage.getSetting('ai_api_key') ?? '';
      });
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.1), AppColors.secondary.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Text('🤖', style: TextStyle(fontSize: 32)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Brain', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Choose your AI provider to power smart features',
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('Select Provider', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          // Provider cards
          _providerCard(
            AIProviderType.mock,
            '🎭', 'Mock AI (No API Key)',
            'Offline mode with simulated responses. Great for testing.',
            Colors.grey,
          ),
          _providerCard(
            AIProviderType.openai,
            '🟢', 'OpenAI',
            'GPT-4o, DALL-E 3, Whisper STT, TTS. Best all-around.',
            const Color(0xFF10A37F),
          ),
          _providerCard(
            AIProviderType.gemini,
            '🔵', 'Google Gemini',
            'Gemini Flash/Pro, Imagen 3, Veo, native TTS. Best for video & image.',
            const Color(0xFF4285F4),
          ),
          _providerCard(
            AIProviderType.anthropic,
            '🟠', 'Anthropic Claude',
            'Claude Sonnet/Haiku, Vision, Extended Thinking. Best for reasoning.',
            const Color(0xFFD97706),
          ),

          // API Key input (shown for non-mock providers)
          if (_selectedProvider != AIProviderType.mock) ...[
            const SizedBox(height: 24),
            const Text('API Key', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              obscureText: !_showApiKey,
              decoration: InputDecoration(
                hintText: 'Paste your API key here...',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: const Icon(Icons.key),
                suffixIcon: IconButton(
                  icon: Icon(_showApiKey ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _showApiKey = !_showApiKey),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getApiKeyHint(),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],

          const SizedBox(height: 32),

          // Save button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Save & Apply', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),

          const SizedBox(height: 24),

          // Features comparison
          _buildFeaturesComparison(),
        ],
      ),
    );
  }

  Widget _providerCard(AIProviderType type, String icon, String name, String desc, Color color) {
    final isSelected = _selectedProvider == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedProvider = type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? color : Colors.black87)),
                  Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }

  String _getApiKeyHint() {
    switch (_selectedProvider) {
      case AIProviderType.openai:
        return 'Get your key at platform.openai.com → API Keys';
      case AIProviderType.gemini:
        return 'Get your key at aistudio.google.com → Get API Key';
      case AIProviderType.anthropic:
        return 'Get your key at console.anthropic.com → API Keys';
      default:
        return '';
    }
  }

  Widget _buildFeaturesComparison() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Feature Comparison', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Table(
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1)},
            children: [
              _tableRow('Feature', 'OpenAI', 'Gemini', 'Claude', isHeader: true),
              _tableRow('Chat/Text', '✅', '✅', '✅'),
              _tableRow('Image Gen', '✅', '✅', '❌'),
              _tableRow('Vision', '✅', '✅', '✅'),
              _tableRow('STT', '✅', '✅', '❌'),
              _tableRow('TTS', '✅', '✅', '❌'),
              _tableRow('Video Gen', '❌', '✅', '❌'),
              _tableRow('Reasoning', '✅', '✅', '✅'),
              _tableRow('Animation', '❌', '✅', '❌'),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _tableRow(String feature, String a, String b, String c, {bool isHeader = false}) {
    final style = TextStyle(
      fontSize: 12,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: isHeader ? Colors.black87 : Colors.black54,
    );
    return TableRow(children: [
      Padding(padding: const EdgeInsets.all(4), child: Text(feature, style: style)),
      Padding(padding: const EdgeInsets.all(4), child: Text(a, style: style, textAlign: TextAlign.center)),
      Padding(padding: const EdgeInsets.all(4), child: Text(b, style: style, textAlign: TextAlign.center)),
      Padding(padding: const EdgeInsets.all(4), child: Text(c, style: style, textAlign: TextAlign.center)),
    ]);
  }

  void _saveSettings() {
    ref.read(aiServiceProvider).switchProvider(
      _selectedProvider,
      apiKey: _apiKeyController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI Provider set to ${_selectedProvider.name}'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.of(context).pop();
  }
}
