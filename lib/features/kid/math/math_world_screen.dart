import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';

/// Math World — Numbers 1-10 character grid + Shape/Pattern games
class MathWorldScreen extends StatelessWidget {
  const MathWorldScreen({super.key});

  static const _numbers = [
    _NumberChar(num: 1, emoji: '1️⃣', name: 'One', personality: 'Solo Traveler', color: Color(0xFF0984E3)),
    _NumberChar(num: 2, emoji: '2️⃣', name: 'Two', personality: 'The Twins', color: Color(0xFF00B894)),
    _NumberChar(num: 3, emoji: '3️⃣', name: 'Three', personality: 'Musicians', color: Color(0xFFE17055)),
    _NumberChar(num: 4, emoji: '4️⃣', name: 'Four', personality: 'Table Legs', color: Color(0xFF6C5CE7)),
    _NumberChar(num: 5, emoji: '5️⃣', name: 'Five', personality: 'High Five!', color: Color(0xFFFD79A8)),
    _NumberChar(num: 6, emoji: '6️⃣', name: 'Six', personality: 'Hexagon', color: Color(0xFF00CEC9)),
    _NumberChar(num: 7, emoji: '7️⃣', name: 'Seven', personality: 'Rainbow', color: Color(0xFFFF7675)),
    _NumberChar(num: 8, emoji: '8️⃣', name: 'Eight', personality: 'Spider', color: Color(0xFFA29BFE)),
    _NumberChar(num: 9, emoji: '9️⃣', name: 'Nine', personality: 'Cat (9 lives)', color: Color(0xFFFFBE76)),
    _NumberChar(num: 10, emoji: '🔟', name: 'Ten', personality: 'Team Captain', color: Color(0xFF2ED573)),
  ];

  static const _games = [
    _MathGame(emoji: '🎯', title: 'Counting', description: 'Count objects and tap the number', color: Color(0xFF0984E3)),
    _MathGame(emoji: '🔷', title: 'Shapes', description: 'Learn circle, square, triangle', color: Color(0xFF6C5CE7)),
    _MathGame(emoji: '🧩', title: 'Patterns', description: 'What comes next? ABAB...', color: Color(0xFF00B894)),
    _MathGame(emoji: '➕', title: 'Addition', description: 'Add numbers together', color: Color(0xFFE17055)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: AppColors.mathWorld.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.arrow_back_rounded, color: AppColors.mathWorld)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Math World', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.mathWorld)),
                  Text('Numbers, Shapes & Patterns', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                ])),
                const Text('🔢', style: TextStyle(fontSize: 32)),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Numbers grid
                    Text('Number Friends 🔢', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10,
                      ),
                      itemCount: _numbers.length,
                      itemBuilder: (context, i) {
                        final n = _numbers[i];
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _showNumberDetail(context, n);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [n.color, n.color.withValues(alpha: 0.7)]),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppShadows.soft(n.color),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${n.num}', style: GoogleFonts.nunito(
                                  fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Math games
                    Text('Math Games 🎮', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    ..._games.map((game) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showMathGame(context, game);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: game.color.withValues(alpha: 0.2), width: 2),
                            boxShadow: AppShadows.card,
                          ),
                          child: Row(children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(color: game.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                              child: Center(child: Text(game.emoji, style: const TextStyle(fontSize: 24))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(game.title, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: game.color)),
                              Text(game.description, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                            ])),
                            Icon(Icons.play_arrow_rounded, color: game.color, size: 28),
                          ]),
                        ),
                      ),
                    )),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNumberDetail(BuildContext context, _NumberChar n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [n.color, n.color.withValues(alpha: 0.8)]),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Text('${n.num}', style: GoogleFonts.nunito(fontSize: 80, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 8),
          Text(n.name, style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
          Text('"${n.personality}"', style: GoogleFonts.nunito(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white70)),
          const SizedBox(height: 20),
          // Counting dots
          Wrap(
            spacing: 8, runSpacing: 8,
            children: List.generate(n.num, (i) => Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            )),
          ),
          const SizedBox(height: 20),
          Text('Count: ${n.num} dots!', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ]),
      ),
    );
  }

  void _showMathGame(BuildContext context, _MathGame game) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(game.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(game.title, style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(game.description, style: GoogleFonts.nunito(fontSize: 15, color: AppColors.textMedium)),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Play Now!', onPressed: () => Navigator.pop(context), color: game.color),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ]),
      ),
    );
  }
}

class _NumberChar {
  final int num;
  final String emoji, name, personality;
  final Color color;
  const _NumberChar({required this.num, required this.emoji, required this.name, required this.personality, required this.color});
}

class _MathGame {
  final String emoji, title, description;
  final Color color;
  const _MathGame({required this.emoji, required this.title, required this.description, required this.color});
}
