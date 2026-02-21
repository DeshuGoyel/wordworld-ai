import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _dotsCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _dotsCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _logoScale = CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 500), () => _fadeCtrl.forward());
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/language-select');
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _fadeCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Dark gradient background ──
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E), Color(0xFF6C5CE7)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Neural network dots ──
          AnimatedBuilder(
            animation: _dotsCtrl,
            builder: (context, _) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _NeuralDotsPainter(_dotsCtrl.value),
            ),
          ),

          // ── Center content ──
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with glow
                ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🌍', style: TextStyle(fontSize: 48)),
                        Text('AI',
                          style: GoogleFonts.nunito(
                            fontSize: 18, fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // App name
                FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      Text(
                        'WordWorld',
                        style: GoogleFonts.nunito(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // AI badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: AppGradients.pinkPurple,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppShadows.glow(AppColors.xpPink),
                        ),
                        child: Text(
                          'AI-Powered Learning',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Every letter is a world! ✨',
                        style: GoogleFonts.nunito(fontSize: 17, color: Colors.white.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'हर अक्षर एक दुनिया है!',
                        style: GoogleFonts.nunito(fontSize: 15, color: Colors.white.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // Loading indicator
                FadeTransition(
                  opacity: _fade,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.6)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom caption ──
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fade,
              child: Text(
                'Powered by AI ✨',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 13, color: Colors.white.withOpacity(0.4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Neural dots painter ──
class _NeuralDotsPainter extends CustomPainter {
  final double progress;
  _NeuralDotsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistent positions
    final dots = <Offset>[];

    // Generate dot positions
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final y = baseY + sin(progress * pi * 2 + i * 0.5) * 15;
      dots.add(Offset(x, y));
    }

    // Draw connections between nearby dots
    final linePaint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.08)
      ..strokeWidth = 1;

    for (int i = 0; i < dots.length; i++) {
      for (int j = i + 1; j < dots.length; j++) {
        final dist = (dots[i] - dots[j]).distance;
        if (dist < 120) {
          linePaint.color = AppColors.primaryLight.withOpacity(0.06 * (1 - dist / 120));
          canvas.drawLine(dots[i], dots[j], linePaint);
        }
      }
    }

    // Draw dots
    final dotPaint = Paint()..color = AppColors.primaryLight.withOpacity(0.2);
    for (final dot in dots) {
      final radius = 2 + random.nextDouble() * 2;
      canvas.drawCircle(dot, radius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralDotsPainter old) => old.progress != progress;
}
