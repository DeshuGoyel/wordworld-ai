import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/models.dart' hide StoryScene;
import '../../../../providers/app_providers.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/services/audio_service.dart';
import 'package:learn_app/core/services/tts_service.dart';
import 'package:learn_app/core/services/progress_service.dart';
import 'package:learn_app/core/models/story_models.dart';
import 'package:learn_app/core/widgets/tappable.dart';

class StoryPlayerScreen extends ConsumerStatefulWidget {
  final StoryData story;
  final WordData word;

  const StoryPlayerScreen({super.key, required this.story, required this.word});

  @override
  ConsumerState<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends ConsumerState<StoryPlayerScreen> {
  int _currentScene = 0;
  bool _choiceSelected = false;
  bool _isReading = false;
  bool _storyComplete = false;
  late ConfettiController _confetti;

  StoryScene get currentScene => widget.story.scenes[_currentScene];
  bool get _isLastScene => _currentScene == widget.story.scenes.length - 1;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    
    // Auto-start reading scene 1
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _toggleReading();
    });
  }

  @override
  void dispose() {
    TTSService.instance.stop();
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _toggleReading() async {
    final languageMode = ref.read(activeChildProvider)?.languageMode ?? 'both';

    if (_isReading) {
      await TTSService.instance.stop();
      if (mounted) setState(() => _isReading = false);
    } else {
      if (mounted) setState(() => _isReading = true);
      
      await TTSService.instance.speak(currentScene.textEn, lang: 'en');
      
      if (languageMode == 'both' || languageMode == 'hi') {
          // Speak Hindi specifically if mode is both or hi
          // In a real approach, we might need a callback or sequence here.
          // For now, we trust speak to block/queue correctly.
          if (mounted && _isReading) {
             await TTSService.instance.speak(currentScene.textHi, lang: 'hi');
          }
      }
      
      if (mounted) setState(() => _isReading = false);
    }
  }

  void _selectChoice(String choice) {
    setState(() {
      _choiceSelected = true;
      _selectedChoice = choice;
    });
    AudioService.instance.play(SoundType.correct);
    HapticFeedback.mediumImpact();
    TTSService.instance.speak('Great choice! Let\'s see what happens!');
  }

  Future<void> _nextScene() async {
    await TTSService.instance.stop();
    if (_currentScene < widget.story.scenes.length - 1) {
      setState(() {
        _currentScene++;
        _choiceSelected = false;
        _isReading = false;
      });
      // Auto-read next scene
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _toggleReading();
      });
    }
  }

  void _completeStory() {
    AudioService.instance.play(SoundType.star);
    HapticFeedback.heavyImpact();
    
    final child = ref.read(activeChildProvider);
    if (child != null) {
      ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'story');
    }
    
    setState(() => _storyComplete = true);
    _confetti.play();
    TTSService.instance.speak(widget.story.moralEn);
  }

  void _shareStory() {
    final childName = ref.read(activeChildProvider)?.name ?? 'Friend';
    final shareText = '''
🦉 WordWorld AI Story!

📖 ${widget.story.title}

${widget.story.scenes.map((s) => '• ${s.textEn}').join('\n')}

💡 Lesson: ${widget.story.moralEn}

Created for $childName with WordWorld AI 🌟
''';
    Share.share(shareText, subject: widget.story.title);
  }

  List<Color> _getThemeColors(String emotion) {
    switch (emotion) {
      case 'happy':     return [const Color(0xFFFFF9E6), const Color(0xFFFFFCE8)];
      case 'excited':   return [const Color(0xFFE8F5FF), const Color(0xFFF0ECFF)];
      case 'sad':       return [const Color(0xFFE8F0FF), const Color(0xFFEEF2FF)];
      case 'thinking':  return [const Color(0xFFF5E6FF), const Color(0xFFEEE6FF)];
      case 'proud':     return [const Color(0xFFE6FFE8), const Color(0xFFEEFFF0)];
      default:          return [const Color(0xFFF4F7FB), const Color(0xFFFFFFFF)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getThemeColors(currentScene.emotion);
    final languageMode = ref.watch(activeChildProvider)?.languageMode ?? 'both';

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // TOP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Tappable(
                        onTap: () {
                          TTSService.instance.stop();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.soft(Colors.grey)),
                          child: const Icon(Icons.arrow_back_rounded, color: AppColors.textMedium),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Dots
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.story.scenes.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentScene == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentScene >= index ? AppColors.storyTab : AppColors.storyTab.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(currentScene.gyaniEmoji, style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                ),

                // SCENE DISPLAY
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: ListView(
                      key: ValueKey(_currentScene),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      children: [
                        // Gyani Giant Emoji
                        Center(
                          child: Text(currentScene.gyaniEmoji, style: const TextStyle(fontSize: 80))
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .moveY(begin: -5, end: 5, duration: 2000.ms, curve: Curves.easeInOut),
                        ),
                        const SizedBox(height: 24),
                        
                        // Glass text card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(currentScene.textEn, style: AppFonts.bodyStyle(size: 16).copyWith(fontSize: 18)),
                              if (languageMode == 'both' || languageMode == 'hi') ...[
                                const SizedBox(height: 12),
                                Text(currentScene.textHi, style: AppFonts.bodyStyle(size: 16).copyWith(color: AppColors.textMedium, fontSize: 16)),
                              ]
                            ],
                          ),
                        ),

                        // CHOICE UI
                        if (currentScene.hasChoice && currentScene.choice != null && !_choiceSelected) ...[
                          const SizedBox(height: 32),
                          Text(currentScene.choice!.questionEn, style: AppFonts.headingStyle(size: 24), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton3D(
                                  label: currentScene.choice!.optionAEn,
                                  onTap: () => _selectChoice('A'),
                                  
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PrimaryButton3D(
                                  label: currentScene.choice!.optionBEn,
                                  onTap: () => _selectChoice('B'),
                                  solidColor: AppColors.secondary,
                                  
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),

                // BOTTOM NAV
                if (!_storyComplete)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Tappable(
                          onTap: _toggleReading,
                          child: Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.soft(Colors.grey)),
                            child: Icon(_isReading ? Icons.pause_rounded : Icons.volume_up_rounded, color: AppColors.primary, size: 32),
                          ),
                        ),
                        const Spacer(),
                        if (!currentScene.hasChoice || _choiceSelected)
                          PrimaryButton3D(
                            label: _isLastScene ? 'Finish Story! 🎉' : 'Next ▶',
                            onTap: _isLastScene ? _completeStory : _nextScene,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // COMPLETE OVERLAY
          if (_storyComplete)
            Positioned.fill(
              child: Container(
                color: Colors.black87,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confetti,
                        blastDirectionality: BlastDirectionality.explosive,
                        emissionFrequency: 0.05,
                        numberOfParticles: 20,
                        colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🦉🌟', style: TextStyle(fontSize: 80)).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
                            const SizedBox(height: 16),
                            const Text('Amazing! Story Complete!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
                                .animate(delay: 300.ms).fadeIn().slideY(),
                            const SizedBox(height: 32),
                            
                            // Moral Card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  Text("💡 ${widget.story.moralEn}", style: AppFonts.bodyStyle(size: 16), textAlign: TextAlign.center),
                                  const SizedBox(height: 8),
                                  Text("💡 ${widget.story.moralHi}", style: AppFonts.bodyStyle(size: 16).copyWith(color: AppColors.textMedium), textAlign: TextAlign.center),
                                ],
                              ),
                            ).animate(delay: 600.ms).scale(),

                            const SizedBox(height: 48),
                            PrimaryButton3D(
                              label: 'Read Again 🔄',
                              onTap: () {
                                setState(() {
                                  _storyComplete = false;
                                  _currentScene = 0;
                                  _choiceSelected = false;
                                });
                                Future.delayed(const Duration(milliseconds: 300), _toggleReading);
                              },
                              solidColor: AppColors.secondary,
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton3D(
                              label: 'Share Story 📤',
                              onTap: _shareStory,
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton3D(
                              label: 'Return Home 🏠',
                              onTap: () => Navigator.pop(context),
                              solidColor: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
