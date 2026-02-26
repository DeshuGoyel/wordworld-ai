import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';

/// Reusable subject world screen wrapper
class SubjectWorldScreen extends StatelessWidget {
  final String subjectId;

  const SubjectWorldScreen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    final config = _subjectConfigs[subjectId] ?? _subjectConfigs['language']!;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: config.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                      child: Icon(Icons.arrow_back_rounded, color: config.color),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(config.title, style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: config.color)),
                        Text(config.subtitle, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                      ],
                    ),
                  ),
                  Text(config.emoji, style: const TextStyle(fontSize: 32)),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DuoProgressBar(progress: 0.25, color: config.color),
            ),
            const SizedBox(height: 20),

            // Items grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85,
                ),
                itemCount: config.items.length,
                itemBuilder: (context, index) {
                  final item = config.items[index];
                  return WorldItemCard(
                    emoji: item.emoji,
                    label: item.label,
                    sublabel: item.sublabel,
                    color: config.color,
                    state: index < 3 ? WorldItemState.unlocked : (index < 5 ? WorldItemState.locked : WorldItemState.locked),
                    isPro: index >= 5,
                    stars: index < 3 ? (3 - index).clamp(0, 3) : null,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (item.route != null) context.push(item.route!);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Subject configurations ──
class _SubjectConfig {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final List<_SubjectItem> items;

  const _SubjectConfig({required this.title, required this.subtitle, required this.emoji, required this.color, required this.items});
}

class _SubjectItem {
  final String emoji;
  final String label;
  final String? sublabel;
  final String? route;

  const _SubjectItem({required this.emoji, required this.label, this.sublabel, this.route});
}

final Map<String, _SubjectConfig> _subjectConfigs = {
  'language': _SubjectConfig(
    title: 'Language World', subtitle: 'Letters, Words & Grammar', emoji: '🔤', color: AppColors.languageWorld,
    items: [
      _SubjectItem(emoji: '🔤', label: 'Letters A-Z', sublabel: '26 letters', route: '/kid-home'),
      _SubjectItem(emoji: '📝', label: 'Grammar', sublabel: '6 characters', route: '/grammar'),
      _SubjectItem(emoji: '👁️', label: 'Sight Words', sublabel: 'Level 1'),
      _SubjectItem(emoji: '🔊', label: 'Phonics', sublabel: 'Sounds'),
      _SubjectItem(emoji: '📖', label: 'Reading', sublabel: 'Stories'),
      _SubjectItem(emoji: '✍️', label: 'Writing', sublabel: 'Tracing'),
    ],
  ),
  'math': _SubjectConfig(
    title: 'Math World', subtitle: 'Numbers, Shapes & Patterns', emoji: '🔢', color: AppColors.mathWorld,
    items: [
      _SubjectItem(emoji: '1️⃣', label: 'Numbers', sublabel: '1-10', route: '/math'),
      _SubjectItem(emoji: '🔷', label: 'Shapes', sublabel: '6 shapes'),
      _SubjectItem(emoji: '🧩', label: 'Patterns', sublabel: 'ABAB'),
      _SubjectItem(emoji: '🎯', label: 'Counting', sublabel: 'Objects'),
      _SubjectItem(emoji: '➕', label: 'Addition', sublabel: 'Coming'),
      _SubjectItem(emoji: '⏰', label: 'Time', sublabel: 'Coming'),
    ],
  ),
  'evs': _SubjectConfig(
    title: 'EVS World', subtitle: 'Science & Nature', emoji: '🌿', color: AppColors.evsWorld,
    items: [
      _SubjectItem(emoji: '🧍', label: 'My Body', sublabel: '5 parts', route: '/evs'),
      _SubjectItem(emoji: '👨‍👩‍👧', label: 'My Family', sublabel: 'Family tree'),
      _SubjectItem(emoji: '🌱', label: 'Plants', sublabel: 'Coming'),
      _SubjectItem(emoji: '🐾', label: 'Animals', sublabel: 'Coming'),
      _SubjectItem(emoji: '🌤️', label: 'Weather', sublabel: 'Coming'),
      _SubjectItem(emoji: '🏠', label: 'Community', sublabel: 'Coming'),
    ],
  ),
  'values': _SubjectConfig(
    title: 'Values World', subtitle: 'Emotions & Life Skills', emoji: '🧘', color: AppColors.valuesWorld,
    items: [
      _SubjectItem(emoji: '😊', label: 'Happy', sublabel: 'Hana', route: '/values'),
      _SubjectItem(emoji: '😢', label: 'Sad', sublabel: 'Sam'),
      _SubjectItem(emoji: '😡', label: 'Angry', sublabel: 'Anu'),
      _SubjectItem(emoji: '😨', label: 'Scared', sublabel: 'Sara'),
      _SubjectItem(emoji: '🤝', label: 'Sharing', sublabel: 'Kindness'),
      _SubjectItem(emoji: '🧼', label: 'Hygiene', sublabel: 'Clean'),
    ],
  ),
};
