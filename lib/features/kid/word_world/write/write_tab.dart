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

class WriteTab extends ConsumerStatefulWidget {
  final WordData word;
  const WriteTab({super.key, required this.word});
  @override
  ConsumerState<WriteTab> createState() => _WriteTabState();
}

class _WriteTabState extends ConsumerState<WriteTab> {
  List<Offset?> _points = [];
  int _currentLetterIdx = 0;
  bool _completed = false;
  bool _showDots = true;

  String get _currentChar {
    final letters = widget.word.writeContent.letters;
    if (_currentLetterIdx < letters.length) return letters[_currentLetterIdx];
    return widget.word.writeContent.word;
  }

  bool get _isWordPhase => _currentLetterIdx >= widget.word.writeContent.letters.length;

  @override
  void initState() {
    super.initState();
    // Speak what to trace
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final tts = ref.read(ttsServiceProvider);
        tts.speakEnglish('Trace the letter ${widget.word.writeContent.letters.isNotEmpty ? widget.word.writeContent.letters[0] : widget.word.word}');
      }
    });
  }

  void _clear() => setState(() => _points = []);

  void _done() {
    if (_points.length < 10) {
      ref.read(soundServiceProvider).playWrong();
      ref.read(ttsServiceProvider).speakEnglish('Keep tracing! You need more strokes.');
      return;
    }
    final sound = ref.read(soundServiceProvider);
    final tts = ref.read(ttsServiceProvider);

    if (_isWordPhase) {
      setState(() => _completed = true);
      sound.playStarEarned();
      tts.speakEnglish('Great writing! You earned a star!');
      final child = ref.read(activeChildProvider);
      if (child != null) ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'write');
    } else {
      sound.playCorrect();
      setState(() { _currentLetterIdx++; _points = []; });
      // Speak next letter
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          if (_isWordPhase) {
            tts.speakEnglish('Now trace the whole word: ${widget.word.word}');
          } else {
            tts.speakEnglish('Trace the letter $_currentChar');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) return _buildComplete();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        // ═══════ AI WRITING STUDIO HEADER ═══════
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(gradient: AppGradients.nature, borderRadius: BorderRadius.circular(12)),
          child: Text('✍️ AI WRITING STUDIO', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
        ),
        const SizedBox(height: 12),
        // Instruction
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.writeTab.withOpacity(0.12), AppColors.writeTab.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.writeTab.withOpacity(0.2)),
          ),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: AppColors.writeTab.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(widget.word.emoji, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_isWordPhase ? 'Trace the word!' : 'Trace letter $_currentChar',
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.writeTab)),
              Text(_isWordPhase ? 'शब्द लिखो!' : 'अक्षर $_currentChar लिखो',
                style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
            ])),
            // Speaker
            GestureDetector(
              onTap: () => ref.read(ttsServiceProvider).speakEnglish(_isWordPhase ? 'Trace the word ${widget.word.word}' : 'Trace the letter $_currentChar'),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppColors.writeTab.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.volume_up_rounded, color: AppColors.writeTab, size: 22),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10),

        // Progress
        Row(children: [
          Expanded(child: DuoProgressBar(
            progress: (_currentLetterIdx + 1) / (widget.word.writeContent.letters.length + 1),
            color: AppColors.writeTab,
          )),
          const SizedBox(width: 8),
          Text('${_currentLetterIdx + 1}/${widget.word.writeContent.letters.length + 1}',
            style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMedium)),
        ]),
        const SizedBox(height: 14),

        // Canvas
        Container(
          width: double.infinity, height: 280,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.writeTab.withOpacity(0.3), width: 2),
            boxShadow: AppShadows.card,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(children: [
              if (_showDots) Center(
                child: Text(_currentChar,
                  style: GoogleFonts.nunito(fontSize: _isWordPhase ? 60 : 160, fontWeight: FontWeight.w800,
                    color: AppColors.writeTab.withOpacity(0.12))),
              ),
              GestureDetector(
                onPanStart: (d) => setState(() => _points.add(d.localPosition)),
                onPanUpdate: (d) => setState(() => _points.add(d.localPosition)),
                onPanEnd: (d) => setState(() => _points.add(null)),
                child: CustomPaint(
                  size: const Size(double.infinity, 280),
                  painter: _TracingPainter(points: _points, color: AppColors.writeTab),
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 14),

        // Controls
        Row(children: [
          Expanded(child: DuoButton(text: '🗑️ Clear', color: Colors.grey.shade400, onPressed: _clear)),
          const SizedBox(width: 10),
          Expanded(child: DuoButton(text: _isWordPhase ? '✅ Done' : '→ Next', color: AppColors.writeTab, onPressed: _done)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Checkbox(value: _showDots, onChanged: (v) => setState(() => _showDots = v!), activeColor: AppColors.writeTab),
          Text('Show guide / गाइड दिखाएँ', style: GoogleFonts.nunito(fontSize: 13)),
        ]),
      ]),
    );
  }

  Widget _buildComplete() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('✍️', style: TextStyle(fontSize: 80)),
      const SizedBox(height: 16),
      Text('Great writing!', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800)),
      Text('बहुत अच्छी लिखावट!', style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
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
      DuoButton(text: '🔄 Practice Again', width: 180, color: AppColors.writeTab, onPressed: () {
        setState(() { _currentLetterIdx = 0; _completed = false; _points = []; });
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) ref.read(ttsServiceProvider).speakEnglish('Let us practice again. Trace the letter ${widget.word.writeContent.letters.isNotEmpty ? widget.word.writeContent.letters[0] : widget.word.word}');
        });
      }),
    ]));
  }
}

class _TracingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  _TracingPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeCap = StrokeCap.round..strokeWidth = 6.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter old) => true;
}
