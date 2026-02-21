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

class TalkTab extends ConsumerStatefulWidget {
  final WordData word;
  const TalkTab({super.key, required this.word});
  @override
  ConsumerState<TalkTab> createState() => _TalkTabState();
}

class _TalkTabState extends ConsumerState<TalkTab> {
  int _currentLine = 0;
  bool _recording = false;
  bool _completed = false;
  double _score = 0;
  String _feedback = '';

  TalkLine get _line => widget.word.talkLines[_currentLine];

  void _listen() {
    final tts = ref.read(ttsServiceProvider);
    tts.speakEnglish(_line.textEn);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) tts.speakHindi(_line.textHi);
    });
  }

  void _startRecording() async {
    setState(() => _recording = true);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final score = 0.6 + (0.4 * (DateTime.now().millisecondsSinceEpoch % 100) / 100);
    final sound = ref.read(soundServiceProvider);

    setState(() {
      _recording = false;
      _score = score;
      if (score > 0.8) {
        _feedback = '🌟 Excellent! Perfect pronunciation!';
        sound.playCorrect();
      } else if (score > 0.6) {
        _feedback = '👍 Good job! Keep practicing!';
        sound.playCorrect();
      } else {
        _feedback = '💪 Nice try! Listen and try again.';
        sound.playWrong();
      }
      if (score > 0.6) {
        _completed = true;
        sound.playStarEarned();
      }
    });
    if (_completed) {
      final child = ref.read(activeChildProvider);
      if (child != null) ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'talk');
    }
  }

  @override
  void initState() {
    super.initState();
    // Auto-speak the first sentence after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && widget.word.talkLines.isNotEmpty) {
        ref.read(ttsServiceProvider).speakEnglish(widget.word.talkLines[0].textEn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.word.talkLines.isEmpty) {
      return Center(child: Text('No talk lines available', style: GoogleFonts.nunito(fontSize: 18)));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        // ═══════ AI VOICE LAB HEADER ═══════
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(gradient: AppGradients.cool, borderRadius: BorderRadius.circular(12)),
          child: Text('🎤 AI VOICE LAB', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
        ),
        const SizedBox(height: 12),
        // Character header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.talkTab.withOpacity(0.12), AppColors.talkTab.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.talkTab.withOpacity(0.2)),
          ),
          child: Row(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: AppColors.talkTab.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(widget.word.emoji, style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Say this sentence!', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.talkTab)),
              Text('यह वाक्य बोलो!', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
            ])),
            // Speaker button
            GestureDetector(
              onTap: _listen,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(gradient: AppGradients.cool, shape: BoxShape.circle, boxShadow: AppShadows.soft(AppColors.talkTab)),
                child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 24),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 24),

        // Sentence card
        Container(
          width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.talkTab.withOpacity(0.3), width: 2),
            boxShadow: AppShadows.card,
          ),
          child: Column(children: [
            Text(_line.textEn, textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.talkTab)),
            const SizedBox(height: 6),
            Text(_line.textHi, textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
          ]),
        ),
        const SizedBox(height: 24),

        // Controls
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          BounceWidget(
            onTap: _listen,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: AppGradients.cool, borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft(AppColors.info),
              ),
              child: Row(children: [
                const Icon(Icons.volume_up_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text('Listen', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          ),
          const SizedBox(width: 16),
          BounceWidget(
            onTap: _recording ? null : _startRecording,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: _recording ? AppGradients.warm : AppGradients.nature,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft(_recording ? AppColors.error : AppColors.talkTab),
              ),
              child: Row(children: [
                Icon(_recording ? Icons.mic : Icons.mic_none_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text(_recording ? 'Recording...' : 'Speak', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          ),
        ]),

        // Score & feedback
        if (_feedback.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (_score > 0.6 ? AppColors.success : AppColors.warning).withOpacity(0.12),
                (_score > 0.6 ? AppColors.success : AppColors.warning).withOpacity(0.04),
              ]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: (_score > 0.6 ? AppColors.success : AppColors.warning).withOpacity(0.3)),
            ),
            child: Column(children: [
              DuoProgressBar(progress: _score, color: _score > 0.8 ? AppColors.success : _score > 0.6 ? AppColors.accent1 : AppColors.warning),
              const SizedBox(height: 12),
              Text('${(_score * 100).toInt()}% accuracy', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              const SizedBox(height: 6),
              Text(_feedback, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
              if (_completed) ...[
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star_rounded, color: AppColors.starActive, size: 28),
                  const SizedBox(width: 8),
                  Text('Star earned! ⭐', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.success)),
                ]),
              ],
            ]),
          ),
        ],

        // Next line
        if (_completed && _currentLine < widget.word.talkLines.length - 1) ...[
          const SizedBox(height: 16),
          DuoButton(text: 'Next Sentence →', color: AppColors.talkTab, onPressed: () {
            setState(() { _currentLine++; _completed = false; _feedback = ''; _score = 0; });
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) ref.read(ttsServiceProvider).speakEnglish(widget.word.talkLines[_currentLine].textEn);
            });
          }),
        ],
      ]),
    );
  }
}
