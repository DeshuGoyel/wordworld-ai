import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/progress_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/models/models.dart';
import '../../../data/seed/content_seed.dart';
import '../../../providers/app_providers.dart';
import '../../../shared/widgets/shared_widgets.dart';
import 'meet/meet_tab.dart';
import 'think/think_tab.dart';
import 'talk/talk_tab.dart';
import 'write/write_tab.dart';
import 'draw/draw_tab.dart';
import 'story/story_tab.dart';

class WordWorldScreen extends ConsumerStatefulWidget {
  final String wordId;
  const WordWorldScreen({super.key, required this.wordId});
  @override
  ConsumerState<WordWorldScreen> createState() => _WordWorldScreenState();
}

class _WordWorldScreenState extends ConsumerState<WordWorldScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late WordData _word;

  @override
  void initState() {
    super.initState();
    _word = ContentSeed.getWordById(widget.wordId) ?? ContentSeed.getAllActiveWords().first;
    final child = ref.read(activeChildProvider);
    final showTalk = (child?.age ?? 3) >= AppConstants.talkTabMinAge;
    final tabCount = showTalk ? 6 : 5;
    _tabController = TabController(length: tabCount, vsync: this);

    // Speak word name on entry
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) ref.read(ttsServiceProvider).speakEnglish('Welcome to ${_word.word}!');
    });
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final child = ref.watch(activeChildProvider);
    final showTalk = (child?.age ?? 3) >= AppConstants.talkTabMinAge;
    final letterColor = AppColors.letterColors[_word.letter] ?? AppColors.primary;
    final progress = ref.read(progressServiceProvider);
    final wp = child != null ? progress.getProgress(child.id, _word.id) : null;
    final knowledgePercent = wp != null ? (wp.totalStars / 6 * 100).clamp(0, 100).toInt() : 0;

    final tabs = <_TabInfo>[
      _TabInfo('Meet', '🎬', AppColors.meetTab, wp?.meetCompleted ?? false),
      _TabInfo('Think', '🧠', AppColors.thinkTab, (wp?.thinkStars ?? 0) > 0),
      if (showTalk) _TabInfo('Talk', '🎤', AppColors.talkTab, wp?.talkCompleted ?? false),
      _TabInfo('Write', '✍️', AppColors.writeTab, wp?.writeCompleted ?? false),
      _TabInfo('Draw', '🎨', AppColors.drawTab, wp?.drawCompleted ?? false),
      _TabInfo('Story', '📖', AppColors.storyTab, wp?.storyCompleted ?? false),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(children: [
          // ═══════ AI-FEEL HEADER ═══════
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [letterColor.withValues(alpha: 0.08), AppColors.bgLight],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
            ),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(width: 40, height: 40,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.soft(Colors.grey)),
                    child: const Icon(Icons.arrow_back_rounded, size: 20)),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [letterColor.withValues(alpha: 0.15), letterColor.withValues(alpha: 0.05)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: letterColor.withValues(alpha: 0.3)),
                  ),
                  child: Center(child: Text(_word.emoji, style: const TextStyle(fontSize: 32))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_word.word.toUpperCase(), style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w900, color: letterColor)),
                  Text(_word.wordHi, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                ])),
                // Knowledge bar
                Column(children: [
                  Text('Knowledge', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                  const SizedBox(height: 2),
                  Container(
                    width: 60, height: 8,
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: knowledgePercent / 100,
                      child: Container(decoration: BoxDecoration(gradient: AppGradients.nature, borderRadius: BorderRadius.circular(4))),
                    ),
                  ),
                  Text('$knowledgePercent%', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w800, color: letterColor)),
                ]),
              ]),
            ]),
          ),

          // ═══════ AI NEURAL NETWORK TAB NODES ═══════
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(tabs.length * 2 - 1, (idx) {
                if (idx.isOdd) {
                  // Connecting line
                  final leftDone = tabs[idx ~/ 2].completed;
                  final rightDone = tabs[(idx ~/ 2) + 1].completed;
                  return Container(
                    width: 16, height: 3,
                    decoration: BoxDecoration(
                      gradient: leftDone && rightDone
                          ? LinearGradient(colors: [tabs[idx ~/ 2].color, tabs[(idx ~/ 2) + 1].color])
                          : null,
                      color: leftDone && rightDone ? null : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }
                final tabIdx = idx ~/ 2;
                final tab = tabs[tabIdx];
                final isSelected = _tabController.index == tabIdx;
                return GestureDetector(
                  onTap: () => _tabController.animateTo(tabIdx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isSelected ? 52 : 42,
                    height: isSelected ? 52 : 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected ? LinearGradient(colors: [tab.color, tab.color.withValues(alpha: 0.7)]) : null,
                      color: isSelected ? null : (tab.completed ? tab.color.withValues(alpha: 0.12) : Colors.grey.shade100),
                      border: Border.all(
                        color: tab.completed ? tab.color : (isSelected ? tab.color : Colors.grey.shade300),
                        width: isSelected ? 3 : (tab.completed ? 2 : 1.5),
                      ),
                      boxShadow: isSelected ? AppShadows.soft(tab.color) : [],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(tab.emoji, style: TextStyle(fontSize: isSelected ? 18 : 14)),
                      if (isSelected)
                        Text(tab.label, style: GoogleFonts.nunito(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
                      if (!isSelected && tab.completed)
                        Icon(Icons.check_circle_rounded, size: 10, color: tab.color),
                    ]),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 4),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                MeetTab(word: _word),
                ThinkTab(word: _word),
                if (showTalk) TalkTab(word: _word),
                WriteTab(word: _word),
                DrawTab(word: _word),
                StoryTab(word: _word),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _TabInfo {
  final String label, emoji;
  final Color color;
  final bool completed;
  _TabInfo(this.label, this.emoji, this.color, this.completed);
}
