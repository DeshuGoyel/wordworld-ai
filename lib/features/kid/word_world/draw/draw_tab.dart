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

class DrawTab extends ConsumerStatefulWidget {
  final WordData word;
  const DrawTab({super.key, required this.word});
  @override
  ConsumerState<DrawTab> createState() => _DrawTabState();
}

class _DrawTabState extends ConsumerState<DrawTab> {
  List<_DrawStroke> _strokes = [];
  List<Offset?> _currentStroke = [];
  Color _selectedColor = AppColors.drawTab;
  int _currentStep = 0;
  bool _completed = false;
  double _strokeWidth = 4.0;

  final _colors = [AppColors.drawTab, AppColors.meetTab, AppColors.thinkTab, AppColors.talkTab,
    AppColors.writeTab, AppColors.storyTab, Colors.black, Colors.brown, Colors.yellow, Colors.white];

  DrawStep? get _step => _currentStep < widget.word.drawContent.steps.length ? widget.word.drawContent.steps[_currentStep] : null;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _step != null) {
        ref.read(ttsServiceProvider).speakEnglish('Let us draw a ${widget.word.word}! ${_step!.instruction}');
      }
    });
  }

  void _completeStep() {
    final sound = ref.read(soundServiceProvider);
    final tts = ref.read(ttsServiceProvider);

    if (_currentStep < widget.word.drawContent.steps.length - 1) {
      sound.playCorrect();
      setState(() => _currentStep++);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _step != null) tts.speakEnglish(_step!.instruction);
      });
    } else {
      setState(() => _completed = true);
      sound.playStarEarned();
      tts.speakEnglish('Amazing drawing! You are an artist!');
      final child = ref.read(activeChildProvider);
      if (child != null) ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'draw');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ═══════ AI ART STUDIO HEADER ═══════
      Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(gradient: AppGradients.warm, borderRadius: BorderRadius.circular(12)),
          child: Text('🎨 AI ART STUDIO', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
        ),
      ),
      // Step instruction
      if (!_completed && _step != null)
        Container(
          margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.drawTab.withOpacity(0.12), AppColors.drawTab.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.drawTab.withOpacity(0.2)),
          ),
          child: Row(children: [
            Container(width: 36, height: 36,
              decoration: BoxDecoration(gradient: AppGradients.warm, shape: BoxShape.circle),
              child: Center(child: Text('${_step!.stepNumber}', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_step!.instruction, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
              Text(_step!.instructionHi, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
            ])),
            GestureDetector(
              onTap: () => ref.read(ttsServiceProvider).speakEnglish(_step!.instruction),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.drawTab.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.volume_up_rounded, color: AppColors.drawTab, size: 20),
              ),
            ),
          ]),
        ),
      if (_completed)
        Container(
          margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.success.withOpacity(0.12), AppColors.success.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: [
            Text('${widget.word.drawContent.finalDescription} ⭐', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Icon(Icons.star_rounded, color: AppColors.starActive, size: 32),
          ]),
        ),

      // Progress
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: DuoProgressBar(progress: (_currentStep + (_completed ? 1 : 0)) / widget.word.drawContent.steps.length, color: AppColors.drawTab)),
          const SizedBox(width: 8),
          Text('${_currentStep + (_completed ? widget.word.drawContent.steps.length : 0) == widget.word.drawContent.steps.length ? "Done" : "${_currentStep + 1}/${widget.word.drawContent.steps.length}"}',
            style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMedium)),
        ]),
      ),

      // Canvas
      Expanded(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.drawTab.withOpacity(0.3), width: 2),
            boxShadow: AppShadows.card),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: GestureDetector(
              onPanStart: (d) => setState(() => _currentStroke = [d.localPosition]),
              onPanUpdate: (d) => setState(() => _currentStroke.add(d.localPosition)),
              onPanEnd: (d) => setState(() {
                _strokes.add(_DrawStroke(List.from(_currentStroke), _selectedColor, _strokeWidth));
                _currentStroke = [];
              }),
              child: CustomPaint(
                size: Size.infinite,
                painter: _DrawPainter(strokes: _strokes, currentStroke: _currentStroke, currentColor: _selectedColor, strokeWidth: _strokeWidth),
              ),
            ),
          ),
        ),
      ),

      // Color palette + controls
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(children: [
          SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal, children:
            _colors.map((c) => GestureDetector(
              onTap: () => setState(() => _selectedColor = c),
              child: Container(width: 32, height: 32, margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                  border: Border.all(color: _selectedColor == c ? Colors.black87 : Colors.grey.shade300, width: _selectedColor == c ? 3 : 1),
                  boxShadow: _selectedColor == c ? AppShadows.soft(c) : [])),
            )).toList())),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: DuoButton(text: '↩️ Undo', color: Colors.grey.shade400, onPressed: () {
              if (_strokes.isNotEmpty) setState(() => _strokes.removeLast());
            })),
            const SizedBox(width: 8),
            Expanded(child: DuoButton(text: '🗑️ Clear', color: Colors.grey.shade400, onPressed: () => setState(() => _strokes = []))),
            const SizedBox(width: 8),
            Expanded(child: DuoButton(text: _completed ? '🔄 Redo' : '✅ Step Done', color: AppColors.drawTab,
              onPressed: _completed ? () {
                setState(() { _strokes = []; _currentStep = 0; _completed = false; });
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted && widget.word.drawContent.steps.isNotEmpty) {
                    ref.read(ttsServiceProvider).speakEnglish(widget.word.drawContent.steps[0].instruction);
                  }
                });
              } : _completeStep)),
          ]),
        ]),
      ),
    ]);
  }
}

class _DrawStroke {
  final List<Offset?> points;
  final Color color;
  final double width;
  _DrawStroke(this.points, this.color, this.width);
}

class _DrawPainter extends CustomPainter {
  final List<_DrawStroke> strokes;
  final List<Offset?> currentStroke;
  final Color currentColor;
  final double strokeWidth;
  _DrawPainter({required this.strokes, required this.currentStroke, required this.currentColor, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()..color = stroke.color..strokeCap = StrokeCap.round..strokeWidth = stroke.width;
      for (int i = 0; i < stroke.points.length - 1; i++) {
        if (stroke.points[i] != null && stroke.points[i + 1] != null) {
          canvas.drawLine(stroke.points[i]!, stroke.points[i + 1]!, paint);
        }
      }
    }
    final paint = Paint()..color = currentColor..strokeCap = StrokeCap.round..strokeWidth = strokeWidth;
    for (int i = 0; i < currentStroke.length - 1; i++) {
      if (currentStroke[i] != null && currentStroke[i + 1] != null) {
        canvas.drawLine(currentStroke[i]!, currentStroke[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
