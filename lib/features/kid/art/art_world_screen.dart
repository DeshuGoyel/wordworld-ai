import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/xp_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../../shared/widgets/quiz_result_screen.dart';

/// Art World — color mixing, patterns, music, drawing activities
class ArtWorldScreen extends ConsumerStatefulWidget {
  const ArtWorldScreen({super.key});
  @override
  ConsumerState<ArtWorldScreen> createState() => _ArtWorldScreenState();
}

class _ArtWorldScreenState extends ConsumerState<ArtWorldScreen> {
  int _selectedModule = -1;

  static const _modules = [
    {'emoji': '🎨', 'title': 'Color Mixing Lab', 'desc': 'Mix colors to create new ones!', 'color': 0xFFFF6B9D},
    {'emoji': '🔷', 'title': 'Pattern Maker', 'desc': 'Create beautiful patterns', 'color': 0xFF6C5CE7},
    {'emoji': '🎵', 'title': 'Music Fun', 'desc': 'Learn about rhythm & notes', 'color': 0xFF00CEC9},
    {'emoji': '✏️', 'title': 'Drawing School', 'desc': 'Learn to draw step by step', 'color': 0xFFFF9F43},
    {'emoji': '🖼️', 'title': 'Art Gallery', 'desc': 'Famous art & styles', 'color': 0xFF00B894},
    {'emoji': '🎭', 'title': 'Craft Corner', 'desc': 'DIY crafts & activities', 'color': 0xFFE17055},
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedModule >= 0) return _buildModule(_selectedModule);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              GestureDetector(onTap: () => context.pop(),
                child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.artWorld.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.artWorld))),
              const SizedBox(width: 12),
              Text('🎨 Art World', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 20),

            // Hero
            Container(width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.artWorld, AppColors.artWorld.withValues(alpha: 0.6)]),
                borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🎨🖌️✨', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text('Express Your Creativity!', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                Text('Mix colors, make patterns, enjoy music!', style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70)),
              ]),
            ),
            const SizedBox(height: 24),

            ...List.generate(_modules.length, (i) {
              final m = _modules[i];
              final color = Color(m['color'] as int);
              return Padding(padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedModule = i),
                  child: Container(padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
                    child: Row(children: [
                      Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                        child: Center(child: Text(m['emoji'] as String, style: const TextStyle(fontSize: 24)))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(m['title'] as String, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
                        Text(m['desc'] as String, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
                      ])),
                      Icon(Icons.play_circle_filled_rounded, size: 36, color: color),
                    ])),
                ));
            }),
          ]),
        ),
      ),
    );
  }

  Widget _buildModule(int idx) {
    switch (idx) {
      case 0: return _ColorMixingLab(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 1: return _PatternMaker(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 2: return _MusicFun(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 3: return _DrawingSchool(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 4: return _ArtGallery(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      case 5: return _CraftCorner(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
      default: return const SizedBox();
    }
  }
}

// ═══════════ COLOR MIXING LAB ═══════════
class _ColorMixingLab extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _ColorMixingLab({required this.onBack, required this.xpService});
  @override State<_ColorMixingLab> createState() => _ColorMixingLabState();
}

class _ColorMixingLabState extends State<_ColorMixingLab> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': '🔴 Red + 🔵 Blue = ?', 'opts': ['🟣 Purple', '🟢 Green', '🟠 Orange'], 'ans': '🟣 Purple'},
    {'q': '🔴 Red + 🟡 Yellow = ?', 'opts': ['🟠 Orange', '🟢 Green', '🟣 Purple'], 'ans': '🟠 Orange'},
    {'q': '🔵 Blue + 🟡 Yellow = ?', 'opts': ['🟢 Green', '🟠 Orange', '🟣 Purple'], 'ans': '🟢 Green'},
    {'q': '⚪ White + 🔴 Red = ?', 'opts': ['🩷 Pink', '🟣 Purple', '🟠 Orange'], 'ans': '🩷 Pink'},
    {'q': '⚫ Black + ⚪ White = ?', 'opts': ['🩶 Gray', '🔵 Blue', '🟤 Brown'], 'ans': '🩶 Gray'},
    {'q': '🔴 Red + 🟢 Green = ?', 'opts': ['🟤 Brown', '🟣 Purple', '🟡 Yellow'], 'ans': '🟤 Brown'},
    {'q': '🔵 Blue + ⚪ White = ?', 'opts': ['Light Blue', 'Dark Blue', 'Green'], 'ans': 'Light Blue'},
    {'q': 'Primary colors are:', 'opts': ['Red, Blue, Yellow', 'Green, Orange, Purple', 'Black, White, Gray'], 'ans': 'Red, Blue, Yellow'},
    {'q': 'Secondary colors are made by mixing:', 'opts': ['Two primary colors', 'Three primary colors', 'Primary + white'], 'ans': 'Two primary colors'},
    {'q': '🟡 Yellow + 🟡 Yellow + 🔵 Blue = ?', 'opts': ['Yellow-Green', 'Blue-Green', 'Orange'], 'ans': 'Yellow-Green'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) return QuizResultScreen(score: _score, total: _questions.length, title: '🎨 Color Mixing', color: const Color(0xFFFF6B9D), onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    final q = _questions[_q];
    return _ArtQuizShell(title: '🎨 Color Mixing', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      color: const Color(0xFFFF6B9D),
      onSelect: (v) { if (_answered) return; HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }));
  }
}

// ═══════════ PATTERN MAKER ═══════════
class _PatternMaker extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _PatternMaker({required this.onBack, required this.xpService});
  @override State<_PatternMaker> createState() => _PatternMakerState();
}

class _PatternMakerState extends State<_PatternMaker> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': 'Complete: 🔴🔵🔴🔵🔴___', 'opts': ['🔵', '🔴', '🟢'], 'ans': '🔵'},
    {'q': 'Complete: ⭐🌙⭐🌙⭐___', 'opts': ['🌙', '⭐', '☀️'], 'ans': '🌙'},
    {'q': 'Complete: 🌸🌸🌼🌸🌸___', 'opts': ['🌼', '🌸', '🌹'], 'ans': '🌼'},
    {'q': 'Complete: 🟢🟢🟡🟢🟢___', 'opts': ['🟡', '🟢', '🔴'], 'ans': '🟡'},
    {'q': 'What pattern? ABC ABC ___', 'opts': ['ABC', 'CBA', 'AAA'], 'ans': 'ABC'},
    {'q': 'Symmetry: 🔺🔺|🔺🔺 — mirror?', 'opts': ['Yes', 'No'], 'ans': 'Yes'},
    {'q': 'Growing: ⬛⬛⬛ ⬛⬛⬛⬛ ___', 'opts': ['⬛⬛⬛⬛⬛', '⬛⬛⬛', '⬛⬛'], 'ans': '⬛⬛⬛⬛⬛'},
    {'q': 'Tessellation uses ___ shapes', 'opts': ['Repeating', 'Random', 'Broken'], 'ans': 'Repeating'},
    {'q': 'Mandala patterns are ___', 'opts': ['Symmetrical', 'Random', 'Straight'], 'ans': 'Symmetrical'},
    {'q': 'Fractal patterns repeat at different ___', 'opts': ['Scales', 'Colors', 'Times'], 'ans': 'Scales'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) return QuizResultScreen(score: _score, total: _questions.length, title: '🔷 Patterns', color: const Color(0xFF6C5CE7), onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    final q = _questions[_q];
    return _ArtQuizShell(title: '🔷 Pattern Maker', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      color: const Color(0xFF6C5CE7),
      onSelect: (v) { if (_answered) return; HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }));
  }
}

