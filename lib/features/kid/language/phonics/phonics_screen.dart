import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/xp_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/widgets/tappable.dart';

/// Phonics Screen — letter sounds, blending, rhyming
class PhonicsScreen extends ConsumerStatefulWidget {
  const PhonicsScreen({super.key});
  @override
  ConsumerState<PhonicsScreen> createState() => _PhonicsScreenState();
}

class _PhonicsScreenState extends ConsumerState<PhonicsScreen> {
  int _currentLevel = 0; // 0=sounds, 1=blends, 2=rhymes
  int _currentQ = 0;
  int _score = 0;
  String? _selected;
  bool _answered = false;
  bool _showResults = false;

  static const _levels = ['Letter Sounds', 'Blending', 'Rhyming'];
  static const _levelEmojis = ['🔊', '🔗', '🎵'];

  // ── Level 0: Letter Sounds ──
  static const _soundQuestions = [
    {'q': 'What sound does "B" make?', 'opts': ['buh', 'duh', 'puh'], 'ans': 'buh', 'hint': '🐝 B is for Bee — buh!'},
    {'q': 'What sound does "M" make?', 'opts': ['nuh', 'muh', 'buh'], 'ans': 'muh', 'hint': '🐄 M is for Moo — muh!'},
    {'q': 'What sound does "S" make?', 'opts': ['sss', 'zzz', 'shh'], 'ans': 'sss', 'hint': '🐍 S is for Snake — sss!'},
    {'q': 'What sound does "F" make?', 'opts': ['vvv', 'fff', 'ppp'], 'ans': 'fff', 'hint': '🐟 F is for Fish — fff!'},
    {'q': 'What sound does "R" make?', 'opts': ['rrr', 'lll', 'www'], 'ans': 'rrr', 'hint': '🦁 R is for Roar — rrr!'},
    {'q': 'What sound does "L" make?', 'opts': ['lll', 'rrr', 'nnn'], 'ans': 'lll', 'hint': '🍋 L is for Lemon — lll!'},
    {'q': 'What sound does "D" make?', 'opts': ['duh', 'tuh', 'buh'], 'ans': 'duh', 'hint': '🐕 D is for Dog — duh!'},
    {'q': 'What sound does "T" make?', 'opts': ['duh', 'tuh', 'puh'], 'ans': 'tuh', 'hint': '🐢 T is for Turtle — tuh!'},
    {'q': 'What sound does "P" make?', 'opts': ['puh', 'buh', 'tuh'], 'ans': 'puh', 'hint': '🐼 P is for Panda — puh!'},
    {'q': 'What sound does "K" make?', 'opts': ['kuh', 'guh', 'duh'], 'ans': 'kuh', 'hint': '🪁 K is for Kite — kuh!'},
  ];

  // ── Level 1: Blending ──
  static const _blendQuestions = [
    {'q': 'Blend: C-A-T = ?', 'opts': ['cat', 'bat', 'hat'], 'ans': 'cat', 'hint': 'Put the sounds together!'},
    {'q': 'Blend: D-O-G = ?', 'opts': ['dig', 'dog', 'dug'], 'ans': 'dog', 'hint': 'Say each sound fast!'},
    {'q': 'Blend: S-U-N = ?', 'opts': ['sun', 'son', 'sin'], 'ans': 'sun', 'hint': 'It shines in the sky!'},
    {'q': 'Blend: B-A-T = ?', 'opts': ['bit', 'bat', 'but'], 'ans': 'bat', 'hint': 'It flies at night!'},
    {'q': 'Blend: H-E-N = ?', 'opts': ['hen', 'pen', 'ten'], 'ans': 'hen', 'hint': 'A mother chicken!'},
    {'q': 'Blend: P-I-G = ?', 'opts': ['peg', 'pig', 'pug'], 'ans': 'pig', 'hint': 'Oink oink!'},
    {'q': 'Blend: R-U-N = ?', 'opts': ['ran', 'run', 'ruin'], 'ans': 'run', 'hint': 'Go fast!'},
    {'q': 'Blend: M-A-P = ?', 'opts': ['map', 'mop', 'mup'], 'ans': 'map', 'hint': 'Shows directions!'},
    {'q': 'Blend: B-U-S = ?', 'opts': ['bus', 'buzz', 'boss'], 'ans': 'bus', 'hint': 'Rides on the road!'},
    {'q': 'Blend: C-U-P = ?', 'opts': ['cup', 'cap', 'cop'], 'ans': 'cup', 'hint': 'You drink from it!'},
  ];

  // ── Level 2: Rhyming ──
  static const _rhymeQuestions = [
    {'q': 'Which rhymes with "cat"?', 'opts': ['hat', 'dog', 'sun'], 'ans': 'hat', 'hint': 'Same ending sound: -at'},
    {'q': 'Which rhymes with "dog"?', 'opts': ['log', 'cat', 'run'], 'ans': 'log', 'hint': 'Same ending sound: -og'},
    {'q': 'Which rhymes with "sun"?', 'opts': ['fun', 'map', 'big'], 'ans': 'fun', 'hint': 'Same ending sound: -un'},
    {'q': 'Which rhymes with "ball"?', 'opts': ['fall', 'dog', 'cup'], 'ans': 'fall', 'hint': 'Same ending sound: -all'},
    {'q': 'Which rhymes with "ring"?', 'opts': ['sing', 'ran', 'cup'], 'ans': 'sing', 'hint': 'Same ending sound: -ing'},
    {'q': 'Which rhymes with "cake"?', 'opts': ['lake', 'book', 'pen'], 'ans': 'lake', 'hint': 'Same ending sound: -ake'},
    {'q': 'Which rhymes with "top"?', 'opts': ['hop', 'big', 'run'], 'ans': 'hop', 'hint': 'Same ending sound: -op'},
    {'q': 'Which rhymes with "bed"?', 'opts': ['red', 'pig', 'sun'], 'ans': 'red', 'hint': 'Same ending sound: -ed'},
    {'q': 'Which rhymes with "moon"?', 'opts': ['spoon', 'star', 'day'], 'ans': 'spoon', 'hint': 'Same ending sound: -oon'},
    {'q': 'Which rhymes with "tree"?', 'opts': ['bee', 'dog', 'hat'], 'ans': 'bee', 'hint': 'Same ending sound: -ee'},
  ];

