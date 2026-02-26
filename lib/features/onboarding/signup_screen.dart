import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/freemium_service.dart';
import '../../shared/widgets/shared_widgets.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _obscure = true;
  bool _termsAccepted = false;
  bool _loading = false;
  int _selectedPlan = -1; // -1 = free, 0 = monthly, 1 = yearly

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); _phoneCtrl.dispose(); super.dispose(); }

  void _signup() {
    if (!_termsAccepted) return;
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty || _nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }
    setState(() => _loading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      // If a premium plan was selected, upgrade
      if (_selectedPlan >= 0) {
        final freemium = ref.read(freemiumServiceProvider);
        freemium.upgradeTo(SubscriptionTier.premium);
      }
      setState(() => _loading = false);
      context.go('/child-setup');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 32),
            // Back button
            GestureDetector(
              onTap: () => context.go('/welcome'),
              child: Container(width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark)),
            ),
            const SizedBox(height: 24),

            Text('Create Account 🚀', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textDark)),
            const SizedBox(height: 6),
            Text("Let's set up your family profile", style: GoogleFonts.nunito(fontSize: 15, color: AppColors.textMedium)),
            const SizedBox(height: 28),

            // Name
            _label('Your Name'),
            const SizedBox(height: 6),
            _field(controller: _nameCtrl, hint: 'Parent / Guardian name', icon: Icons.person_outline_rounded),
            const SizedBox(height: 16),

            // Email
            _label('Email'),
            const SizedBox(height: 6),
            _field(controller: _emailCtrl, hint: 'parent@email.com', icon: Icons.email_outlined, keyboard: TextInputType.emailAddress),
            const SizedBox(height: 16),

            // Phone (optional)
            _label('Phone (optional)'),
            const SizedBox(height: 6),
            _field(controller: _phoneCtrl, hint: '+91 98765 43210', icon: Icons.phone_outlined, keyboard: TextInputType.phone),
            const SizedBox(height: 16),

            // Password
            _label('Password'),
            const SizedBox(height: 6),
            _field(controller: _passCtrl, hint: 'At least 8 characters', icon: Icons.lock_outline_rounded,
              obscure: _obscure,
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textLight, size: 20),
              )),
            const SizedBox(height: 20),

            // ── Membership Plan ──
            Text('Choose Plan 👑', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            const SizedBox(height: 8),

            _planOption(-1, 'Free', 'A-C letters, 1 subject, limited exercises', '₹0', '🆓'),
            const SizedBox(height: 8),
            _planOption(0, 'Premium Monthly', 'All content, 400+ exercises, AI stories', '₹199/mo', '⭐'),
            const SizedBox(height: 8),
            _planOption(1, 'Premium Yearly', 'Everything unlocked — Save 58%!', '₹999/yr', '👑'),
            const SizedBox(height: 20),

            // Terms
            Row(children: [
              GestureDetector(
                onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                child: AnimatedContainer(
                  duration: AppDurations.fast, width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: _termsAccepted ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: _termsAccepted ? AppColors.primary : AppColors.textLight, width: 2)),
                  child: _termsAccepted ? const Icon(Icons.check, size: 16, color: Colors.white) : null),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text.rich(TextSpan(
                style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(text: 'Terms of Service', style: GoogleFonts.nunito(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  const TextSpan(text: ' and '),
                  TextSpan(text: 'Privacy Policy', style: GoogleFonts.nunito(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ]))),
            ]),
            const SizedBox(height: 20),

            // Create button
            PrimaryButton(
              label: _selectedPlan >= 0 ? '👑 Create Premium Account' : 'Create Free Account',
              onPressed: _signup, isLoading: _loading,
              color: _termsAccepted ? (_selectedPlan >= 0 ? AppColors.starActive : AppColors.primary) : AppColors.lockedGrey),
            const SizedBox(height: 16),

            // Divider
            Row(children: [
              Expanded(child: Container(height: 1, color: AppColors.textLight.withValues(alpha: 0.3))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('or', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textLight))),
              Expanded(child: Container(height: 1, color: AppColors.textLight.withValues(alpha: 0.3))),
            ]),
            const SizedBox(height: 16),

            // Google sign in
            GestureDetector(
              onTap: () => context.go('/child-setup'),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.textLight.withValues(alpha: 0.3), width: 1.5),
                  boxShadow: AppShadows.button3D(AppColors.textLight.withValues(alpha: 0.15))),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🔵', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text('Continue with Google', style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                ]),
              ),
            ),
            const SizedBox(height: 20),

            // Login link
            Center(child: TextButton(
              onPressed: () => context.go('/login'),
              child: RichText(text: TextSpan(
                style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(text: 'Sign in', style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: AppColors.primary)),
                ])))),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark));

  Widget _field({required TextEditingController controller, required String hint, required IconData icon,
    bool obscure = false, TextInputType? keyboard, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textLight.withValues(alpha: 0.2))),
      child: TextField(controller: controller, obscureText: obscure, keyboardType: keyboard,
        style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textDark),
        decoration: InputDecoration(hintText: hint, hintStyle: GoogleFonts.nunito(color: AppColors.textLight),
          prefixIcon: Icon(icon, color: AppColors.textMedium, size: 20), suffixIcon: suffixIcon,
          border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
    );
  }

  Widget _planOption(int index, String title, String subtitle, String price, String emoji) {
    final selected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? (index >= 0 ? AppColors.starActive.withValues(alpha: 0.08) : AppColors.primary.withValues(alpha: 0.05)) : AppColors.bgLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? (index >= 0 ? AppColors.starActive : AppColors.primary) : AppColors.textLight.withValues(alpha: 0.2), width: selected ? 2 : 1),
        ),
        child: Row(children: [
          Container(width: 22, height: 22,
            decoration: BoxDecoration(shape: BoxShape.circle,
              color: selected ? (index >= 0 ? AppColors.starActive : AppColors.primary) : Colors.transparent,
              border: Border.all(color: selected ? (index >= 0 ? AppColors.starActive : AppColors.primary) : AppColors.textLight, width: 2)),
            child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null),
          const SizedBox(width: 12),
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            Text(subtitle, style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textMedium)),
          ])),
          Text(price, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: index >= 0 ? AppColors.starActive : AppColors.primary)),
        ]),
      ),
    );
  }
}
