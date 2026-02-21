import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/freemium_service.dart';
import '../../../shared/widgets/shared_widgets.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  const MembershipScreen({super.key});
  @override
  ConsumerState<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> {
  int _selectedPlan = 1; // 0=monthly, 1=yearly, 2=school
  bool _purchasing = false;

  @override
  Widget build(BuildContext context) {
    final freemium = ref.read(freemiumServiceProvider);
    final isPremium = freemium.isPremium;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Header
            Row(children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
              ),
              const Spacer(),
              Text('Premium', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
              const Spacer(),
              const SizedBox(width: 44),
            ]),
            const SizedBox(height: 24),

            // Crown badge
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                gradient: AppGradients.gold,
                shape: BoxShape.circle,
                boxShadow: AppShadows.glow(AppColors.starActive),
              ),
              child: const Center(child: Text('👑', style: TextStyle(fontSize: 48))),
            ),
            const SizedBox(height: 16),

            if (isPremium) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(20)),
                child: Text('✅ You are Premium!', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              Text('All content is unlocked', style: GoogleFonts.nunito(fontSize: 14, color: Colors.white70)),
            ] else ...[
              Text('Unlock Everything!', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 8),
              Text('Give your child the complete learning experience', style: GoogleFonts.nunito(fontSize: 14, color: Colors.white60), textAlign: TextAlign.center),
            ],
            const SizedBox(height: 28),

            // Benefits
            _benefitRow('🔤', 'All 26 Letters', 'Full A-Z letter worlds'),
            _benefitRow('📚', 'All Subjects', 'Grammar, Math, EVS, Values'),
            _benefitRow('🎮', '400+ Exercises', '100 per subject, 10 levels'),
            _benefitRow('📖', 'AI Story Generator', 'Unlimited custom stories'),
            _benefitRow('🖨️', 'Unlimited Prints', 'Worksheets & flashcards'),
            _benefitRow('📊', 'Full Dashboard', 'Detailed progress reports'),
            _benefitRow('🏆', 'All Achievements', 'Badges & rewards'),
            _benefitRow('💝', 'No Ads', 'Ad-free experience'),
            const SizedBox(height: 28),

            if (!isPremium) ...[
              // Plan selector
              _planCard(0, '₹199/month', 'Monthly', 'Cancel anytime', false),
              const SizedBox(height: 10),
              _planCard(1, '₹999/year', 'Yearly', 'Save 58%! Best value', true),
              const SizedBox(height: 10),
              _planCard(2, '₹4,999/year', 'School', 'Entire class access', false),
              const SizedBox(height: 24),

              // Purchase button
              PrimaryButton(
                label: _purchasing ? 'Processing...' : '👑 Upgrade Now',
                onPressed: _purchase,
                isLoading: _purchasing,
                color: AppColors.starActive,
              ),
              const SizedBox(height: 12),
              Text('7-day free trial • Cancel anytime', style: GoogleFonts.nunito(fontSize: 12, color: Colors.white38)),
            ],
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  Widget _benefitRow(String emoji, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          Text(desc, style: GoogleFonts.nunito(fontSize: 12, color: Colors.white54)),
        ])),
        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
      ]),
    );
  }

  Widget _planCard(int index, String price, String period, String subtitle, bool popular) {
    final selected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.starActive.withOpacity(0.15) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.starActive : Colors.white.withOpacity(0.1), width: selected ? 2 : 1),
        ),
        child: Row(children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.starActive : Colors.transparent,
              border: Border.all(color: selected ? AppColors.starActive : Colors.white30, width: 2),
            ),
            child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(period, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              if (popular) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.starActive, borderRadius: BorderRadius.circular(8)),
                  child: Text('BEST', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ],
            ]),
            Text(subtitle, style: GoogleFonts.nunito(fontSize: 12, color: Colors.white54)),
          ])),
          Text(price, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: selected ? AppColors.starActive : Colors.white70)),
        ]),
      ),
    );
  }

  void _purchase() {
    setState(() => _purchasing = true);
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final freemium = ref.read(freemiumServiceProvider);
      final tier = _selectedPlan == 2 ? SubscriptionTier.school : SubscriptionTier.premium;
      freemium.upgradeTo(tier);
      setState(() => _purchasing = false);
      // Show success
      showDialog(context: context, builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎉', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 12),
          Text('Welcome to Premium!', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('All content is now unlocked!', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Start Learning!', onPressed: () {
            Navigator.pop(ctx);
            context.go('/kid-home');
          }),
        ]),
      ));
    });
  }
}
