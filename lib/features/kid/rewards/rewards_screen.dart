import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/progress_service.dart';
import '../../../core/services/streak_service.dart';
import '../../../core/services/xp_service.dart';
import '../../../providers/app_providers.dart';
import '../../../shared/widgets/shared_widgets.dart';

const _rewardAvatarEmojis = ['🦁', '🦊', '🐼', '🐰', '🐸', '🦄', '🐶', '🐱', '🐻', '🦋'];
String _rewardEmojiForAvatarId(String? avatarId) {
  final idx = int.tryParse(avatarId?.replaceAll('avatar_', '') ?? '1') ?? 1;
  return _rewardAvatarEmojis[(idx - 1).clamp(0, _rewardAvatarEmojis.length - 1)];
}

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    final progress = ref.read(progressServiceProvider);
    final streak = ref.read(streakServiceProvider);
    final xp = ref.read(xpServiceProvider);
    final totalStars = child != null ? progress.getTotalStars(child.id) : 0;
    final skills = child != null ? progress.getSkillsBreakdown(child.id) : {'listen': 0.0, 'think': 0.0, 'speak': 0.0, 'write': 0.0, 'draw': 0.0};
    final level = xp.currentLevel;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
                    ),
                  ),
                  const Spacer(),
                  Text('My Rewards', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 24),

              // ═══ Profile Card ═══
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.strong(AppColors.primary),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                      ),
                      child: Center(child: Text(_rewardEmojiForAvatarId(child?.avatarId), style: const TextStyle(fontSize: 40))),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      child?.name ?? 'Learner',
                      style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    Text(
                      '${level.emoji} ${level.name}',
                      style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    // XP + Stars + Streak pills
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statPill('⚡', '${xp.totalXP}', 'XP'),
                        const SizedBox(width: 10),
                        _statPill('⭐', '$totalStars', 'Stars'),
                        const SizedBox(width: 10),
                        _statPill('🔥', '${streak.currentStreak}', 'Streak'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // XP Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: xp.progressToNext,
                        minHeight: 10,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${xp.totalXP} XP • ${(xp.progressToNext * 100).toInt()}% to next level',
                      style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ═══ Streak Section ═══
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Text('Streak', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.streakOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${streak.currentStreak} days',
                            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.streakOrange),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Week streak visualization
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].asMap().entries.map((e) {
                        final isActive = e.key < streak.currentStreak % 7;
                        final isToday = e.key == DateTime.now().weekday - 1;
                        return Column(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.streakOrange : (isToday ? AppColors.streakOrange.withOpacity(0.2) : AppColors.bgLight),
                                shape: BoxShape.circle,
                                border: isToday ? Border.all(color: AppColors.streakOrange, width: 2) : null,
                              ),
                              child: Center(
                                child: Text(isActive ? '🔥' : '', style: const TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(e.value, style: GoogleFonts.nunito(fontSize: 10, fontWeight: isToday ? FontWeight.w800 : FontWeight.w500, color: isToday ? AppColors.streakOrange : AppColors.textLight)),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Longest streak: ${streak.longestStreak} days',
                      style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ═══ Skills Breakdown ═══
              Align(
                alignment: Alignment.centerLeft,
                child: Text('My Skills 💪', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
                child: Column(
                  children: _buildSkillBars(skills),
                ),
              ),
              const SizedBox(height: 24),

              // ═══ Badges ═══
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Badges 🏆', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
                children: [
                  _badge('🌱', 'First Steps', 'Start learning', true),
                  _badge('🔤', 'ABC Starter', '1 letter', totalStars >= 1),
                  _badge('⭐', '10 Stars', 'Earn 10 stars', totalStars >= 10),
                  _badge('🌟', '25 Stars', 'Earn 25 stars', totalStars >= 25),
                  _badge('🔥', '3-Day Streak', '3 day streak', streak.currentStreak >= 3),
                  _badge('🏆', 'Word Master', '5 words', totalStars >= 35),
                  _badge('📚', 'Bookworm', 'Read 3 stories', false),
                  _badge('🧠', 'Brain Power', 'Complete grammar', false),
                  _badge('💯', 'Perfect Score', '3 perfect quizzes', false),
                  _badge('🎯', '50 Stars', 'Earn 50 stars', totalStars >= 50),
                  _badge('🦁', 'Explorer', 'Level 2', xp.totalXP >= 100),
                  _badge('👑', 'Champion', 'Level 5', xp.totalXP >= 1000),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statPill(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(value, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          ]),
          Text(label, style: GoogleFonts.nunito(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }

  List<Widget> _buildSkillBars(Map<String, double> skills) {
    final labels = {'listen': '🎧 Listen', 'think': '🧠 Think', 'speak': '🎤 Speak', 'write': '✍️ Write', 'draw': '🎨 Draw'};
    final colors = [AppColors.meetTab, AppColors.thinkTab, AppColors.talkTab, AppColors.writeTab, AppColors.drawTab];
    int i = 0;
    return skills.entries.map((e) {
      final color = colors[i++ % colors.length];
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            SizedBox(
              width: 85,
              child: Text(labels[e.key] ?? e.key, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
            Expanded(child: DuoProgressBar(progress: e.value, color: color, height: 12)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text('${(e.value * 100).toInt()}%', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _badge(String emoji, String title, String subtitle, bool unlocked) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: unlocked ? AppColors.starActive.withOpacity(0.08) : AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked ? AppColors.starActive.withOpacity(0.3) : AppColors.textLight.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: 28, color: unlocked ? null : Colors.grey)),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: unlocked ? AppColors.textDark : AppColors.textLight)),
          Text(subtitle, textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 9, color: AppColors.textLight)),
          if (!unlocked) const Icon(Icons.lock_rounded, size: 12, color: AppColors.textLight),
        ],
      ),
    );
  }
}