// ═══════════ MUSIC FUN ═══════════
class _MusicFun extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _MusicFun({required this.onBack, required this.xpService});
  @override State<_MusicFun> createState() => _MusicFunState();
}

class _MusicFunState extends State<_MusicFun> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': '🎵 How many notes in the musical scale?', 'opts': ['5', '7', '12'], 'ans': '7'},
    {'q': '🥁 A drum makes ___ sound', 'opts': ['Beat/rhythm', 'Melody', 'Harmony'], 'ans': 'Beat/rhythm'},
    {'q': '🎹 Piano has black and ___ keys', 'opts': ['White', 'Red', 'Blue'], 'ans': 'White'},
    {'q': '🎸 Guitar has ___ strings (standard)', 'opts': ['4', '6', '8'], 'ans': '6'},
    {'q': '🎤 Singing uses your ___', 'opts': ['Voice/vocal cords', 'Hands', 'Feet'], 'ans': 'Voice/vocal cords'},
    {'q': '🎵 Do Re Mi Fa Sol La ___', 'opts': ['Ti', 'Si', 'Di'], 'ans': 'Ti'},
    {'q': '🔊 Loud music is called ___', 'opts': ['Forte', 'Piano', 'Adagio'], 'ans': 'Forte'},
    {'q': '🔇 Soft music is called ___', 'opts': ['Piano', 'Forte', 'Allegro'], 'ans': 'Piano'},
    {'q': '⏱️ Fast tempo music is ___', 'opts': ['Allegro', 'Adagio', 'Andante'], 'ans': 'Allegro'},
    {'q': '🎶 A group singing together is a ___', 'opts': ['Choir', 'Band', 'Orchestra'], 'ans': 'Choir'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) return QuizResultScreen(score: _score, total: _questions.length, title: '🎵 Music Fun', color: const Color(0xFF00CEC9), onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    final q = _questions[_q];
    return _ArtQuizShell(title: '🎵 Music Fun', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      color: const Color(0xFF00CEC9),
      onSelect: (v) { if (_answered) return; HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }));
  }
}

