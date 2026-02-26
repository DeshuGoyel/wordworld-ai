import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/xp_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';

/// Story Writing Screen — guided creative writing prompts
class StoryWritingScreen extends ConsumerStatefulWidget {
  const StoryWritingScreen({super.key});
  @override ConsumerState<StoryWritingScreen> createState() => _StoryWritingScreenState();
}

class _StoryWritingScreenState extends ConsumerState<StoryWritingScreen> {
  int _promptIdx = 0;
  int _step = 0; // 0=pick prompt, 1=write, 2=done
  final _controller = TextEditingController();

  static const _prompts = [
    {'emoji': '🐕', 'title': 'My Pet Adventure', 'starter': 'One day, my pet dog ran away and went to...', 'tips': ['Who does your pet meet?', 'What happens next?', 'How does it end?']},
    {'emoji': '🚀', 'title': 'Space Journey', 'starter': 'I looked out the spaceship window and saw...', 'tips': ['What planet do you visit?', 'Who do you meet in space?', 'What do you bring back?']},
    {'emoji': '🏰', 'title': 'The Magic Castle', 'starter': 'Behind the old tree was a hidden castle where...', 'tips': ['Who lives in the castle?', 'What magic power does it have?', 'What adventure unfolds?']},
    {'emoji': '🌊', 'title': 'Under the Sea', 'starter': 'I could suddenly breathe underwater! I swam and found...', 'tips': ['What creatures do you see?', 'Do you find treasure?', 'How do you return to land?']},
    {'emoji': '🎪', 'title': 'The Circus Visit', 'starter': 'The circus tent was enormous. Inside I saw...', 'tips': ['What acts do you see?', 'Do you join any performance?', 'What is the most amazing thing?']},
    {'emoji': '🌈', 'title': 'Rainbow Land', 'starter': 'At the end of the rainbow, there was a magical land where...', 'tips': ['What colors is everything?', 'Who are the people there?', 'What special food is there?']},
    {'emoji': '🦕', 'title': 'Dinosaur Day', 'starter': 'I woke up and there was a baby dinosaur in my backyard! It...', 'tips': ['What type of dinosaur is it?', 'How do you take care of it?', 'Does anyone else find out?']},
    {'emoji': '🧙', 'title': 'The Wizard\'s Gift', 'starter': 'An old wizard gave me a special gift. It was...', 'tips': ['What power does it have?', 'How do you use it?', 'What lesson do you learn?']},
  ];

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            GestureDetector(onTap: () => context.pop(),
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.accent2.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.accent2))),
            const SizedBox(width: 12),
            Text('✍️ Story Writing', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 16),

          Expanded(child: _step == 0 ? _buildPromptPicker() : _step == 1 ? _buildWriter() : _buildDone()),
        ]))),
    );
  }

  Widget _buildPromptPicker() {
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Choose your story prompt:', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      ...List.generate(_prompts.length, (i) {
        final p = _prompts[i];
        return Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(onTap: () => setState(() { _promptIdx = i; _step = 1; }),
            child: Container(padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card,
                border: Border.all(color: AppColors.accent2.withValues(alpha: 0.2))),
              child: Row(children: [
                Text(p['emoji'] as String, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p['title'] as String, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(p['starter'] as String, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
                ])),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textMedium),
              ]))));
      }),
    ]));
  }

  Widget _buildWriter() {
    final p = _prompts[_promptIdx];
    final tips = p['tips'] as List<String>;
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.accent2, AppColors.accent2.withValues(alpha: 0.7)]),
          borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${p['emoji']} ${p['title']}', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(p['starter'] as String, style: GoogleFonts.nunito(fontSize: 14, color: Colors.white, fontStyle: FontStyle.italic)),
        ])),
      const SizedBox(height: 16),

      Text('💡 Writing Tips:', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
      ...tips.map((t) => Padding(padding: const EdgeInsets.only(top: 4),
        child: Row(children: [const Text('  • ', style: TextStyle(color: AppColors.accent2)),
          Expanded(child: Text(t, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)))]))),
      const SizedBox(height: 16),

      Container(padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
        child: TextField(controller: _controller, maxLines: 10, minLines: 6,
          decoration: InputDecoration(
            hintText: '${p['starter']}',
            hintStyle: GoogleFonts.nunito(fontSize: 14, color: AppColors.textLight),
            border: InputBorder.none, contentPadding: const EdgeInsets.all(16)),
          style: GoogleFonts.nunito(fontSize: 14, height: 1.8))),
      const SizedBox(height: 16),

      PrimaryButton(label: '✅ Submit My Story', onPressed: () {
        HapticFeedback.mediumImpact();
        ref.read(xpServiceProvider).addXP(20);
        setState(() => _step = 2);
      }),
    ]));
  }

  Widget _buildDone() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('🌟', style: TextStyle(fontSize: 60)),
      const SizedBox(height: 16),
      Text('Amazing Story!', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textDark)),
      const SizedBox(height: 8),
      Text('+20 XP earned!', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.accent2)),
      const SizedBox(height: 24),
      Container(width: double.infinity, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
        child: Text(_controller.text.isEmpty ? '(Your story here)' : _controller.text,
          style: GoogleFonts.nunito(fontSize: 14, height: 1.8, color: AppColors.textDark))),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: OutlinedButton(onPressed: () => setState(() { _step = 0; _controller.clear(); }),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: const BorderSide(color: AppColors.accent2)),
          child: Text('Write Another', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.accent2)))),
        const SizedBox(width: 12),
        Expanded(child: PrimaryButton(label: 'Done', onPressed: () => context.pop())),
      ]),
    ]));
  }
}
