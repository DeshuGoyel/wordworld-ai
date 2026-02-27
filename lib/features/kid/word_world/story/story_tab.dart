import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/app_providers.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/services/story_service.dart';
import 'package:learn_app/core/models/story_models.dart';
import 'package:learn_app/core/services/purchase_service.dart';
import 'package:learn_app/core/widgets/tappable.dart';
import '../../story_generator/story_generator_screen.dart';
import '../../story_generator/story_player_screen.dart';
import '../../../paywall/paywall_sheet.dart';

class StoryTab extends ConsumerWidget {
  final WordData word;
  
  const StoryTab({super.key, required this.word});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read premium status from PurchaseService
    final purchaseService = ref.watch(purchaseServiceProvider);
    final isPremium = purchaseService.isPremium;

    final savedStories = StoryService.instance.getSavedStories()
        .where((s) => s.heroName == word.word)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // GYANI INTRO:
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
            ),
            child: Row(
              children: [
                const Text('🦉', style: TextStyle(fontSize: 48)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Story Time! 📖', style: AppFonts.headingStyle(size: 32).copyWith(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text('Create a story with ${word.word}!', style: AppFonts.bodyStyle(size: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // PREVIOUS STORIES (if any):
          if (savedStories.isNotEmpty) ...[
            Text('Your Stories', style: AppFonts.headingStyle(size: 24)),
            const SizedBox(height: 12),
            ...savedStories.map((story) => _SavedStoryCard(
              story: story,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => StoryPlayerScreen(story: story, word: word),
              )),
            )),
            const SizedBox(height: 16),
          ],
          
          // LOCKED overlay if !isPremium:
          if (!isPremium)
            Tappable(
              onTap: () async {
                 final unlocked = await PaywallSheet.checkAndShow(context, ref, 'AI Story Generator');
                 if (unlocked) {
                    // PurchaseService triggers rebuild manually, or riverpod picks it up
                    // Just triggering state refresh
                    ref.invalidate(purchaseServiceProvider);
                 }
              },
              child: _PremiumLockedCard(
                feature: 'AI Story Generator',
                emoji: '📖',
              ),
            )
          else ...[
            // CREATE NEW STORY BUTTON:
            const SizedBox(height: 16),
            PrimaryButton3D(
              label: '✨ Create New Story',
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => StoryGeneratorScreen(word: word),
              )),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // XP info:
          _XPInfoCard('+15 XP for completing a story! 🌟'),
        ],
      ),
    );
  }
}

class _SavedStoryCard extends StatelessWidget {
  final StoryData story;
  final VoidCallback onTap;

  const _SavedStoryCard({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BounceWidget(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.storyTab.withOpacity(0.3), width: 2),
          boxShadow: AppShadows.soft(AppColors.storyTab),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.storyTab.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Text('📖', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title, style: AppFonts.headingStyle(size: 20)),
                  const SizedBox(height: 4),
                  Text(_getPreview(), style: AppFonts.bodyStyle(size: 14).copyWith(color: AppColors.textMedium), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.storyTab, size: 20),
          ],
        ),
      ),
    );
  }

  String _getPreview() {
    if (story.scenes.isEmpty) return 'A magical adventure...';
    final text = story.scenes.first.textEn;
    return text.length > 40 ? '${text.substring(0, 40)}...' : text;
  }
}

class _PremiumLockedCard extends StatelessWidget {
  final String feature, emoji;
  const _PremiumLockedCard({required this.feature, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textMedium.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text('🔒', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(feature, style: AppFonts.headingStyle(size: 20)),
          const SizedBox(height: 8),
          Text('Unlock to create custom stories!', style: AppFonts.bodyStyle(size: 14)),
        ],
      ),
    );
  }
}

class _XPInfoCard extends StatelessWidget {
  final String text;
  const _XPInfoCard(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: AppFonts.headingStyle(size: 20).copyWith(color: AppColors.success, fontSize: 14)),
        ],
      ),
    );
  }
}
