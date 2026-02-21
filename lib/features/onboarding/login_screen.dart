import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  void _login() {
    setState(() => _loading = true);
    // Simulated login – navigate to kid home after delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _loading = false);
        context.go('/kid-home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Back button
              GestureDetector(
                onTap: () => context.go('/welcome'),
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.bgLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
                ),
              ),
              const SizedBox(height: 32),

              // Header
              Text('Welcome back! 👋', style: GoogleFonts.nunito(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.textDark)),
              const SizedBox(height: 8),
              Text('Sign in to continue learning', style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
              const SizedBox(height: 40),

              // Email field
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildField(
                controller: _emailCtrl,
                hint: 'parent@email.com',
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // Password field
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildField(
                controller: _passCtrl,
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscure: _obscure,
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textLight, size: 20),
                ),
              ),
              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot password?', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 24),

              // Login button
              PrimaryButton(label: 'Sign In', onPressed: _login, isLoading: _loading),
              const SizedBox(height: 24),

              // Divider
              Row(children: [
                Expanded(child: Container(height: 1, color: AppColors.textLight.withOpacity(0.3))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('or', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textLight)),
                ),
                Expanded(child: Container(height: 1, color: AppColors.textLight.withOpacity(0.3))),
              ]),
              const SizedBox(height: 24),

              // Google sign in
              _buildSocialButton(
                label: 'Continue with Google',
                emoji: '🔵',
                onPressed: () => context.go('/kid-home'),
              ),
              const SizedBox(height: 32),

              // Sign up link
              Center(
                child: TextButton(
                  onPressed: () => context.go('/signup'),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(text: 'Sign up', style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark));
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboard,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(color: AppColors.textLight),
          prefixIcon: Icon(icon, color: AppColors.textMedium, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required String label, required String emoji, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textLight.withOpacity(0.3), width: 1.5),
          boxShadow: AppShadows.button3D(AppColors.textLight.withOpacity(0.15)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        ]),
      ),
    );
  }
}
