import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/widgets/tappable.dart';

/// AI Story Generator — dropdown-only (kid-safe) custom story builder
class AIStoryGeneratorScreen extends StatefulWidget {
  const AIStoryGeneratorScreen({super.key});
  @override
  State<AIStoryGeneratorScreen> createState() => _AIStoryGeneratorScreenState();
}

class _AIStoryGeneratorScreenState extends State<AIStoryGeneratorScreen> {
  String _hero = 'Bunny';
  String _setting = 'Forest';
  String _adventure = 'Finding treasure';
  String _language = 'English';
  bool _generating = false;
  List<_StoryScene>? _scenes;
  int _currentScene = 0;

  final _heroes = ['Bunny', 'Tiger', 'Princess', 'Robot', 'Dragon', 'Astronaut'];
  final _settings = ['Forest', 'Space', 'Ocean', 'Castle', 'School', 'Jungle'];
  final _adventures = ['Finding treasure', 'Making friends', 'Saving the world', 'Learning to fly', 'A magical journey', 'Solving a mystery'];
  final _languages = ['English', 'Hindi', 'Both'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Tappable(
                  onTap: () => context.pop(),
                  child: Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: AppColors.storyTab.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.arrow_back_rounded, color: AppColors.storyTab)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('AI Story Magic', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.storyTab)),
                  Text('Create your own story!', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppGradients.pinkPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('✨', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text('AI', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                  ]),
                ),
              ]),
            ),

            Expanded(
              child: _scenes != null ? _buildStoryView() : _buildCreator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreator() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration
          Center(child: Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFA29BFE), Color(0xFFFD79A8)]),
              shape: BoxShape.circle,
              boxShadow: AppShadows.glow(const Color(0xFFA29BFE)),
            ),
            child: const Center(child: Text('📖', style: TextStyle(fontSize: 48))),
          )),
          const SizedBox(height: 24),

          // Hero picker
          _dropdownSection('Who is the hero?', '🦸', _heroes, _hero, (v) => setState(() => _hero = v)),
          const SizedBox(height: 16),

          // Setting picker
          _dropdownSection('Where does it happen?', '🗺️', _settings, _setting, (v) => setState(() => _setting = v)),
          const SizedBox(height: 16),

          // Adventure picker
          _dropdownSection("What's the adventure?", '⚡', _adventures, _adventure, (v) => setState(() => _adventure = v)),
          const SizedBox(height: 16),

          // Language picker
          _dropdownSection('Language', '🌐', _languages, _language, (v) => setState(() => _language = v)),
          const SizedBox(height: 28),

          // Generate button
          PrimaryButton(
            label: '✨ Generate My Story',
            onPressed: _generateStory,
            isLoading: _generating,
            color: AppColors.storyTab,
          ),
        ],
      ),
    );
  }

  Widget _dropdownSection(String label, String emoji, List<String> options, String selected, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        ]),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: options.map((opt) {
            final isSelected = opt == selected;
            return Tappable(
              onTap: () => onChanged(opt),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.storyTab : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? AppColors.storyTab : AppColors.textLight.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Text(opt, style: GoogleFonts.nunito(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textDark,
                )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _generateStory() {
    setState(() => _generating = true);
    // Simulate AI generation
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _generating = false;
        _currentScene = 0;
        _scenes = [
          _StoryScene(text: 'Once upon a time, in a magical $_setting, there lived a brave $_hero.',
              emoji: '🌟', bgColor: const Color(0xFFA29BFE)),
          _StoryScene(text: 'One day, $_hero went on an adventure — $_adventure!',
              emoji: '⚡', bgColor: const Color(0xFFFD79A8)),
          _StoryScene(text: '$_hero met a friendly bird who said, "I will help you on your journey!"',
              emoji: '🐦', bgColor: const Color(0xFF00B894)),
          _StoryScene(text: 'Together, they crossed rivers and climbed mountains. $_hero was very brave!',
              emoji: '🏔️', bgColor: const Color(0xFF0984E3)),
          _StoryScene(text: 'Finally, $_hero succeeded! Everyone was happy. The End! 🎉',
              emoji: '🎊', bgColor: const Color(0xFFFF9F43)),
        ];
      });
    });
  }

  Widget _buildStoryView() {
    final scene = _scenes![_currentScene];
    return Column(
      children: [
        // Progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: DuoProgressBar(progress: (_currentScene + 1) / _scenes!.length, color: AppColors.storyTab),
        ),
        const SizedBox(height: 8),
        Text('Scene ${_currentScene + 1} of ${_scenes!.length}',
            style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [scene.bgColor, scene.bgColor.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.soft(scene.bgColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(scene.emoji, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 20),
                  Text(scene.text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Navigation
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Row(children: [
            if (_currentScene > 0)
              Expanded(child: PrimaryButton(
                label: '← Back',
                onPressed: () => setState(() => _currentScene--),
                color: AppColors.textMedium,
                fullWidth: false,
              ))
            else
              const Spacer(),
            const SizedBox(width: 12),
            Expanded(child: PrimaryButton(
              label: _currentScene == _scenes!.length - 1 ? '🎉 New Story' : 'Next →',
              onPressed: () {
                if (_currentScene == _scenes!.length - 1) {
                  setState(() => _scenes = null);
                } else {
                  setState(() => _currentScene++);
                }
              },
              color: AppColors.storyTab,
              fullWidth: false,
            )),
          ]),
        ),
      ],
    );
  }
}

class _StoryScene {
  final String text, emoji;
  final Color bgColor;
  const _StoryScene({required this.text, required this.emoji, required this.bgColor});
}
