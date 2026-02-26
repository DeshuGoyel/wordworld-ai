import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/shared_widgets.dart';

class ChildSetupScreen extends StatefulWidget {
  const ChildSetupScreen({super.key});
  @override
  State<ChildSetupScreen> createState() => _ChildSetupScreenState();
}

class _ChildSetupScreenState extends State<ChildSetupScreen> {
  final _nameCtrl = TextEditingController();
  int _selectedAge = 4;
  int _selectedAvatar = 0;
  String _language = 'both';

  final _avatars = ['🦁', '🐰', '🦊', '🐼', '🐸', '🦋', '🐱', '🐶', '🦄', '🐯', '🐵', '🐻'];

  @override
  void dispose() { _nameCtrl.dispose(); super.dispose(); }

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
              const SizedBox(height: 32),
              // Back
              GestureDetector(
                onTap: () => context.go('/signup'),
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
                ),
              ),
              const SizedBox(height: 28),

              // Header
              Text("Who's learning? 🎒", style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textDark)),
              const SizedBox(height: 6),
              Text("Set up your child's profile", style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
              const SizedBox(height: 32),

              // ── Child nickname ──
              _sectionTitle('Nickname'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.textLight.withValues(alpha: 0.2)),
                ),
                child: TextField(
                  controller: _nameCtrl,
                  style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: "Child's name",
                    hintStyle: GoogleFonts.nunito(color: AppColors.textLight),
                    prefixIcon: const Icon(Icons.child_care_rounded, color: AppColors.primary, size: 22),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Age picker ──
              _sectionTitle('Age'),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final age = i + 2; // 2,3,4,5,6,7
                    final selected = _selectedAge == age;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedAge = age);
                      },
                      child: AnimatedContainer(
                        duration: AppDurations.fast,
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.bgLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: selected ? AppColors.primary : AppColors.textLight.withValues(alpha: 0.2), width: 2),
                          boxShadow: selected ? AppShadows.button3D(AppColors.primaryDark) : [],
                        ),
                        child: Center(
                          child: Text(
                            '$age',
                            style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: selected ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // ── Avatar selection ──
              _sectionTitle('Choose Avatar'),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, crossAxisSpacing: 10, mainAxisSpacing: 10,
                ),
                itemCount: _avatars.length,
                itemBuilder: (_, i) {
                  final selected = _selectedAvatar == i;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedAvatar = i);
                    },
                    child: AnimatedContainer(
                      duration: AppDurations.fast,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.bgLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? AppColors.primary : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: Center(child: Text(_avatars[i], style: const TextStyle(fontSize: 28))),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              // ── Language preference ──
              _sectionTitle('Language'),
              const SizedBox(height: 12),
              Row(
                children: [
                  _langOption('EN', 'English', 'en'),
                  const SizedBox(width: 10),
                  _langOption('HI', 'हिंदी', 'hi'),
                  const SizedBox(width: 10),
                  _langOption('🌐', 'Both', 'both'),
                ],
              ),
              const SizedBox(height: 36),

              // ── CTA ──
              PrimaryButton(
                label: 'Start Learning! 🚀',
                onPressed: () => context.go('/kid-home'),
                color: AppColors.success,
                icon: Icons.play_arrow_rounded,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark));
  }

  Widget _langOption(String emoji, String label, String value) {
    final selected = _language == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _language = value);
        },
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.bgLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? AppColors.primary : AppColors.textLight.withValues(alpha: 0.2), width: 2),
            boxShadow: selected ? AppShadows.button3D(AppColors.primaryDark) : [],
          ),
          child: Column(children: [
            Text(emoji, style: TextStyle(fontSize: selected ? 20 : 18)),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.nunito(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.textDark,
            )),
          ]),
        ),
      ),
    );
  }
}
