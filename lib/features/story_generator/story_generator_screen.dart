import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/app_providers.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/services/story_service.dart';
import 'package:learn_app/core/widgets/tappable.dart';
import 'story_player_screen.dart';

class StoryGeneratorScreen extends ConsumerStatefulWidget {
  final WordData word; // hero word
  const StoryGeneratorScreen({super.key, required this.word});

  @override
  ConsumerState<StoryGeneratorScreen> createState() => _StoryGeneratorScreenState();
}

class _StoryGeneratorScreenState extends ConsumerState<StoryGeneratorScreen> {
  String _selectedSetting = 'forest';
  String _selectedProblem = 'lost';
  bool _isGenerating = false;
  String _loadingMessage = '✨ Gyani is thinking...';
  Timer? _loadingTimer;
  int _loadingIndex = 0;

  final _settings = [
    ('forest', 'Magical Forest 🌲'),
    ('city',   'Busy City 🏙️'),
    ('beach',  'Sunny Beach 🏖️'),
    ('space',  'Outer Space 🚀'),
    ('farm',   'Happy Farm 🌻'),
    ('ocean',  'Deep Ocean 🌊'),
  ];

  final _problems = [
    ('lost',    'Got Lost 🗺️'),
    ('scared',  'Feeling Scared 😨'),
    ('alone',   'Needs a Friend 🤝'),
    ('hungry',  'Very Hungry 🍽️'),
    ('big_test','Has a Big Test 📝'),
    ('missing', 'Missing Something 🔍'),
  ];

  final _loadingMessages = [
    '✨ Gyani is thinking...',
    '📖 Writing the story...',
    '🎨 Adding magic...',
    '🌟 Almost ready...',
    '🦉 Putting in surprises...',
  ];

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  void _startLoadingMessages() {
    _loadingIndex = 0;
    _loadingMessage = _loadingMessages[0];
    _loadingTimer?.cancel();
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) return;
      setState(() {
        _loadingIndex = (_loadingIndex + 1) % _loadingMessages.length;
        _loadingMessage = _loadingMessages[_loadingIndex];
      });
    });
  }

  void _stopLoadingMessages() {
    _loadingTimer?.cancel();
  }

  Future<void> _generate() async {
    final child = ref.read(activeChildProvider);
    
    setState(() => _isGenerating = true);
    _startLoadingMessages();
    
    final story = await StoryService.instance.generateStory(
      heroName: widget.word.word,
      heroEmoji: widget.word.emoji,
      setting: _settings.firstWhere((e) => e.$1 == _selectedSetting).$2,
      problem: _problems.firstWhere((e) => e.$1 == _selectedProblem).$2,
      childName: child?.name ?? 'Friend',
      languageMode: child?.languageMode ?? 'both',
      ageBand: child?.ageBand.toString() ?? '1',
    );
    
    _stopLoadingMessages();
    
    if (mounted) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(
          builder: (_) => StoryPlayerScreen(
            story: story,
            word: widget.word,
          ),
        ),
      );
      // Removed setState(_isGenerating = false) since we replaced the route
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          // Background blobs
          Positioned(top: -100, left: -50, child: _buildBlob(AppColors.storyTab.withOpacity(0.2), 300)),
          Positioned(bottom: -50, right: -50, child: _buildBlob(AppColors.primary.withOpacity(0.15), 250)),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Tappable(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.soft(Colors.grey)),
                          child: const Icon(Icons.arrow_back_rounded, color: AppColors.textMedium),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text('Create Story', style: AppFonts.headingStyle(size: 24)),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // GYANI at top
                        Text('🦉', style: TextStyle(fontSize: 72))
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .moveY(begin: -5, end: 5, duration: 1500.ms, curve: Curves.easeInOut),
                        const SizedBox(height: 8),
                        Text('Let\'s write a story! ✨', style: AppFonts.headingStyle(size: 24).copyWith(color: AppColors.primary)),
                        Text('Choose what happens!', style: AppFonts.bodyStyle(size: 16).copyWith(color: AppColors.textMedium)),
                        const SizedBox(height: 24),

                        // HERO DISPLAY
                        WordCard3D(
                          word: widget.word.word,
                          wordHindi: widget.word.wordHi,
                          emoji: widget.word.emoji,
                          cardColor: AppColors.storyTab,
                        ),
                        const SizedBox(height: 8),
                        Text('${widget.word.word} will be the hero!', style: AppFonts.bodyStyle(size: 14)),
                        const SizedBox(height: 32),

                        // SETTING SELECTION
                        Align(alignment: Alignment.centerLeft, child: Text('📍 Where does the story happen?', style: AppFonts.headingStyle(size: 20))),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12, runSpacing: 12,
                          children: _settings.map((s) => _SelectionChip(
                            label: s.$2, 
                            selected: _selectedSetting == s.$1,
                            onTap: _isGenerating ? null : () => setState(() => _selectedSetting = s.$1),
                            color: AppColors.storyTab,
                          )).toList(),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // PROBLEM SELECTION
                        Align(alignment: Alignment.centerLeft, child: Text('⚡ What is the problem?', style: AppFonts.headingStyle(size: 20))),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12, runSpacing: 12,
                          children: _problems.map((p) => _SelectionChip(
                            label: p.$2, 
                            selected: _selectedProblem == p.$1,
                            onTap: _isGenerating ? null : () => setState(() => _selectedProblem = p.$1),
                            color: AppColors.primary,
                          )).toList(),
                        ),

                        const SizedBox(height: 48),

                        // GENERATE BUTTON
                        if (_isGenerating)
                          Column(
                            children: [
                              Text('🦉', style: TextStyle(fontSize: 48)).animate(onPlay: (c) => c.repeat()).shake(hz: 3),
                              const SizedBox(height: 12),
                              Text(_loadingMessage, style: AppFonts.headingStyle(size: 20).copyWith(color: AppColors.textMedium))
                                .animate(key: ValueKey(_loadingMessage)).fadeIn().slideY(begin: 0.2, end: 0),
                            ],
                          )
                        else
                          PrimaryButton3D(
                            label: 'Create My Story! 🚀',
                            onTap: () => _generate(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SelectionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color color;

  const _SelectionChip({required this.label, required this.selected, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.grey.shade300, width: 2),
          boxShadow: selected ? AppShadows.soft(color) : [],
        ),
        child: Text(
          label,
          style: AppFonts.bodyStyle(size: 16).copyWith(
            color: selected ? Colors.white : AppColors.textMedium,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