// ═══════════ DRAWING SCHOOL ═══════════
class _DrawingSchool extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _DrawingSchool({required this.onBack, required this.xpService});
  @override State<_DrawingSchool> createState() => _DrawingSchoolState();
}

class _DrawingSchoolState extends State<_DrawingSchool> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': '✏️ To draw a circle, move pencil ___', 'opts': ['Round & round', 'Straight', 'Zigzag'], 'ans': 'Round & round'},
    {'q': '🏠 A house starts with a ___ for base', 'opts': ['Square', 'Circle', 'Star'], 'ans': 'Square'},
    {'q': '🌳 Tree trunk is a ___', 'opts': ['Rectangle', 'Circle', 'Triangle'], 'ans': 'Rectangle'},
    {'q': '🌅 Horizon line goes ___', 'opts': ['Horizontal', 'Vertical', 'Diagonal'], 'ans': 'Horizontal'},
    {'q': '🤡 A face starts with a ___', 'opts': ['Circle/oval', 'Square', 'Triangle'], 'ans': 'Circle/oval'},
    {'q': '🦋 Butterfly wings are ___', 'opts': ['Symmetrical', 'Different', 'Square'], 'ans': 'Symmetrical'},
    {'q': '🌈 How many colors in a rainbow?', 'opts': ['7', '5', '10'], 'ans': '7'},
    {'q': '🎭 Warm colors include ___', 'opts': ['Red, Orange, Yellow', 'Blue, Green, Purple', 'Black, White, Gray'], 'ans': 'Red, Orange, Yellow'},
    {'q': '❄️ Cool colors include ___', 'opts': ['Blue, Green, Purple', 'Red, Orange, Yellow', 'Black, Brown, Tan'], 'ans': 'Blue, Green, Purple'},
    {'q': '🖌️ Thick brush lines look ___', 'opts': ['Bold', 'Thin', 'Invisible'], 'ans': 'Bold'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) return QuizResultScreen(score: _score, total: _questions.length, title: '✏️ Drawing', color: const Color(0xFFFF9F43), onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    final q = _questions[_q];
    return _ArtQuizShell(title: '✏️ Drawing School', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      color: const Color(0xFFFF9F43),
      onSelect: (v) { if (_answered) return; HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }));
  }
}

// ═══════════ ART GALLERY ═══════════
class _ArtGallery extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _ArtGallery({required this.onBack, required this.xpService});
  @override State<_ArtGallery> createState() => _ArtGalleryState();
}

class _ArtGalleryState extends State<_ArtGallery> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': '🖼️ Mona Lisa was painted by ___', 'opts': ['Leonardo da Vinci', 'Picasso', 'Van Gogh'], 'ans': 'Leonardo da Vinci'},
    {'q': '🌻 Sunflowers was painted by ___', 'opts': ['Van Gogh', 'Monet', 'Picasso'], 'ans': 'Van Gogh'},
    {'q': '🌊 Starry Night was painted by ___', 'opts': ['Van Gogh', 'Da Vinci', 'Rembrandt'], 'ans': 'Van Gogh'},
    {'q': '🎨 Cave paintings are from ___ times', 'opts': ['Ancient/prehistoric', 'Modern', 'Future'], 'ans': 'Ancient/prehistoric'},
    {'q': '🏛️ Where is the Mona Lisa?', 'opts': ['Louvre, Paris', 'British Museum', 'Met, New York'], 'ans': 'Louvre, Paris'},
    {'q': '🎭 Indian art form Rangoli uses ___', 'opts': ['Colored powder', 'Paint', 'Pencils'], 'ans': 'Colored powder'},
    {'q': '🪔 Madhubani art is from ___', 'opts': ['Bihar, India', 'France', 'Japan'], 'ans': 'Bihar, India'},
    {'q': '🎎 Origami is the art of ___ folding', 'opts': ['Paper', 'Cloth', 'Metal'], 'ans': 'Paper'},
    {'q': '🗿 Sculpture is ___ art', 'opts': ['3D', '2D', 'Flat'], 'ans': '3D'},
    {'q': '📸 Photography captures images using ___', 'opts': ['Camera/light', 'Paintbrush', 'Pencil'], 'ans': 'Camera/light'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) return QuizResultScreen(score: _score, total: _questions.length, title: '🖼️ Art Gallery', color: const Color(0xFF00B894), onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    final q = _questions[_q];
    return _ArtQuizShell(title: '🖼️ Art Gallery', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      color: const Color(0xFF00B894),
      onSelect: (v) { if (_answered) return; HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }));
  }
}

