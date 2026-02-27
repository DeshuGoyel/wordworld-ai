import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/tts_service.dart';
import 'package:learn_app/core/services/audio_service.dart';
import '../../../../core/services/progress_service.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/app_providers.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/widgets/tappable.dart';

class MeetTab extends ConsumerStatefulWidget {
  final WordData word;
  const MeetTab({super.key, required this.word});
  @override
  ConsumerState<MeetTab> createState() => _MeetTabState();
}

class _MeetTabState extends ConsumerState<MeetTab> {
  int _currentLine = 0;
  bool _completed = false;
  bool _playing = false;
  String _activeLang = 'en'; // 'en', 'hi', 'both'

  List<ScriptLine> get _lines {
    final child = ref.read(activeChildProvider);
    return (child?.ageBand ?? 1) == 1 ? widget.word.meetContent.linesYoung : widget.word.meetContent.linesOlder;
  }

  void _playScript() async {
    setState(() => _playing = true);
    
    for (int i = 0; i < _lines.length; i++) {
      if (!mounted) return;
      setState(() => _currentLine = i);

      if (_activeLang == 'hi') {
        await TTSService.instance.speak(_lines[i].textHi, lang: 'hi');
      } else {
        await TTSService.instance.speak(_lines[i].textEn);
      }
      await Future.delayed(const Duration(milliseconds: 1000));

      if (_activeLang == 'both' && mounted) {
        await TTSService.instance.speak(_lines[i].textHi, lang: 'hi');
        await Future.delayed(const Duration(milliseconds: 800));
      }
    }
    if (mounted) {
      setState(() { _completed = true; _playing = false; });
      AudioService.instance.play(SoundType.star);
      final child = ref.read(activeChildProvider);
      if (child != null) ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'meet');
    }
  }

  @override
  void initState() {
    super.initState();
    _activeLang = 'both';
    Future.delayed(const Duration(milliseconds: 500), _playScript);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // ═══════ BROADCAST HEADER WITH LIVE BADGE ═══════
        Stack(children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.meetTab.withValues(alpha: 0.1), AppColors.meetTab.withValues(alpha: 0.03)],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.meetTab.withValues(alpha: 0.15)),
            ),
            child: Column(children: [
              Text(widget.word.emoji, style: const TextStyle(fontSize: 100)),
              const SizedBox(height: 10),
              Text(widget.word.word.toUpperCase(), style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.meetTab)),
              Text(widget.word.wordHi, style: GoogleFonts.nunito(fontSize: 18, color: AppColors.textMedium)),
              const SizedBox(height: 4),
              Text(widget.word.description, textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
            ]),
          ),
          // LIVE badge
          if (_playing)
            Positioned(
              top: 10, left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: AppGradients.warm,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppShadows.soft(AppColors.secondary),
                ),
                child: Row(children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('LIVE', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
              ),
            ),
          // Language toggle
          Positioned(
            top: 10, right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12),
                boxShadow: AppShadows.soft(Colors.grey),
              ),
              child: Row(children: [
                _langBtn('EN', 'en'), _langBtn('HI', 'hi'), _langBtn('Both', 'both'),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 16),

        // ═══════ SCRIPT LINES (BROADCAST TICKER STYLE) ═══════
        ...List.generate(_lines.length, (i) {
          final line = _lines[i];
          final isCurrent = i == _currentLine;
          final isPast = i < _currentLine;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: isCurrent
                  ? LinearGradient(colors: [AppColors.meetTab.withValues(alpha: 0.12), AppColors.meetTab.withValues(alpha: 0.04)])
                  : null,
              color: isCurrent ? null : (isPast ? Colors.grey.shade50 : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCurrent ? AppColors.meetTab : Colors.grey.shade200,
                width: isCurrent ? 2 : 1,
              ),
              boxShadow: isCurrent ? AppShadows.soft(AppColors.meetTab) : [],
            ),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: line.speaker == 'character' ? AppColors.meetTab.withValues(alpha: 0.15) : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(line.speaker == 'character' ? widget.word.emoji : '📖', style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(line.textEn, style: GoogleFonts.nunito(
                  fontSize: 16, fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: isCurrent ? AppColors.meetTab : AppColors.textDark)),
                const SizedBox(height: 2),
                Text(line.textHi, style: GoogleFonts.nunito(
                  fontSize: 14, color: isCurrent ? AppColors.meetTab.withValues(alpha: 0.7) : AppColors.textMedium)),
              ])),
              if (isCurrent && _playing)
                SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.meetTab)),
              if (isPast)
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
            ]),
          );
        }),

        // ═══════ AI FUN FACT ═══════
        if (_completed) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.info.withValues(alpha: 0.08), AppColors.info.withValues(alpha: 0.02)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🤖', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('AI Fun Fact', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.info)),
                Text(_getFunFact(), style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600)),
              ])),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.success.withValues(alpha: 0.12), AppColors.success.withValues(alpha: 0.04)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.star_rounded, color: AppColors.starActive, size: 28),
              const SizedBox(width: 8),
              Text('⭐ Star Earned!', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.success)),
            ]),
          ),
        ],

        const SizedBox(height: 16),
        BounceWidget(
          onTap: () {
            setState(() { _currentLine = 0; _completed = false; });
            _playScript();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(gradient: AppGradients.warm, borderRadius: BorderRadius.circular(18), boxShadow: AppShadows.soft(AppColors.meetTab)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.replay_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text('Replay', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _langBtn(String label, String value) {
    final isActive = _activeLang == value;
    return Tappable(
      onTap: () => setState(() => _activeLang = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.meetTab : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: isActive ? Colors.white : AppColors.textMedium)),
      ),
    );
  }

  String _getFunFact() {
    final facts = {
      'Apple': 'Apples float in water because they are 25% air! 🍎',
      'Ant': 'Ants can carry 50 times their own body weight! 💪',
      'Airplane': 'The first airplane flight lasted only 12 seconds! ✈️',
      'Alligator': 'Alligators have been on Earth for 37 million years! 🐊',
      'Ball': 'The first basketballs were brown, not orange! 🏀',
      'Butterfly': 'Butterflies taste with their feet! 🦋',
      'Bear': 'A group of bears is called a sleuth! 🐻',
      'Bird': 'Some birds can sleep while flying! 🐦',
    };
    return facts[widget.word.word] ?? '${widget.word.word} is an amazing thing to learn about! 🌟';
  }
}
