import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
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
import 'package:perfect_freehand/perfect_freehand.dart' as pf;

class DrawTab extends ConsumerStatefulWidget {
  final WordData word;
  const DrawTab({super.key, required this.word});
  @override
  ConsumerState<DrawTab> createState() => _DrawTabState();
}

class _DrawTabState extends ConsumerState<DrawTab> {
  List<_DrawStroke> _strokes = [];
  List<pf.Point> _currentStroke = [];
  Color _selectedColor = AppColors.drawTab;
  int _currentStep = 0;
  bool _completed = false;
  bool _isProcessing = false;
  final double _strokeWidth = 4.0;
  final GlobalKey _canvasKey = GlobalKey();

  final _colors = [AppColors.drawTab, AppColors.meetTab, AppColors.thinkTab, AppColors.talkTab,
    AppColors.writeTab, AppColors.storyTab, Colors.black, Colors.brown, Colors.yellow, Colors.white];

  DrawStep? get _step => _currentStep < widget.word.drawContent.steps.length ? widget.word.drawContent.steps[_currentStep] : null;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _step != null) {
        TTSService.instance.speak('Try again!', lang: 'en');
      }
    });
  }

  void _completeStep() async {
    if (_strokes.isEmpty) {
       TTSService.instance.speak("Please draw something first!", lang: 'en');
       return;
    }
    
    setState(() => _isProcessing = true);
    try {
      RenderRepaintBoundary boundary = _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final vision = ref.read(visionServiceProvider);
      Map<String, dynamic> result;
      
      if (_step!.instruction.toLowerCase().contains('write') || _step!.instruction.toLowerCase().contains('draw the letter')) {
         result = await vision.gradeHandwriting(pngBytes, widget.word.word.substring(0, 1));
      } else {
         result = await vision.assessDrawing(pngBytes, widget.word.word);
      }
      
      final stars = result['stars'] as int;
      final feedback = result['feedback'] as String;
      
      TTSService.instance.speak(feedback, lang: 'en');
      if (stars >= 4) {
         AudioService.instance.play(SoundType.correct);
      } else {
         AudioService.instance.play(SoundType.pop);
      }

      if (_currentStep < widget.word.drawContent.steps.length - 1) {
        setState(() => _currentStep++);
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted && _step != null) TTSService.instance.speak(_step!.instruction, lang: 'en');
        });
      } else {
        setState(() => _completed = true);
        AudioService.instance.play(SoundType.star);
        final child = ref.read(activeChildProvider);
        if (child != null) ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'draw');
      }
    } catch (e) {
      debugPrint("Drawing capture error: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
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
            gradient: LinearGradient(colors: [AppColors.drawTab.withValues(alpha: 0.12), AppColors.drawTab.withValues(alpha: 0.04)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.drawTab.withValues(alpha: 0.2)),
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
            Tappable(
              onTap: () => TTSService.instance.speak('Tap to hear', lang: 'en'),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.drawTab.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.volume_up_rounded, color: AppColors.drawTab, size: 20),
              ),
            ),
          ]),
        ),
      if (_completed)
        Container(
          margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.success.withValues(alpha: 0.12), AppColors.success.withValues(alpha: 0.04)]),
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
        child: RepaintBoundary(
          key: _canvasKey,
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.drawTab.withValues(alpha: 0.3), width: 2),
              boxShadow: AppShadows.card),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Tappable(
                onPanStart: (d) => setState(() => _currentStroke = [pf.Point(d.localPosition.dx, d.localPosition.dy)]),
                onPanUpdate: (d) => setState(() => _currentStroke.add(pf.Point(d.localPosition.dx, d.localPosition.dy))),
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
      ),

      // Color palette + controls
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(children: [
          SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal, children:
            _colors.map((c) => Tappable(
              onTap: () => setState(() => _selectedColor = c),
              child: Container(width: 32, height: 32, margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                  border: Border.all(color: _selectedColor == c ? Colors.black87 : Colors.grey.shade300, width: _selectedColor == c ? 3 : 1),
                  boxShadow: _selectedColor == c ? AppShadows.soft(c) : [])),
            )).toList())),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: DuoButton(text: '↩️ Undo', color: Colors.grey.shade400, onPressed: () {
               if (_isProcessing) return;
               if (_strokes.isNotEmpty) setState(() => _strokes.removeLast());
            })),
            const SizedBox(width: 8),
            Expanded(child: DuoButton(text: '🗑️ Clear', color: Colors.grey.shade400, onPressed: () {
               if (_isProcessing) return;
               setState(() => _strokes = []);
            })),
            const SizedBox(width: 8),
            Expanded(child: DuoButton(text: _isProcessing ? '⏳' : _completed ? '🔄 Redo' : '✅ Done', color: AppColors.drawTab,
              onPressed: () {
                if (_isProcessing) return;
                if (_completed) {
                  setState(() { _strokes = []; _currentStep = 0; _completed = false; });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted && widget.word.drawContent.steps.isNotEmpty) {
                      TTSService.instance.speak('Try again!', lang: 'en');
                    }
                  });
                } else {
                  _completeStep();
                }
              })),
          ]),
        ]),
      ),
    ]);
  }
}

class _DrawStroke {
  final List<pf.Point> points;
  final Color color;
  final double width;
  _DrawStroke(this.points, this.color, this.width);
}

class _DrawPainter extends CustomPainter {
  final List<_DrawStroke> strokes;
  final List<pf.Point> currentStroke;
  final Color currentColor;
  final double strokeWidth;
  _DrawPainter({required this.strokes, required this.currentStroke, required this.currentColor, required this.strokeWidth});

  void _drawStroke(Canvas canvas, List<pf.Point> points, Color color, double width) {
    if (points.isEmpty) return;
    
    final outlinePoints = pf.getStroke(
      points,
      size: width * 3, // slightly thicker for better feel
      thinning: 0.5,
      smoothing: 0.5,
      streamline: 0.5,
      simulatePressure: true,
    );

    if (outlinePoints.isEmpty) return;

    final path = Path();
    path.moveTo(outlinePoints[0].x, outlinePoints[0].y);
    for (int i = 1; i < outlinePoints.length; i++) {
      path.lineTo(outlinePoints[i].x, outlinePoints[i].y);
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke.points, stroke.color, stroke.width);
    }
    _drawStroke(canvas, currentStroke, currentColor, strokeWidth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
