import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/progress_service.dart';
import '../../../core/services/tutor_brain_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/seed/content_seed.dart';
import '../../../providers/app_providers.dart';
import '../../../shared/widgets/shared_widgets.dart';

class ParentDashboardScreen extends ConsumerStatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  ConsumerState<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends ConsumerState<ParentDashboardScreen> {
  String? _aiReport;
  bool _isGeneratingReport = false;

  Future<void> _generateReport(String childId, String name, int age) async {
    setState(() => _isGeneratingReport = true);
    final report = await ref.read(tutorBrainProvider).generateProgressReport(childId, name, age);
    setState(() {
      _aiReport = report;
      _isGeneratingReport = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = ref.watch(activeChildProvider);
    final progress = ref.read(progressServiceProvider);
    final tutor = ref.read(tutorBrainProvider);
    final totalStars = child != null ? progress.getTotalStars(child.id) : 0;
    final skills = child != null ? progress.getSkillsBreakdown(child.id) : <String, double>{};
    final weakAreas = child != null ? tutor.getWeakAreas(child.id) : <String>[];
    final masteredCount = child != null ? progress.getMasteredLettersCount(child.id) : 0;
    final level = (totalStars / 10).floor() + 1;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text('Parent Dashboard', style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
        backgroundColor: AppColors.bgLight, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/kid-home')),
        actions: [
          IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () => context.push('/parent-settings')),
          IconButton(icon: const Icon(Icons.smart_toy_rounded), onPressed: () => context.push('/ai-settings')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ═══════════════ SUMMARY CARD ═══════════════
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppShadows.medium(AppColors.primary),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(child?.name ?? 'Child', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                  child: Text('Level $level', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ]),
              Text('Age ${child?.age ?? '-'}', style: GoogleFonts.nunito(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 16),
              // Stats row
              Row(children: [
                _StatPill(icon: Icons.star_rounded, value: '$totalStars', label: 'Stars', color: AppColors.accent1),
                const SizedBox(width: 10),
                _StatPill(icon: Icons.abc_rounded, value: '$masteredCount/26', label: 'Letters', color: AppColors.accent3),
                const SizedBox(width: 10),
                _StatPill(icon: Icons.local_fire_department_rounded, value: '1', label: 'Streak', color: AppColors.secondary),
              ]),
              const SizedBox(height: 16),
              DuoProgressBar(progress: totalStars / 60, color: Colors.white, height: 10),
              const SizedBox(height: 4),
              Text('$totalStars / 60 stars to next level', style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 24),

          // ═══════════════ SKILLS OVERVIEW ═══════════════
          Text('Skills Overview 📊', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          // Skill radar chart (simplified as bars with icons)
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.card,
            ),
            child: Column(children: [
              if (skills.isNotEmpty) ...skills.entries.map((e) {
                final icons = {'listen': '👂', 'think': '🧠', 'speak': '🗣️', 'write': '✍️', 'draw': '🎨'};
                final colors = {'listen': AppColors.meetTab, 'think': AppColors.thinkTab, 'speak': AppColors.talkTab, 'write': AppColors.writeTab, 'draw': AppColors.drawTab};
                final skillColor = colors[e.key] ?? AppColors.primary;
                return Padding(padding: const EdgeInsets.only(bottom: 14),
                  child: Row(children: [
                    Text(icons[e.key] ?? '📝', style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    SizedBox(width: 55, child: Text(e.key.toUpperCase(), style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMedium))),
                    Expanded(child: DuoProgressBar(progress: e.value, color: skillColor, height: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: skillColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text('${(e.value * 100).toInt()}%', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: skillColor)),
                    ),
                  ]));
              }),
              if (skills.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    const Text('🚀', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text('No activity yet. Let your child start learning!', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium), textAlign: TextAlign.center),
                  ]),
                ),
            ]),
          ),
          const SizedBox(height: 24),

          // ═══════════════ WEEKLY ACTIVITY ═══════════════
          Text('Weekly Activity 📅', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, height: 200, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.card,
            ),
            child: CustomPaint(painter: _WeeklyChartPainter()),
          ),
          const SizedBox(height: 24),

          // ═══════════════ WEAK AREAS ═══════════════
          if (weakAreas.isNotEmpty) ...[
            Text('Focus Areas 🎯', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.warning.withValues(alpha: 0.08), AppColors.warning.withValues(alpha: 0.02)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('💡 Recommended focus areas for ${child?.name ?? "your child"}:', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: weakAreas.map((a) =>
                  Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                      boxShadow: AppShadows.soft(AppColors.warning),
                    ),
                    child: Text(a, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.warning)))
                ).toList()),
              ]),
            ),
            const SizedBox(height: 24),
          ],

          // ═══════════════ AI PROGRESS REPORT ═══════════════
          Row(
            children: [
              Text('Smart Insights 🧠', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
              const Spacer(),
              if (_aiReport == null)
                TextButton.icon(
                  onPressed: _isGeneratingReport || child == null ? null : () => _generateReport(child.id, child.name, child.age),
                  icon: _isGeneratingReport ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome),
                  label: Text(_isGeneratingReport ? 'Analyzing...' : 'Generate AI Report'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_aiReport != null)
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), Colors.white]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Tutor Brain Report', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 8),
                Text(_aiReport!, style: GoogleFonts.nunito(fontSize: 14, height: 1.5, color: AppColors.textMedium)),
              ]),
            ),
          if (_aiReport != null) const SizedBox(height: 24),

          // ═══════════════ LETTER PROGRESS ═══════════════
          Text('Letter Progress 🔤', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemCount: AppConstants.activeLetters.length,
            itemBuilder: (ctx, i) {
              final letter = AppConstants.activeLetters[i];
              final stars = child != null ? progress.getLetterStars(child.id, letter) : 0;
              final mastered = child != null ? progress.isLetterMastered(child.id, letter) : false;
              final color = AppColors.letterColors[letter] ?? AppColors.primary;
              final statusColor = mastered ? AppColors.success : stars > 0 ? AppColors.accent1 : Colors.grey.shade300;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: statusColor, width: mastered ? 2.5 : 1.5),
                  boxShadow: mastered ? AppShadows.soft(AppColors.success) : [],
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (mastered) const Text('✅', style: TextStyle(fontSize: 10)),
                  Text(letter, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
                  Text('⭐$stars', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: stars > 0 ? AppColors.accent1 : AppColors.textLight)),
                ]),
              );
            },
          ),
          const SizedBox(height: 24),

          // ═══════════════ RECENT ACTIVITY ═══════════════
          Text('Recent Activity 📝', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
            child: Column(children: [
              _ActivityItem(emoji: '🍎', word: 'Apple', tab: 'Meet', time: 'Today, 10:30 AM', stars: 1),
              _ActivityItem(emoji: '🐜', word: 'Ant', tab: 'Think', time: 'Today, 10:15 AM', stars: 2),
              _ActivityItem(emoji: '🛩️', word: 'Airplane', tab: 'Write', time: 'Yesterday', stars: 1),
              _ActivityItem(emoji: '🐊', word: 'Alligator', tab: 'Draw', time: 'Yesterday', stars: 1),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Activity data updates as your child learns', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textLight)),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // ═══════════════ QUICK ACTIONS ═══════════════
          Text('Quick Actions', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: DuoButton(text: '🖨️ Print Center', color: AppColors.info, onPressed: () => context.push('/print-center'))),
            const SizedBox(width: 12),
            Expanded(child: DuoButton(text: '⚙️ Settings', color: Colors.grey, onPressed: () => context.push('/parent-settings'))),
          ]),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

// ─── Helper Widgets ───

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatPill({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
        Text(label, style: GoogleFonts.nunito(fontSize: 10, color: Colors.white70)),
      ]),
    ));
  }
}

