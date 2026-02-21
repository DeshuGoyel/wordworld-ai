import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('👋', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              const Text('Who is using this app?', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark, fontFamily: 'Nunito')),
              const SizedBox(height: 8),
              const Text('यह ऐप कौन इस्तेमाल कर रहा है?', style: TextStyle(fontSize: 16, color: AppColors.textMedium, fontFamily: 'Nunito')),
              const SizedBox(height: 48),
              _TypeCard(
                emoji: '👨‍👩‍👧', title: 'Parent', titleHi: 'अभिभावक',
                subtitle: 'Set up for your child at home', color: AppColors.primary,
                onTap: () => context.go('/parent-onboarding'),
              ),
              const SizedBox(height: 20),
              _TypeCard(
                emoji: '👩‍🏫', title: 'Teacher', titleHi: 'शिक्षक',
                subtitle: 'Set up for your classroom', color: AppColors.accent2,
                onTap: () => context.go('/teacher-onboarding'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatefulWidget {
  final String emoji, title, titleHi, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _TypeCard({required this.emoji, required this.title, required this.titleHi, required this.subtitle, required this.color, required this.onTap});
  @override
  State<_TypeCard> createState() => _TypeCardState();
}

class _TypeCardState extends State<_TypeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.color.withOpacity(0.3), width: 2),
          boxShadow: [BoxShadow(color: widget.color.withOpacity(_pressed ? 0.05 : 0.15), blurRadius: 16, offset: Offset(0, _pressed ? 2 : 6))],
        ),
        child: Row(children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: widget.color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: Center(child: Text(widget.emoji, style: const TextStyle(fontSize: 36))),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: widget.color, fontFamily: 'Nunito')),
            Text(widget.titleHi, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: widget.color.withOpacity(0.7), fontFamily: 'Nunito')),
            const SizedBox(height: 4),
            Text(widget.subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textMedium, fontFamily: 'Nunito')),
          ])),
          Icon(Icons.arrow_forward_ios_rounded, color: widget.color),
        ]),
      ),
    );
  }
}
