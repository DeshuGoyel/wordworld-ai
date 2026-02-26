import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/shared_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _slideCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    Future.delayed(const Duration(milliseconds: 300), () => _slideCtrl.forward());
  }

  @override
  void dispose() { _floatCtrl.dispose(); _slideCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Floating emoji shapes ──
          ..._buildFloatingEmojis(size),

          // ── Main content ──
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Hero illustration area
                _buildHeroSection(),
                const Spacer(flex: 1),
                // Bottom card
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic)),
                  child: FadeTransition(
                    opacity: _slideCtrl,
                    child: _buildBottomCard(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        // Large emoji composition
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.primaryLight.withValues(alpha: 0.04)],
                ),
              ),
            ),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.12), AppColors.accent4.withValues(alpha: 0.06)],
                ),
              ),
            ),
            const Text('🌍', style: TextStyle(fontSize: 80)),
          ],
        ),
        const SizedBox(height: 20),
        // Subject world preview row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _chip('🔤', 'Language', AppColors.languageWorld),
            const SizedBox(width: 8),
            _chip('🔢', 'Math', AppColors.mathWorld),
            const SizedBox(width: 8),
            _chip('🌿', 'EVS', AppColors.evsWorld),
            const SizedBox(width: 8),
            _chip('🧘', 'Values', AppColors.valuesWorld),
          ],
        ),
      ],
    );
  }

  Widget _chip(String emoji, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 30, offset: const Offset(0, -10))],
      ),
      child: Column(
        children: [
          Text(
            'Learn. Play. Grow.',
            style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            'English + Hindi for kids 2–7 years',
            style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium),
          ),
          const SizedBox(height: 20),

          // Feature pills row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _featurePill('👂', 'Listen'),
              const SizedBox(width: 10),
              _featurePill('🧠', 'Think'),
              const SizedBox(width: 10),
              _featurePill('🎨', 'Create'),
            ],
          ),
          const SizedBox(height: 28),

          // CTA button
          PrimaryButton(
            label: "Get Started — It's Free",
            onPressed: () => context.go('/signup'),
            icon: Icons.arrow_forward_rounded,
          ),
          const SizedBox(height: 14),

          // Sign in link
          TextButton(
            onPressed: () => context.go('/login'),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Sign in',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _featurePill(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      ]),
    );
  }

  List<Widget> _buildFloatingEmojis(Size size) {
    final emojis = ['🍎', '🐜', '✏️', '🎨', '📖', '🌟', '🔢', '🎵'];
    return List.generate(emojis.length, (i) {
      final random = Random(i * 7);
      final x = random.nextDouble() * (size.width - 40);
      final baseY = random.nextDouble() * (size.height * 0.4);

      return AnimatedBuilder(
        animation: _floatCtrl,
        builder: (context, child) {
          final y = baseY - (_floatCtrl.value * 60 + i * 20) % (size.height * 0.5);
          final opacity = (1 - y.abs() / (size.height * 0.5)).clamp(0.05, 0.2);
          return Positioned(
            left: x,
            top: y.clamp(0, size.height),
            child: Opacity(
              opacity: opacity,
              child: Text(emojis[i], style: TextStyle(fontSize: 24 + random.nextDouble() * 14)),
            ),
          );
        },
      );
    });
  }
}