// ═══════════ CRAFT CORNER ═══════════
class _CraftCorner extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _CraftCorner({required this.onBack, required this.xpService});
  @override State<_CraftCorner> createState() => _CraftCornerState();
}

class _CraftCornerState extends State<_CraftCorner> {
  int _q = 0; int _score = 0; String? _selected; bool _answered = false;

  static const _questions = [
    {'q': '✂️ To cut paper safely, use ___', 'opts': ['Safety scissors', 'Knife', 'Hands'], 'ans': 'Safety scissors'},
    {'q': '🧶 Knitting uses ___ and needles', 'opts': ['Yarn', 'Paper', 'Wire'], 'ans': 'Yarn'},
    {'q': '🏺 Clay can be shaped when it is ___', 'opts': ['Wet/soft', 'Dry/hard', 'Frozen'], 'ans': 'Wet/soft'},
    {'q': '📎 Paper clips are used to ___ paper', 'opts': ['Hold together', 'Cut', 'Color'], 'ans': 'Hold together'},
    {'q': '🖍️ Crayons are made of ___', 'opts': ['Wax', 'Wood', 'Metal'], 'ans': 'Wax'},
    {'q': '📐 A ruler helps draw ___ lines', 'opts': ['Straight', 'Curved', 'Wavy'], 'ans': 'Straight'},
    {'q': '🎀 To make a bow, you need ___', 'opts': ['Ribbon', 'Paper', 'Glue'], 'ans': 'Ribbon'},
    {'q': '🧩 A collage uses ___ materials', 'opts': ['Mixed/different', 'Only paper', 'Only paint'], 'ans': 'Mixed/different'},
    {'q': '🪡 Cross-stitch is done on ___', 'opts': ['Fabric', 'Paper', 'Wood'], 'ans': 'Fabric'},
    {'q': '🎪 A puppet can be made from ___', 'opts': ['Socks', 'Rocks', 'Water'], 'ans': 'Socks'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _questions.length) return QuizResultScreen(score: _score, total: _questions.length, title: '🎭 Craft Corner', color: const Color(0xFFE17055), onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _selected = null; _answered = false; }));
    final q = _questions[_q];
    return _ArtQuizShell(title: '🎭 Craft Corner', q: _q, total: _questions.length, score: _score,
      question: q['q'] as String, options: q['opts'] as List<String>, answer: q['ans'] as String,
      selected: _selected, answered: _answered, onBack: widget.onBack,
      color: const Color(0xFFE17055),
      onSelect: (v) { if (_answered) return; HapticFeedback.lightImpact();
        setState(() { _selected = v; _answered = true; if (v == q['ans']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _selected = null; _answered = false; }));
  }
}

// ═══════════ SHARED ART QUIZ SHELL ═══════════
class _ArtQuizShell extends StatelessWidget {
  final String title, question, answer;
  final int q, total, score;
  final List<String> options;
  final String? selected;
  final bool answered;
  final Color color;
  final VoidCallback onBack, onNext;
  final ValueChanged<String> onSelect;

  const _ArtQuizShell({required this.title, required this.q, required this.total, required this.score,
    required this.question, required this.options, required this.answer, required this.selected,
    required this.answered, required this.onBack, required this.onNext, required this.onSelect, required this.color});

  @override
  Widget build(BuildContext context) {
    final isCorrect = selected == answer;
    return Scaffold(backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            GestureDetector(onTap: onBack, child: Container(width: 40, height: 40,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.arrow_back_rounded, color: color))),
            const SizedBox(width: 12),
            Expanded(child: Text('$title ${q + 1}/$total', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800))),
            Text('⭐ $score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: (q + 1) / total, minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.1), valueColor: AlwaysStoppedAnimation(color))),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
            child: Text(question, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center)),
          const SizedBox(height: 16),
          ...options.map((opt) {
            final isThis = selected == opt; final isAns = opt == answer;
            Color bg = Colors.white, border = AppColors.textLight.withValues(alpha: 0.2);
            if (answered) {
              if (isAns) { bg = AppColors.success.withValues(alpha: 0.1); border = AppColors.success; }
              else if (isThis) { bg = AppColors.error.withValues(alpha: 0.1); border = AppColors.error; }
            }
            return Padding(padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(onTap: () => onSelect(opt),
                child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 2)),
                  child: Row(children: [Expanded(child: Text(opt, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700))),
                    if (answered && isAns) const Icon(Icons.check_circle, color: AppColors.success),
                    if (answered && isThis && !isAns) const Icon(Icons.cancel, color: AppColors.error)]))));
          }),
          const Spacer(),
          if (answered) PrimaryButton(label: q < total - 1 ? 'Next →' : 'Results', onPressed: onNext, color: isCorrect ? AppColors.success : color),
        ]))));
  }
}

