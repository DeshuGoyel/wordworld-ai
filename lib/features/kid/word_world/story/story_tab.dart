import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../core/services/progress_service.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/app_providers.dart';
import '../../../../shared/widgets/shared_widgets.dart';

class StoryTab extends ConsumerStatefulWidget {
  final WordData word;
  const StoryTab({super.key, required this.word});
  @override
  ConsumerState<StoryTab> createState() => _StoryTabState();
}

class _StoryTabState extends ConsumerState<StoryTab> {
  int _currentScene = 0;
  bool _completed = false;
  bool _autoReading = false;

  List<_SimpleScene> get _scenes {
    if (widget.word.storyContent != null) {
      return widget.word.storyContent!.scenes.map((s) => _SimpleScene(s.textEn, s.textHi, s.backgroundDesc)).toList();
    }
    final w = widget.word;
    return [
      _SimpleScene('Once upon a time, there was a ${w.word}.', 'एक बार की बात है, एक ${w.wordHi} था।', 'meadow'),
      _SimpleScene('The ${w.word} was very special. ${w.description}.', '${w.wordHi} बहुत खास था। ${w.descriptionHi}।', 'garden'),
      _SimpleScene('One day, the ${w.word} went on an adventure!', 'एक दिन, ${w.wordHi} एक साहसिक यात्रा पर गया!', 'forest'),
      _SimpleScene('The ${w.word} made many friends along the way.', '${w.wordHi} ने रास्ते में बहुत सारे दोस्त बनाए।', 'village'),
      _SimpleScene('And they all lived happily ever after! The End. 🌟', 'और वे सब खुशी-खुशी रहने लगे! समाप्त। 🌟', 'sunset'),
    ];
  }

  final _bgColors = [
    [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)], // meadow
    [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)], // garden
    [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)], // forest
    [const Color(0xFFFCE4EC), const Color(0xFFF8BBD0)], // village
    [const Color(0xFFFFF9C4), const Color(0xFFFFECB3)], // sunset
  ];

  void _autoRead() async {
    if (_autoReading) return;
    setState(() => _autoReading = true);
    final tts = ref.read(ttsServiceProvider);

    for (int i = _currentScene; i < _scenes.length; i++) {
      if (!mounted || !_autoReading) return;
      setState(() => _currentScene = i);
      await tts.speakEnglish(_scenes[i].textEn);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted || !_autoReading) return;
      await tts.speakHindi(_scenes[i].textHi);
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    if (mounted) {
      setState(() { _completed = true; _autoReading = false; });
      ref.read(soundServiceProvider).playStarEarned();
      final child = ref.read(activeChildProvider);
      if (child != null) ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'story');
    }
  }

  @override
  void initState() {
    super.initState();
    // Auto-start reading after short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _autoRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressService = ref.read(progressServiceProvider);
    final child = ref.watch(activeChildProvider);
    final isUnlocked = child != null ? progressService.isStoryUnlocked(child.id, widget.word.letter) : false;

    if (!isUnlocked) {
      return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🔒', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text('Story Locked', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Learn 2 words in letter ${widget.word.letter} to unlock!',
          textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
        Text('कहानी अनलॉक करने के लिए 2 शब्द सीखें!',
          textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textLight)),
      ])));
    }

    if (_completed) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('📖', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text('Story Complete!', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800)),
        Text('कहानी पूरी!', style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(gradient: AppGradients.gold, borderRadius: BorderRadius.circular(20)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.star_rounded, color: Colors.white, size: 28),
            SizedBox(width: 6),
            Text('⭐ Star Earned!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          ]),
        ),
        const SizedBox(height: 24),
        DuoButton(text: '🔄 Read Again', width: 180, color: AppColors.storyTab, onPressed: () {
          setState(() { _currentScene = 0; _completed = false; });
          Future.delayed(const Duration(milliseconds: 300), _autoRead);
        }),
      ]));
    }

    final scene = _scenes[_currentScene];
    final bgIdx = _currentScene.clamp(0, _bgColors.length - 1);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        // ═══════ AI CINEMA HEADER ═══════
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.storyTab, AppColors.storyTab.withOpacity(0.6)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('📖 AI CINEMA', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.storyTab.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Text('Scene ${_currentScene + 1} of ${_scenes.length}', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.storyTab)),
          ),
        ]),
        const SizedBox(height: 12),
        // Progress
        Row(children: [
          Expanded(child: DuoProgressBar(progress: (_currentScene + 1) / _scenes.length, color: AppColors.storyTab)),
          const SizedBox(width: 8),
          Text('${_currentScene + 1}/${_scenes.length}', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMedium)),
        ]),
        const SizedBox(height: 16),

        // Scene card
        Expanded(child: GestureDetector(
          onTap: () => _nextScene(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: _bgColors[bgIdx]),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.storyTab.withOpacity(0.2), width: 2),
              boxShadow: AppShadows.soft(AppColors.storyTab),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(widget.word.emoji, style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 20),
              Text(scene.textEn, textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, height: 1.5, color: AppColors.textDark)),
              const SizedBox(height: 10),
              Text(scene.textHi, textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium, height: 1.4)),
              const Spacer(),
              if (_autoReading)
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.storyTab)),
                  const SizedBox(width: 8),
                  Text('Reading aloud...', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.storyTab)),
                ])
              else
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.touch_app_rounded, color: AppColors.storyTab.withOpacity(0.5), size: 20),
                  const SizedBox(width: 4),
                  Text('Tap to continue', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.storyTab.withOpacity(0.5))),
                ]),
            ]),
          ),
        )),

        const SizedBox(height: 12),
        // Audio controls
        Row(children: [
          Expanded(child: BounceWidget(
            onTap: () {
              final tts = ref.read(ttsServiceProvider);
              tts.speakEnglish(scene.textEn);
              Future.delayed(const Duration(milliseconds: 2000), () {
                if (mounted) tts.speakHindi(scene.textHi);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: AppGradients.sunset, borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft(AppColors.storyTab),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.volume_up_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text('Read Aloud 🔊', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          )),
          const SizedBox(width: 10),
          BounceWidget(
            onTap: _autoReading ? () => setState(() => _autoReading = false) : _autoRead,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _autoReading ? AppColors.error.withOpacity(0.1) : AppColors.storyTab.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (_autoReading ? AppColors.error : AppColors.storyTab).withOpacity(0.3)),
              ),
              child: Icon(_autoReading ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: _autoReading ? AppColors.error : AppColors.storyTab, size: 24),
            ),
          ),
        ]),
      ]),
    );
  }

  void _nextScene() {
    if (_currentScene < _scenes.length - 1) {
      setState(() => _currentScene++);
      final tts = ref.read(ttsServiceProvider);
      tts.speakEnglish(_scenes[_currentScene].textEn);
    } else {
      setState(() => _completed = true);
      ref.read(soundServiceProvider).playStarEarned();
      final child = ref.read(activeChildProvider);
      if (child != null) ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'story');
    }
  }
}

class _SimpleScene {
  final String textEn, textHi, bg;
  _SimpleScene(this.textEn, this.textHi, this.bg);
}
