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
  String _liveText = '';

  TalkLine get _line => widget.word.talkLines[_currentLine];

  void _listen() {
    TTSService.instance.speak(_line.textEn);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) TTSService.instance.speak(_line.textHi, lang: 'hi');
    });
  }

  @override
  void initState() {
    super.initState();
    // Pre-initialize STT
    Future.microtask(() => ref.read(sttServiceProvider).initialize());

    // Auto-speak the first sentence after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && widget.word.talkLines.isNotEmpty) {
        TTSService.instance.speak('Try again', lang: 'hi');
      }
    });
  }

  void _toggleRecording() async {
    final stt = ref.read(sttServiceProvider);
    
    if (_recording) {
       await stt.stopListening();
       setState(() {
         _recording = false;
         _processSpeech(_liveText);
       });
    } else {
       setState(() {
         _recording = true;
         _liveText = '';
         _feedback = 'Listening...';
       });
       await stt.startListening((text) {
          if (mounted) {
            setState(() {
               _liveText = text;
            });
          }
       });
    }
  }

  void _processSpeech(String text) {
    if (text.isEmpty) {
       setState(() {
         _score = 0;
         _feedback = "I didn't hear anything. Try again! 🎤";
         AudioService.instance.play(SoundType.wrong);
       });
       return;
    }

    final stt = ref.read(sttServiceProvider);
    final result = stt.gradePronunciationLive(_line.textEn, text);
    final score = result['score'] as double;
    final fb = result['feedback'] as String;

    setState(() {
      _score = score;
      _feedback = fb;
      
      if (score >= 0.8) {
        AudioService.instance.play(SoundType.correct);
      } else if (score >= 0.5) {
        AudioService.instance.play(SoundType.correct);
      } else {
        AudioService.instance.play(SoundType.wrong);
      }
      
      if (score >= 0.5) {
        _completed = true;
        AudioService.instance.play(SoundType.star);
        final child = ref.read(activeChildProvider);
        if (child != null) {
          ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'talk');
        }
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
            gradient: LinearGradient(colors: [AppColors.talkTab.withValues(alpha: 0.12), AppColors.talkTab.withValues(alpha: 0.04)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.talkTab.withValues(alpha: 0.2)),
          ),
          child: Row(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: AppColors.talkTab.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(widget.word.emoji, style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Say this sentence!', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.talkTab)),
              Text('यह वाक्य बोलो!', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
            ])),
            // Speaker button
            Tappable(
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
            border: Border.all(color: AppColors.talkTab.withValues(alpha: 0.3), width: 2),
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
            onTap: _completed ? null : _toggleRecording,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: _recording ? AppGradients.warm : AppGradients.nature,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft(_recording ? AppColors.error : AppColors.talkTab),
              ),
              child: Row(children: [
                Icon(_recording ? Icons.stop_rounded : Icons.mic_none_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text(_recording ? 'Stop' : 'Speak', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          ),
        ]),

        // Live text
        if (_recording && _liveText.isNotEmpty) ...[
           const SizedBox(height: 16),
           Text('"${_liveText}"', style: GoogleFonts.nunito(fontSize: 18, fontStyle: FontStyle.italic, color: AppColors.textMedium)),
        ],

        // Score & feedback
        if (_feedback.isNotEmpty && !_recording) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (_score > 0.5 ? AppColors.success : AppColors.warning).withValues(alpha: 0.12),
                (_score > 0.5 ? AppColors.success : AppColors.warning).withValues(alpha: 0.04),
              ]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: (_score > 0.5 ? AppColors.success : AppColors.warning).withValues(alpha: 0.3)),
            ),
            child: Column(children: [
              DuoProgressBar(progress: _score, color: _score > 0.8 ? AppColors.success : _score > 0.5 ? AppColors.accent1 : AppColors.warning),
              const SizedBox(height: 12),
              Text('${(_score * 100).toInt()}% accuracy', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              const SizedBox(height: 6),
              if (_liveText.isNotEmpty)
                 Text('You said: "$_liveText"\n', textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 14, fontStyle: FontStyle.italic)),
              Text(_feedback, textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
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
            setState(() { _currentLine++; _completed = false; _feedback = ''; _score = 0; _liveText = ''; });
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) TTSService.instance.speak('Try again', lang: 'hi');
            });
          }),
        ],
      ]),
    );
  }
}