  List<Map<String, dynamic>> get _questions =>
    _currentLevel == 0 ? _soundQuestions : _currentLevel == 1 ? _blendQuestions : _rhymeQuestions;

  void _answer(String opt) {
    if (_answered) return;
    setState(() {
      _selected = opt;
      _answered = true;
      if (opt == _questions[_currentQ]['ans']) {
        _score++;
        ref.read(xpServiceProvider).addXP(5);
      }
    });
  }

  void _next() {
    if (_currentQ < _questions.length - 1) {
      setState(() { _currentQ++; _selected = null; _answered = false; });
    } else {
      setState(() => _showResults = true);
    }
  }

  void _switchLevel(int level) {
    setState(() { _currentLevel = level; _currentQ = 0; _score = 0; _selected = null; _answered = false; _showResults = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) return _buildResults();

    final q = _questions[_currentQ];
    final progress = (_currentQ + 1) / _questions.length;
    final isCorrect = _selected == q['ans'];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Top bar
            Row(children: [
              Tappable(onTap: () => context.pop(),
                child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.primary))),
              const SizedBox(width: 12),
              Text('🔊 Phonics', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('⭐ $_score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
            ]),
            const SizedBox(height: 16),

            // Level tabs
            Row(children: List.generate(3, (i) => Expanded(
              child: Tappable(
                onTap: () => _switchLevel(i),
                child: AnimatedContainer(
                  duration: AppDurations.fast,
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _currentLevel == i ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _currentLevel == i ? AppColors.primary : AppColors.textLight.withValues(alpha: 0.3)),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(_levelEmojis[i], style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 2),
                    Text(_levels[i], style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700,
                      color: _currentLevel == i ? Colors.white : AppColors.textMedium)),
                  ]),
                ),
              ),
            ))),
            const SizedBox(height: 16),

            // Progress
            ClipRRect(borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: progress, minHeight: 8,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerRight,
              child: Text('${_currentQ + 1}/${_questions.length}', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium))),
            const SizedBox(height: 16),

            // Question card
            Expanded(child: Column(children: [
              Container(
                width: double.infinity, padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
                child: Column(children: [
                  Text(_levelEmojis[_currentLevel], style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(q['q'] as String, style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark), textAlign: TextAlign.center),
                  if (_answered && !isCorrect) ...[
                    const SizedBox(height: 8),
                    Text('💡 ${q['hint']}', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium, fontStyle: FontStyle.italic)),
                  ],
                ]),
              ),
              const SizedBox(height: 20),

              ...(q['opts'] as List<String>).map((opt) {
                final isThis = _selected == opt;
                final isAns = opt == q['ans'];
                Color bg = Colors.white;
                Color border = AppColors.textLight.withValues(alpha: 0.2);
                if (_answered) {
                  if (isAns) { bg = AppColors.success.withValues(alpha: 0.1); border = AppColors.success; }
                  else if (isThis) { bg = AppColors.error.withValues(alpha: 0.1); border = AppColors.error; }
                }
                return Padding(padding: const EdgeInsets.only(bottom: 10),
                  child: Tappable(onTap: () => _answer(opt),
                    child: AnimatedContainer(duration: AppDurations.fast, width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border, width: 2)),
                      child: Row(children: [
                        Expanded(child: Text(opt, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark))),
                        if (_answered && isAns) const Icon(Icons.check_circle, color: AppColors.success),
                        if (_answered && isThis && !isAns) const Icon(Icons.cancel, color: AppColors.error),
                      ]))));
              }),
            ])),

            if (_answered)
              PrimaryButton(label: _currentQ < _questions.length - 1 ? 'Next →' : 'See Results', onPressed: _next,
                color: isCorrect ? AppColors.success : AppColors.primary),
          ]),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final pct = _score / _questions.length;
    final stars = pct >= 0.9 ? 3 : pct >= 0.6 ? 2 : pct >= 0.3 ? 1 : 0;
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(stars >= 3 ? '🏆' : stars >= 2 ? '⭐' : '💪', style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(stars >= 3 ? 'Phonics Master!' : stars >= 2 ? 'Great Job!' : 'Keep Practicing!',
            style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < 3; i++) Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.star_rounded, size: 36, color: i < stars ? AppColors.starActive : AppColors.starInactive)),
              ]),
              const SizedBox(height: 16),
              Text('$_score / ${_questions.length}', style: GoogleFonts.nunito(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.primary)),
              Text('correct answers', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
            ])),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                side: const BorderSide(color: AppColors.primary)),
              child: Text('Back', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)))),
            const SizedBox(width: 12),
            Expanded(child: PrimaryButton(label: 'Play Again', onPressed: () {
              setState(() { _currentQ = 0; _score = 0; _selected = null; _answered = false; _showResults = false; });
            })),
          ]),
        ])))),
    );
  }
}
