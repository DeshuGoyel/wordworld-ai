import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/xp_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import 'package:learn_app/core/widgets/tappable.dart';

/// Class Leaderboard — rankings, friends, XP comparison
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xp = ref.watch(xpServiceProvider);

    // Simulated leaderboard data
    final players = [
      {'name': 'Aarav', 'avatar': '🦁', 'xp': 2850, 'level': 'Champion', 'streak': 15},
      {'name': 'Priya', 'avatar': '🦋', 'xp': 2720, 'level': 'Champion', 'streak': 12},
      {'name': 'Rohan', 'avatar': '🐯', 'xp': 2580, 'level': 'Master', 'streak': 10},
      {'name': 'You', 'avatar': '⭐', 'xp': xp.totalXP, 'level': xp.currentLevel.name, 'streak': 5},
      {'name': 'Ananya', 'avatar': '🌸', 'xp': 2100, 'level': 'Master', 'streak': 8},
      {'name': 'Vikram', 'avatar': '🚀', 'xp': 1950, 'level': 'Explorer', 'streak': 6},
      {'name': 'Meera', 'avatar': '🎨', 'xp': 1800, 'level': 'Explorer', 'streak': 7},
      {'name': 'Arjun', 'avatar': '⚡', 'xp': 1650, 'level': 'Achiever', 'streak': 4},
      {'name': 'Sara', 'avatar': '🌟', 'xp': 1500, 'level': 'Builder', 'streak': 3},
      {'name': 'Dev', 'avatar': '🎯', 'xp': 1350, 'level': 'Builder', 'streak': 5},
    ];

    // Sort by XP
    players.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Header
          Row(children: [
            Tappable(onTap: () => context.pop(),
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.starActive.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.starActive))),
            const SizedBox(width: 12),
            Text('🏆 Leaderboard', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 20),

          // Top 3 podium
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            // 2nd place
            Expanded(child: _PodiumCard(
              rank: 2, name: players[1]['name'] as String, avatar: players[1]['avatar'] as String,
              xp: players[1]['xp'] as int, height: 100, color: const Color(0xFFC0C0C0))),
            const SizedBox(width: 8),
            // 1st place
            Expanded(child: _PodiumCard(
              rank: 1, name: players[0]['name'] as String, avatar: players[0]['avatar'] as String,
              xp: players[0]['xp'] as int, height: 130, color: const Color(0xFFFFD700))),
            const SizedBox(width: 8),
            // 3rd place
            Expanded(child: _PodiumCard(
              rank: 3, name: players[2]['name'] as String, avatar: players[2]['avatar'] as String,
              xp: players[2]['xp'] as int, height: 80, color: const Color(0xFFCD7F32))),
          ]),
          const SizedBox(height: 24),

          // Stats bar
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(16)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _StatCol('Your Rank', '#${players.indexWhere((p) => p['name'] == 'You') + 1}', Icons.emoji_events_rounded),
              _StatCol('Total XP', '${xp.totalXP}', Icons.star_rounded),
              _StatCol('Level', xp.currentLevel.name, Icons.trending_up_rounded),
            ])),
          const SizedBox(height: 20),

          // Full list
          ...List.generate(players.length, (i) {
            final p = players[i];
            final isYou = p['name'] == 'You';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isYou ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isYou ? Border.all(color: AppColors.primary, width: 2) : null,
                boxShadow: AppShadows.card),
              child: Row(children: [
                Container(width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: i < 3 ? [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)][i].withValues(alpha: 0.2) : AppColors.textLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                  child: Center(child: Text('${i + 1}', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800,
                    color: i < 3 ? [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)][i] : AppColors.textMedium)))),
                const SizedBox(width: 12),
                Text(p['avatar'] as String, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${p['name']}${isYou ? ' (You)' : ''}', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700,
                    color: isYou ? AppColors.primary : AppColors.textDark)),
                  Text('${p['level']}  •  🔥 ${p['streak']} day streak', style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textMedium)),
                ])),
                Text('${p['xp']} XP', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.starActive)),
              ]),
            );
          }),
        ]))),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final int rank; final String name, avatar; final int xp; final double height; final Color color;
  const _PodiumCard({required this.rank, required this.name, required this.avatar, required this.xp, required this.height, required this.color});

  @override Widget build(BuildContext context) {
    return Column(children: [
      Text(avatar, style: const TextStyle(fontSize: 32)),
      const SizedBox(height: 4),
      Text(name, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
      const SizedBox(height: 4),
      Container(height: height, width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.6)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(rank == 1 ? '👑' : rank == 2 ? '🥈' : '🥉', style: const TextStyle(fontSize: 24)),
          Text('$xp XP', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
        ])),
    ]);
  }
}

class _StatCol extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatCol(this.label, this.value, this.icon);

  @override Widget build(BuildContext context) =>
    Column(children: [
      Icon(icon, color: Colors.white70, size: 20),
      const SizedBox(height: 4),
      Text(value, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
      Text(label, style: GoogleFonts.nunito(fontSize: 10, color: Colors.white70)),
    ]);
}
