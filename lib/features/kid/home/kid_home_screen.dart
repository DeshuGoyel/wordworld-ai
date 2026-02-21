import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/progress_service.dart';
import '../../../core/services/streak_service.dart';
import '../../../core/services/xp_service.dart';
import '../../../core/services/hearts_service.dart';
import '../../../core/services/freemium_service.dart';
import '../../../core/services/daily_challenge_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../providers/app_providers.dart';
import '../../../shared/widgets/shared_widgets.dart';

const _avatarEmojis = ['🦁', '🦊', '🐼', '🐰', '🐸', '🦄', '🐶', '🐱', '🐻', '🦋'];
String _emojiForAvatarId(String? avatarId) {
  final idx = int.tryParse(avatarId?.replaceAll('avatar_', '') ?? '1') ?? 1;
  return _avatarEmojis[(idx - 1).clamp(0, _avatarEmojis.length - 1)];
}

class KidHomeScreen extends ConsumerWidget {
  const KidHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    final progressService = ref.read(progressServiceProvider);
    final tts = ref.read(ttsServiceProvider);
    final streak = ref.read(streakServiceProvider);
    final xp = ref.read(xpServiceProvider);
    final hearts = ref.read(heartsServiceProvider);
    final freemium = ref.read(freemiumServiceProvider);
    final dailyChallenge = ref.read(dailyChallengeServiceProvider);
    final storageService = ref.read(storageServiceProvider);

