import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';

/// Values World — 5 Emotion characters + choice scenarios
class ValuesWorldScreen extends StatelessWidget {
  const ValuesWorldScreen({super.key});

  static const _emotions = [
    _EmotionChar(emoji: '😊', name: 'Happy Hana', hindi: 'खुश हना', color: Color(0xFF00B894),
      description: 'Hana feels happy when she helps others and plays with friends!',
      scenario: 'Your friend shares their toy with you. How do you feel?',
      choices: ['😊 Happy — and say Thank You!', '😢 Sad', '😡 Angry']),
    _EmotionChar(emoji: '😢', name: 'Sad Sam', hindi: 'उदास सैम', color: Color(0xFF0984E3),
      description: 'Sam feels sad sometimes, and that is okay. Talking helps!',
      scenario: 'You lost your favorite crayon. How do you feel?',
      choices: ['😊 Happy', '😢 Sad — and it is okay to feel sad', '😡 Angry']),
    _EmotionChar(emoji: '😡', name: 'Angry Anu', hindi: 'गुस्सा अनु', color: Color(0xFFD63031),
      description: 'Anu learns to take deep breaths when angry. Breathe in... out...',
      scenario: 'Someone took your turn in the game. What should you do?',
      choices: ['🤝 Tell them calmly it is your turn', '😡 Shout at them', '😢 Cry']),
    _EmotionChar(emoji: '😨', name: 'Scared Sara', hindi: 'डरी सारा', color: Color(0xFF6C5CE7),
      description: 'Sara knows being scared is normal. She talks to a grown-up for help!',
      scenario: 'You hear a loud thunder sound. What do you do?',
      choices: ['🏃 Run away', '👨‍👩‍👧 Go to a grown-up for comfort', '😊 Laugh']),
    _EmotionChar(emoji: '🤩', name: 'Proud Priya', hindi: 'गौरव प्रिया', color: Color(0xFFFF9F43),
      description: 'Priya feels proud when she tries hard and does her best!',
      scenario: 'You completed all your lessons today! How do you feel?',
      choices: ['🤩 Proud — I did my best!', '😢 Nothing special', '😡 Tired']),
  ];

  static const _lifeSkills = [
    _LifeSkill(emoji: '🤝', title: 'Sharing', hindi: 'बाँटना', description: 'Sharing makes everyone happy! Share toys, food, and smiles.'),
    _LifeSkill(emoji: '💝', title: 'Kindness', hindi: 'दयालुता', description: 'Be kind to everyone — animals, plants, and people!'),
    _LifeSkill(emoji: '🧼', title: 'Hygiene', hindi: 'स्वच्छता', description: 'Wash hands, brush teeth, take a bath — stay clean!'),
    _LifeSkill(emoji: '🛡️', title: 'Safety', hindi: 'सुरक्षा', description: 'Look before crossing the road. Don\'t talk to strangers.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: AppColors.valuesWorld.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.arrow_back_rounded, color: AppColors.valuesWorld)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Values World', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.valuesWorld)),
                  Text('Emotions & Life Skills', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                ])),
                const Text('🧘', style: TextStyle(fontSize: 32)),
              ]),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Emotions section
                  Text('Meet the Feelings Friends 💛', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  ..._emotions.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _emotionCard(context, e),
                  )),
                  const SizedBox(height: 20),

                  // Life skills
                  Text('Life Skills 🌟', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10, crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                    children: _lifeSkills.map((s) => Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.valuesWorld.withValues(alpha: 0.2)),
                        boxShadow: AppShadows.card,
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(s.emoji, style: const TextStyle(fontSize: 36)),
                        const SizedBox(height: 8),
                        Text(s.title, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.valuesWorld)),
                        Text(s.hindi, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
                        const SizedBox(height: 6),
                        Text(s.description, textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textMedium, height: 1.3)),
                      ]),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emotionCard(BuildContext context, _EmotionChar e) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showScenario(context, e);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [e.color, e.color.withValues(alpha: 0.7)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.soft(e.color),
        ),
        child: Row(children: [
          Text(e.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.name, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            Text(e.hindi, style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 4),
            Text(e.description, style: GoogleFonts.nunito(fontSize: 13, color: Colors.white.withValues(alpha: 0.85))),
          ])),
          const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 28),
        ]),
      ),
    );
  }

  void _showScenario(BuildContext context, _EmotionChar e) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textLight, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Text(e.emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(e.name, style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: e.color)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: e.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: e.color.withValues(alpha: 0.2)),
            ),
            child: Text(e.scenario, textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4)),
          ),
          const SizedBox(height: 16),
          ...e.choices.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
                // Show feedback
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(entry.key == 0 ? '🎉 Great choice!' : '💭 Think again!',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
                  backgroundColor: entry.key == 0 ? AppColors.success : AppColors.valuesWorld,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: entry.key == 0 ? e.color.withValues(alpha: 0.1) : AppColors.bgLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: entry.key == 0 ? e.color.withValues(alpha: 0.3) : AppColors.textLight.withValues(alpha: 0.2), width: 1.5),
                ),
                child: Text(entry.value,
                    style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              ),
            ),
          )),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ]),
      ),
    );
  }
}

class _EmotionChar {
  final String emoji, name, hindi, description, scenario;
  final Color color;
  final List<String> choices;
  const _EmotionChar({required this.emoji, required this.name, required this.hindi, required this.color,
    required this.description, required this.scenario, required this.choices});
}

class _LifeSkill {
  final String emoji, title, hindi, description;
  const _LifeSkill({required this.emoji, required this.title, required this.hindi, required this.description});
}
