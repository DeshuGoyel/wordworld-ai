import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '3d/confetti_burst.dart';
import '3d/primary_button_3d.dart';
/// A polished quiz result screen with confetti for scores ≥ 60%.
/// Drop-in replacement for custom result widgets in V2/V3 screens.
class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String title;
  final Color color;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.title,
    required this.color,
    required this.onBack,
    required this.onRetry,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confetti;
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);

    // Fire animations if score qualifies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaleCtrl.forward();
      if (widget.score / widget.total >= 0.6) {
        _confetti.play();
      }
    });
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = widget.score / widget.total;
    final stars = ratio >= 0.9 ? 3 : ratio >= 0.6 ? 2 : 1;
    final String headline = ratio >= 0.9
        ? 'Outstanding! 🏆'
        : ratio >= 0.6
            ? 'Well Done! ⭐'
            : 'Keep Practicing! 💪';

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ──── Confetti ────
          ConfettiBurst(
            trigger: ratio >= 0.6,
            child: const SizedBox.shrink(),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Headline ──
                  ScaleTransition(
                    scale: _scale,
                    child: Text(
                      headline,
                      style: GoogleFonts.nunito(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Score Card ──
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppShadows.card,
                        border: Border.all(
                            color: widget.color.withValues(alpha: 0.3), width: 2),
                      ),
                      child: Column(
                        children: [
                          // Stars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (i) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 40,
                                  color: i < stars
                                      ? AppColors.starActive
                                      : AppColors.starInactive,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Score fraction
                          Text(
                            '${widget.score} / ${widget.total}',
                            style: GoogleFonts.nunito(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: widget.color,
                            ),
                          ),

                          // Percentage
                          Text(
                            '${(ratio * 100).round()}% correct',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Buttons ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onBack,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            side: BorderSide(color: widget.color, width: 2),
                          ),
                          child: Text(
                            '← Back',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: widget.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton3D(
                          label: 'Retry 🔄',
                          onTap: widget.onRetry,
                          solidColor: widget.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
