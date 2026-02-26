import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';

/// Grammar World — 6 character-driven grammar modules
class GrammarWorldScreen extends StatelessWidget {
  const GrammarWorldScreen({super.key});

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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppColors.languageWorld.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.arrow_back_rounded, color: AppColors.languageWorld),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Grammar Friends', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.languageWorld)),
                    Text('Meet the word helpers!', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                  ])),
                  const Text('📝', style: TextStyle(fontSize: 32)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _characterCard(
                    context, 'NORA', 'The Noun Navigator', '🏷️',
                    'I name everything! People, places, things…',
                    AppColors.noraNoun, '/grammar/nouns',
                    ['Apple', 'Dog', 'School', 'Love'],
                  ),
                  const SizedBox(height: 12),
                  _characterCard(
                    context, 'VERA', 'The Verb Vroom', '🏃',
                    'I make things HAPPEN! Run, jump, eat!',
                    AppColors.veraVerb, '/grammar/verbs',
                    ['Run', 'Eat', 'Sleep', 'Play'],
                  ),
                  const SizedBox(height: 12),
                  _characterCard(
                    context, 'ADA', 'The Adjective Artist', '🎨',
                    'I describe everything beautifully!',
                    AppColors.adaAdjective, '/grammar/adjectives',
                    ['Big', 'Red', 'Happy', 'Tall'],
                  ),
                  const SizedBox(height: 12),
                  _characterCard(
                    context, 'PETE', 'The Preposition Pilot', '✈️',
                    'I tell you WHERE! On, in, under, between…',
                    AppColors.petePre, '/grammar/prepositions',
                    ['On', 'In', 'Under', 'Near'],
                  ),
                  const SizedBox(height: 12),
                  _characterCard(
                    context, 'PATTY', 'The Pronoun Partner', '🤝',
                    'I replace names! He, she, it, they…',
                    AppColors.pattyPro, '/grammar/pronouns',
                    ['He', 'She', 'It', 'They'],
                  ),
                  const SizedBox(height: 12),
                  _characterCard(
                    context, 'FRED', 'The Sentence Builder', '🏗️',
                    'I put words together into sentences!',
                    AppColors.fredFull, '/grammar/sentences',
                    ['The + dog + runs', 'I + eat + food'],
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

  Widget _characterCard(BuildContext context, String name, String title, String emoji,
      String description, Color color, String route, List<String> examples) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.soft(color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                  Text(title, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70)),
                ])),
                const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 28),
              ],
            ),
            const SizedBox(height: 10),
            Text(description, style: GoogleFonts.nunito(fontSize: 14, color: Colors.white.withValues(alpha: 0.9))),
            const SizedBox(height: 10),
            // Example chips
            Wrap(
              spacing: 6, runSpacing: 6,
              children: examples.map((e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: Text(e, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