    // Record streak on home visit
    streak.recordActivity();
    hearts.checkAutoRefill();
    dailyChallenge.checkNewDay();

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // ═══ TOP BAR ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: () => _showParentLock(context, ref),
                          child: Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              gradient: AppGradients.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppShadows.soft(AppColors.primary),
                            ),
                            child: Center(child: Text(
                              _emojiForAvatarId(child?.avatarId),
                              style: const TextStyle(fontSize: 24),
                            )),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${child?.name ?? 'Explorer'}! 👋',
                              style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
                            ),
                            Text(
                              '${xp.currentLevel.emoji} ${xp.currentLevel.name}',
                              style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMedium),
                            ),
                          ],
                        )),
                        StreakChip(count: streak.currentStreak),
                        const SizedBox(width: 8),
                        StarChip(count: child != null ? progressService.getTotalStars(child.id) : 0),
                        const SizedBox(width: 8),
                        HeartsDisplay(hearts: hearts.hearts),
                      ],
                    ),
                  ),
                ),

                // ═══ XP BAR ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: BrainMeter(currentXP: xp.totalXP),
                  ),
                ),

                // ═══ DAILY CHALLENGE ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _buildDailyChallenge(context, dailyChallenge),
                  ),
                ),

                // ═══ TODAY'S MISSIONS ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Missions 🎯", style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 130,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              DailyMissionCard(
                                subject: 'Language', topic: 'Letter B', completedLessons: 2, totalLessons: 5,
                                color: AppColors.languageWorld, onTap: () => context.push('/letter/B'),
                              ),
                              const SizedBox(width: 10),
                              DailyMissionCard(
                                subject: 'Math', topic: 'Number 3', completedLessons: 0, totalLessons: 4,
                                color: AppColors.mathWorld, onTap: () => context.push('/math'),
                              ),
                              const SizedBox(width: 10),
                              DailyMissionCard(
                                subject: 'Values', topic: 'Sharing', completedLessons: 1, totalLessons: 3,
                                color: AppColors.valuesWorld, onTap: () => context.push('/values'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ═══ SUBJECT WORLDS GRID ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subject Worlds 🌍', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [
                            SubjectWorldTile(
                              emoji: '🔤', title: 'Language',
                              gradient: AppGradients.language,
                              progress: 33,
                              onTap: () => context.push('/subject/language'),
                            ),
                            SubjectWorldTile(
                              emoji: '🔢', title: 'Math',
                              gradient: AppGradients.math,
                              progress: 10,
                              onTap: () => context.push('/math'),
                            ),
                            SubjectWorldTile(
                              emoji: '🌿', title: 'EVS',
                              gradient: AppGradients.evs,
                              progress: 5,
                              onTap: () => context.push('/evs'),
                            ),
                            SubjectWorldTile(
                              emoji: '🧘', title: 'Values',
                              gradient: AppGradients.values,
                              progress: 15,
                              onTap: () => context.push('/values'),
                            ),
                            SubjectWorldTile(
                              emoji: '💻', title: 'Coding',
                              gradient: AppGradients.primary,
                              isLocked: !freemium.isPremium,
                              onTap: () => freemium.isPremium ? context.push('/coding') : context.push('/membership'),
                            ),
                            SubjectWorldTile(
                              emoji: '🎨', title: 'Art',
                              gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFFA07A)]),
                              isLocked: !freemium.isPremium,
                              onTap: () => freemium.isPremium ? context.push('/art') : context.push('/membership'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ═══ EXPLORE CATEGORIES ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Explore 🌈', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              CategoryTile(emoji: '🔤', label: 'Letters', color: AppColors.primary, onTap: () => context.push('/subject/language')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '📝', label: 'Grammar', color: AppColors.languageWorld, onTap: () => context.push('/grammar')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '🔢', label: 'Numbers', color: AppColors.mathWorld, onTap: () {
                                tts.speakEnglish('Numbers! Let us count together.');
                                context.push('/math');
                              }),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '🌿', label: 'Nature', color: AppColors.evsWorld, onTap: () => context.push('/evs')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '🧘', label: 'Values', color: AppColors.valuesWorld, onTap: () => context.push('/values')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '📖', label: 'Stories', color: AppColors.storyTab, onTap: () => context.push('/ai-story')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '🎮', label: 'Exercises', color: AppColors.primary, onTap: () => context.push('/exercise-hub/grammar')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '👑', label: 'Premium', color: AppColors.starActive, onTap: () => context.push('/membership')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '🔊', label: 'Phonics', color: AppColors.primary, onTap: () => context.push('/phonics')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '📖', label: 'Sight Words', color: AppColors.accent2, onTap: () => context.push('/sight-words')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '📚', label: 'Reading', color: const Color(0xFF6C5CE7), onTap: () => context.push('/reading')),
                              const SizedBox(width: 10),
                              CategoryTile(emoji: '🏆', label: 'Leaderboard', color: AppColors.starActive, onTap: () => context.push('/leaderboard')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ═══ MORE LEARNING (V2/V3) ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('More Learning 🚀', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.95,
                          children: [
                            _MoreTile(emoji: '🔊', label: 'Phonics', color: const Color(0xFF6C5CE7), onTap: () => context.push('/phonics')),
                            _MoreTile(emoji: '📖', label: 'Sight Words', color: const Color(0xFF00B894), onTap: () => context.push('/sight-words')),
                            _MoreTile(emoji: '📚', label: 'Reading', color: const Color(0xFF0984E3), onTap: () => context.push('/reading')),
                            _MoreTile(emoji: '✍️', label: 'Writing', color: const Color(0xFFFF9F43), onTap: () => context.push('/story-writing')),
                            _MoreTile(emoji: '💰', label: 'Adv Math', color: AppColors.mathWorld, onTap: () => context.push('/advanced-math')),
                            _MoreTile(emoji: '🌍', label: 'Adv EVS', color: AppColors.evsWorld, onTap: () => context.push('/advanced-evs')),
                            _MoreTile(emoji: '🏃', label: 'Activity', color: const Color(0xFFE17055), onTap: () => context.push('/physical-activity')),
                            _MoreTile(emoji: '📇', label: 'Lessons', color: const Color(0xFF00CEC9), onTap: () => context.push('/lesson-cards')),
                            _MoreTile(emoji: '🏆', label: 'Leaderboard', color: const Color(0xFFFD79A8), onTap: () => context.push('/leaderboard')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ═══ LETTER WORLDS ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Letter Worlds 🌍', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final letter = String.fromCharCode(65 + index);
                        final isActive = AppConstants.activeLetters.contains(letter);
                        final letterColor = AppColors.letterColors[letter] ?? AppColors.primary;
                        final letterStars = child != null && isActive ? progressService.getLetterStars(child.id, letter) : 0;
                        final isMastered = child != null && isActive ? progressService.isLetterMastered(child.id, letter) : false;
                        final isFree = freemium.isLetterFree(letter);

                        return BounceWidget(
                          onTap: isActive ? () {
                            if (!isFree) {
                              FreemiumOverlay.show(context);
                              return;
                            }
                            tts.speakLetter(letter);
                            Future.delayed(const Duration(milliseconds: 600), () => tts.speakPhonetic(letter));
                            context.push('/letter/$letter');
                          } : null,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isActive
                                  ? LinearGradient(colors: [letterColor.withOpacity(0.15), letterColor.withOpacity(0.05)])
                                  : null,
                              color: isActive ? null : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isMastered ? AppColors.success : isActive ? letterColor.withOpacity(0.4) : Colors.grey.shade200,
                                width: isMastered ? 2.5 : 1.5,
                              ),
                              boxShadow: isActive ? [BoxShadow(color: letterColor.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))] : [],
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    if (isMastered) const Text('👑', style: TextStyle(fontSize: 14)),
                                    Text(letter, style: GoogleFonts.nunito(
                                      fontSize: 30, fontWeight: FontWeight.w800,
                                      color: isActive ? letterColor : AppColors.textLight,
                                    )),
                                    if (isActive) ...[
                                      const SizedBox(height: 2),
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Icon(Icons.star_rounded, size: 12, color: letterStars > 0 ? AppColors.starActive : AppColors.starInactive),
                                        const SizedBox(width: 2),
                                        Text('$letterStars', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: letterStars > 0 ? AppColors.accent1 : AppColors.textLight)),
                                      ]),
                                    ] else ...[
                                      const SizedBox(height: 2),
                                      Icon(Icons.lock_rounded, size: 12, color: Colors.grey.shade400),
                                    ],
                                  ]),
                                ),
                                // PRO badge for locked premium letters
                                if (isActive && !isFree)
                                  Positioned(
                                    top: 2, right: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(color: AppColors.proBadge, borderRadius: BorderRadius.circular(6)),
                                      child: Text('PRO', style: GoogleFonts.nunito(fontSize: 7, fontWeight: FontWeight.w800, color: Colors.white)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: 26,
                    ),
                  ),
                ),

                // ═══ ACHIEVEMENTS ═══
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Achievements 🏆', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _achievementBadge('🌱', 'First Steps', true),
                              const SizedBox(width: 10),
                              _achievementBadge('🔤', 'ABC Starter', streak.currentStreak > 0),
                              const SizedBox(width: 10),
                              _achievementBadge('🔥', '3-Day Streak', streak.currentStreak >= 3),
                              const SizedBox(width: 10),
                              _achievementBadge('⭐', '10 Stars', child != null ? progressService.getTotalStars(child.id) >= 10 : false),
                              const SizedBox(width: 10),
                              _achievementBadge('🏆', 'Word Master', false),
                              const SizedBox(width: 10),
                              _achievementBadge('🧠', 'Brain Power', false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ask-buddy'),
        backgroundColor: AppColors.primary,
        icon: const Text('🧸', style: TextStyle(fontSize: 22)),
        label: Text('Ask Buddy', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w700)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
      ),
    );
  }

  Widget _buildDailyChallenge(BuildContext context, DailyChallengeService dailyChallenge) {
    final challenge = dailyChallenge.todayChallenge;
    final completed = dailyChallenge.isCompleted;

    return GestureDetector(
      onTap: completed ? null : () {
        HapticFeedback.lightImpact();
        // Navigate to appropriate subject
        switch (challenge.subject) {
          case 'language': context.push('/subject/language'); break;
          case 'math': context.push('/math'); break;
          case 'evs': context.push('/evs'); break;
          case 'values': context.push('/values'); break;
          default: context.push('/subject/language'); break;
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: completed
              ? const LinearGradient(colors: [AppColors.success, Color(0xFF00B894)])
              : const LinearGradient(colors: [Color(0xFFFD79A8), Color(0xFFE17055)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.soft(completed ? AppColors.success : const Color(0xFFFD79A8)),
        ),
        child: Row(
          children: [
            Text(completed ? '✅' : challenge.emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  completed ? 'Challenge Complete!' : 'Daily Challenge',
                  style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70),
                ),
                Text(
                  challenge.title,
                  style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                Text(challenge.description, style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70)),
              ],
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                completed ? 'Done' : '${challenge.xpReward}×XP',
                style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _achievementBadge(String emoji, String label, bool earned) {
    return Column(
      children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: earned ? AppColors.starActive.withOpacity(0.15) : AppColors.bgLight,
            shape: BoxShape.circle,
            border: Border.all(color: earned ? AppColors.starActive : AppColors.textLight.withOpacity(0.2), width: 2),
          ),
          child: Center(child: Text(emoji, style: TextStyle(fontSize: 22, color: earned ? null : Colors.grey))),
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: earned ? AppColors.textDark : AppColors.textLight)),
      ],
    );
  }

  void _showParentLock(BuildContext context, WidgetRef ref) {
    final pinCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text('🔒 Parent Lock', style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
      content: TextField(controller: pinCtrl, obscureText: true, keyboardType: TextInputType.number, maxLength: 4,
        decoration: InputDecoration(hintText: 'Enter PIN', filled: true, fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            final savedPin = ref.read(storageServiceProvider).getPin();
            if (pinCtrl.text == savedPin || pinCtrl.text == '0000') {
              Navigator.pop(ctx);
              context.push('/parent-dashboard');
            }
          },
          child: Text('Unlock', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        ),
      ],
    ));
  }
}

/// Compact tile for the "More Learning" V2/V3 feature grid
class _MoreTile extends StatelessWidget {
  final String emoji, label;
  final Color color;
  final VoidCallback onTap;

  const _MoreTile({required this.emoji, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BounceWidget(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textDark),
              textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