class _ActivityItem extends StatelessWidget {
  final String emoji, word, tab, time;
  final int stars;
  const _ActivityItem({required this.emoji, required this.word, required this.tab, required this.time, required this.stars});

  @override
  Widget build(BuildContext context) {
    final tabColors = {'Meet': AppColors.meetTab, 'Think': AppColors.thinkTab, 'Talk': AppColors.talkTab,
      'Write': AppColors.writeTab, 'Draw': AppColors.drawTab, 'Story': AppColors.storyTab};
    final color = tabColors[tab] ?? AppColors.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$word – $tab', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
          Text(time, style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textLight)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Icon(Icons.star_rounded, size: 14, color: AppColors.starActive),
            const SizedBox(width: 2),
            Text('$stars', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
          ]),
        ),
      ]),
    );
  }
}

// ─── Weekly Activity Chart ───
class _WeeklyChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [15, 25, 10, 30, 20, 35, 5]; // Simulated minutes
    final maxVal = 40.0;
    final barWidth = size.width / (days.length * 2 + 1);
    final maxBarHeight = size.height - 30;

    for (int i = 0; i < days.length; i++) {
      final x = barWidth + i * barWidth * 2;
      final barHeight = (values[i] / maxVal) * maxBarHeight;
      final y = size.height - 20 - barHeight;

      // Bar gradient
      final isToday = i == DateTime.now().weekday - 1;
      final color = isToday ? AppColors.primary : AppColors.primaryLight;
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [color, color.withValues(alpha: 0.6)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight));

      // Rounded bar
      canvas.drawRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(6), topRight: const Radius.circular(6),
      ), paint);

      // Day label
      final textPainter = TextPainter(
        text: TextSpan(text: days[i], style: TextStyle(fontSize: 10, color: isToday ? AppColors.primary : AppColors.textLight, fontWeight: isToday ? FontWeight.w700 : FontWeight.w400)),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x + barWidth / 2 - textPainter.width / 2, size.height - 16));

      // Value on top
      final valuePainter = TextPainter(
        text: TextSpan(text: '${values[i]}m', style: TextStyle(fontSize: 9, color: AppColors.textMedium, fontWeight: FontWeight.w600)),
        textDirection: TextDirection.ltr,
      )..layout();
      valuePainter.paint(canvas, Offset(x + barWidth / 2 - valuePainter.width / 2, y - 14));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
