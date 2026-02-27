import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import 'package:learn_app/core/widgets/tappable.dart';

class WordCard3D extends StatelessWidget {
  final String word;
  final String wordHindi;
  final String emoji;
  final Color cardColor;
  final bool isCompleted;
  final bool isLocked;
  final bool isCurrent;
  final VoidCallback? onTap;
  final int animationIndex;

  const WordCard3D({
    super.key,
    required this.word,
    required this.wordHindi,
    required this.emoji,
    required this.cardColor,
    this.isCompleted = false,
    this.isLocked = false,
    this.isCurrent = false,
    this.onTap,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    Color darkerColor = _darkerShade(cardColor, 0.25);
    Color lighterColor = _lighterShade(cardColor, 0.25);

    Widget cardContent = RepaintBoundary(
      child: Tilt(
        tiltConfig: const TiltConfig(
          angle: 15,
          enableReverse: false,
        ),
        lightConfig: const LightConfig(
          color: Colors.white,
          minIntensity: 0.0,
          maxIntensity: 0.7,
        ),
        shadowConfig: ShadowConfig(
          color: cardColor.withValues(alpha: 0.6),
          maxIntensity: 0.8,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── BASE LAYER (3D depth) ──
            Positioned(
              bottom: -8, left: 2, right: 2,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: darkerColor,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),

            // ── CARD FACE ──
            Tappable(
              onTap: isLocked ? null : onTap,
              child: Container(
                width: 160, 
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cardColor, lighterColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    // Glassmorphism sheen (top edge highlight):
                    Positioned(
                      top: 0, left: 0, right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.25),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    // Floating character emoji:
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Float animation:
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 2 * pi),
                            duration: const Duration(seconds: 3),
                            builder: (ctx, t, child) {
                              return Transform.translate(
                                offset: Offset(0, sin(t) * 6),
                                child: child,
                              );
                            },
                            child: Text(emoji, style: const TextStyle(fontSize: 64)),
                          ),
                          const Spacer(),
                          // Word text:
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              children: [
                                Text(
                                  word,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(color: Colors.black26, offset: Offset(0,2), blurRadius: 4)
                                    ],
                                  ),
                                ),
                                Text(
                                  wordHindi,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Completed badge (gold star):
                    if (isCompleted)
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: AppGradients.gold,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.orange.withValues(alpha: 0.6), blurRadius: 8),
                            ],
                          ),
                          child: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                        ),
                      ),

                    // Lock overlay:
                    if (isLocked)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(Icons.lock_rounded, color: Colors.white60, size: 32),
                        ),
                      ),

                    // Pulsing ring (current):
                    if (isCurrent)
                      Positioned.fill(
                        child: _PulsingRing(color: cardColor, borderRadius: 24),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return cardContent
        .animate(delay: Duration(milliseconds: animationIndex * 80))
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.7, 0.7), end: const Offset(1,1), curve: Curves.easeOutBack);
  }

  Color _darkerShade(Color color, [double amount = 0.2]) {
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darker.toColor();
  }

  Color _lighterShade(Color color, [double amount = 0.2]) {
    final hsl = HSLColor.fromColor(color);
    final lighter = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lighter.toColor();
  }
}

class _PulsingRing extends StatefulWidget {
  final Color color;
  final double borderRadius;
  const _PulsingRing({required this.color, required this.borderRadius});

  @override
  State<_PulsingRing> createState() => _PulsingRingState();
}

class _PulsingRingState extends State<_PulsingRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.5 + (_controller.value * 0.5)),
              width: 3 + (_controller.value * 2),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _controller.value * 0.4),
                blurRadius: 10 * _controller.value,
                spreadRadius: 2 * _controller.value,
              )
            ],
          ),
        );
      },
    );
  }
}
