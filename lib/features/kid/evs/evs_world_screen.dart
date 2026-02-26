import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';

/// EVS World — My Body, My Family topics
class EVSWorldScreen extends StatelessWidget {
  const EVSWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: AppColors.evsWorld.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.arrow_back_rounded, color: AppColors.evsWorld)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('EVS World', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.evsWorld)),
                  Text('Science & Nature', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                ])),
                const Text('🌿', style: TextStyle(fontSize: 32)),
              ]),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // My Body
                  _topicCard(context, '🧍', 'My Body', 'Learn about body parts!', AppColors.evsWorld, [
                    _BodyPart(emoji: '👀', name: 'Eyes', hindi: 'आँखें', fact: 'We see with our eyes. They can be brown, blue, or green!'),
                    _BodyPart(emoji: '👂', name: 'Ears', hindi: 'कान', fact: 'We hear sounds with our ears. Two ears help us know where sounds come from!'),
                    _BodyPart(emoji: '👃', name: 'Nose', hindi: 'नाक', fact: 'We smell with our nose. It also helps us breathe!'),
                    _BodyPart(emoji: '👄', name: 'Mouth', hindi: 'मुँह', fact: 'We eat, drink, and talk with our mouth!'),
                    _BodyPart(emoji: '🖐️', name: 'Hands', hindi: 'हाथ', fact: 'We have 5 fingers on each hand. We use them to hold and touch!'),
                  ]),
                  const SizedBox(height: 16),

                  // My Family
                  _topicCard(context, '👨‍👩‍👧', 'My Family', 'Learn about family members!', const Color(0xFFE17055), [
                    _BodyPart(emoji: '👨', name: 'Father', hindi: 'पिता', fact: 'Father is also called Papa or Dad!'),
                    _BodyPart(emoji: '👩', name: 'Mother', hindi: 'माँ', fact: 'Mother is also called Mama or Mom!'),
                    _BodyPart(emoji: '👴', name: 'Grandfather', hindi: 'दादा/नाना', fact: "Father's father or Mother's father!"),
                    _BodyPart(emoji: '👵', name: 'Grandmother', hindi: 'दादी/नानी', fact: "Father's mother or Mother's mother!"),
                    _BodyPart(emoji: '👧', name: 'Sister', hindi: 'बहन', fact: 'A girl who has the same parents as you!'),
                    _BodyPart(emoji: '👦', name: 'Brother', hindi: 'भाई', fact: 'A boy who has the same parents as you!'),
                  ]),
                  const SizedBox(height: 16),

                  // Locked topics
                  _lockedTopicCard(context, '🌱', 'Plants', 'Coming in v2'),
                  const SizedBox(height: 12),
                  _lockedTopicCard(context, '🐾', 'Animals', 'Coming in v2'),
                  const SizedBox(height: 12),
                  _lockedTopicCard(context, '🌤️', 'Weather', 'Coming in v2'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topicCard(BuildContext context, String emoji, String title, String desc, Color color, List<_BodyPart> parts) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showTopicDetail(context, emoji, title, color, parts);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.soft(color),
        ),
        child: Row(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
            Text(desc, style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70)),
            const SizedBox(height: 6),
            Text('${parts.length} items', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white54)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 28),
        ]),
      ),
    );
  }

  Widget _lockedTopicCard(BuildContext context, String emoji, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lockedGrey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lockedGrey.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textLight)),
          Text(desc, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textLight)),
        ])),
        const Icon(Icons.lock_rounded, color: AppColors.textLight, size: 20),
      ]),
    );
  }

  void _showTopicDetail(BuildContext context, String emoji, String title, Color color, List<_BodyPart> parts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: ListView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(24),
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textLight, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
              const SizedBox(height: 8),
              Center(child: Text(title, style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: color))),
              const SizedBox(height: 20),
              ...parts.map((p) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withValues(alpha: 0.15)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(p.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
                      Text(p.hindi, style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
                    ])),
                  ]),
                  const SizedBox(height: 8),
                  Text(p.fact, style: GoogleFonts.nunito(fontSize: 14, height: 1.4, color: AppColors.textDark)),
                ]),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyPart {
  final String emoji, name, hindi, fact;
  const _BodyPart({required this.emoji, required this.name, required this.hindi, required this.fact});
}
