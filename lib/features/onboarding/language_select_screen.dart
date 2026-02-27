import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/widgets/tappable.dart';

class LanguageSelectScreen extends ConsumerWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('🌍', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              const Text('Choose Language', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark, fontFamily: 'Nunito')),
              const SizedBox(height: 8),
              const Text('App bhasha chunein', style: TextStyle(fontSize: 18, color: AppColors.textMedium, fontFamily: 'Nunito')),
              const SizedBox(height: 48),
              _LanguageCard(
                title: 'English', subtitle: 'Learn in English', emoji: '🇬🇧',
                color: AppColors.primary,
                onTap: () => _selectLanguage(ref, context, 'en'),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                title: 'हिंदी', subtitle: 'हिंदी में सीखें', emoji: '🇮🇳',
                color: AppColors.secondary,
                onTap: () => _selectLanguage(ref, context, 'hi'),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                title: 'English + हिंदी', subtitle: 'Both languages / दोनों भाषाएँ', emoji: '🌐',
                color: AppColors.accent2,
                onTap: () => _selectLanguage(ref, context, 'en_hi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectLanguage(WidgetRef ref, BuildContext context, String lang) {
    ref.read(storageServiceProvider).setLanguage(lang);
    context.go('/user-type');
  }
}

class _LanguageCard extends StatelessWidget {
  final String title, subtitle, emoji;
  final Color color;
  final VoidCallback onTap;

  const _LanguageCard({required this.title, required this.subtitle, required this.emoji, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color, fontFamily: 'Nunito')),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.textMedium, fontFamily: 'Nunito')),
          ]),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, color: color),
        ]),
      ),
    );
  }
}
