import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/xp_service.dart';
import '../../../shared/widgets/shared_widgets.dart';

/// Physical Activity Prompts — exercise breaks with timers
class PhysicalActivityScreen extends ConsumerStatefulWidget {
  const PhysicalActivityScreen({super.key});
  @override ConsumerState<PhysicalActivityScreen> createState() => _PhysicalActivityScreenState();
}

class _PhysicalActivityScreenState extends ConsumerState<PhysicalActivityScreen> with TickerProviderStateMixin {
  int _actIdx = -1;
  int _secondsLeft = 0;
  bool _running = false;
  late AnimationController _timerController;

  static const _activities = [
    {'emoji': '🏃', 'title': 'Jumping Jacks', 'desc': 'Do 10 jumping jacks!', 'secs': 30, 'xp': 10, 'color': 0xFFFF6B6B},
    {'emoji': '🧘', 'title': 'Yoga Tree Pose', 'desc': 'Stand on one leg like a tree!', 'secs': 20, 'xp': 8, 'color': 0xFF00B894},
    {'emoji': '💪', 'title': 'Arm Circles', 'desc': 'Stretch your arms and make circles!', 'secs': 20, 'xp': 8, 'color': 0xFF0984E3},
    {'emoji': '🦘', 'title': 'Hop Like a Bunny', 'desc': 'Hop around the room 10 times!', 'secs': 30, 'xp': 10, 'color': 0xFFFF9F43},
    {'emoji': '🐻', 'title': 'Bear Walk', 'desc': 'Walk on hands and feet!', 'secs': 20, 'xp': 10, 'color': 0xFF6C5CE7},
    {'emoji': '🙆', 'title': 'Touch Your Toes', 'desc': 'Bend down and touch your toes 5 times!', 'secs': 15, 'xp': 5, 'color': 0xFFE17055},
    {'emoji': '🏊', 'title': 'Swimming Arms', 'desc': 'Pretend to swim standing up!', 'secs': 20, 'xp': 8, 'color': 0xFF00CEC9},
    {'emoji': '🦅', 'title': 'Eagle Arms', 'desc': 'Spread your arms like an eagle and flap!', 'secs': 20, 'xp': 8, 'color': 0xFFFF6B9D},
    {'emoji': '🧍', 'title': 'Statue Freeze', 'desc': 'Dance then freeze like a statue!', 'secs': 30, 'xp': 10, 'color': 0xFF636E72},
    {'emoji': '🐛', 'title': 'Caterpillar Walk', 'desc': 'Walk your hands forward then feet!', 'secs': 25, 'xp': 10, 'color': 0xFF1DD1A1},
    {'emoji': '🌟', 'title': 'Star Jumps', 'desc': 'Jump up making a star shape!', 'secs': 20, 'xp': 8, 'color': 0xFFFDB813},
    {'emoji': '🐸', 'title': 'Frog Jumps', 'desc': 'Squat down and jump like a frog!', 'secs': 25, 'xp': 10, 'color': 0xFF00B894},
  ];

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override void dispose() { _timerController.dispose(); super.dispose(); }

  void _startActivity(int idx) {
    final secs = _activities[idx]['secs'] as int;
    setState(() { _actIdx = idx; _secondsLeft = secs; _running = true; });
    _tick();
  }

  void _tick() {
    if (!_running || _secondsLeft <= 0) {
      if (_secondsLeft <= 0 && _actIdx >= 0) {
        HapticFeedback.heavyImpact();
        ref.read(xpServiceProvider).addXP(_activities[_actIdx]['xp'] as int);
        setState(() => _running = false);
      }
      return;
    }
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _running) { setState(() => _secondsLeft--); _tick(); }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_actIdx >= 0) return _buildActive();

    return Scaffold(backgroundColor: AppColors.bgLight,
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            GestureDetector(onTap: () => context.pop(),
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.error))),
            const SizedBox(width: 12),
            Text('🏃 Activity Break', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 20),

          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.error, AppColors.error.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('💪🎉', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text('Move Your Body!', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              Text('Quick exercise breaks to stay active', style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70)),
            ])),
          const SizedBox(height: 24),

          ...List.generate(_activities.length, (i) {
            final a = _activities[i]; final c = Color(a['color'] as int);
            return Padding(padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(onTap: () => _startActivity(i),
                child: Container(padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
                  child: Row(children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text(a['emoji'] as String, style: const TextStyle(fontSize: 22)))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(a['title'] as String, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('${a['secs']}s  •  +${a['xp']} XP', style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textMedium)),
                    ])),
                    Icon(Icons.play_circle_outline_rounded, size: 32, color: c),
                  ]))));
          }),
        ]))));
  }

  Widget _buildActive() {
    final a = _activities[_actIdx];
    final c = Color(a['color'] as int);
    final totalSecs = a['secs'] as int;
    final progress = _secondsLeft / totalSecs;
    final done = !_running && _secondsLeft <= 0;

    return Scaffold(backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(a['emoji'] as String, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text(a['title'] as String, style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(a['desc'] as String, style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium)),
          const SizedBox(height: 32),

          if (!done) ...[
            SizedBox(width: 150, height: 150,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(width: 150, height: 150,
                  child: CircularProgressIndicator(value: progress, strokeWidth: 10,
                    backgroundColor: c.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(c))),
                Text('$_secondsLeft', style: GoogleFonts.nunito(fontSize: 48, fontWeight: FontWeight.w900, color: c)),
              ])),
            const SizedBox(height: 24),
            Text(_running ? 'Keep going! 💪' : 'Get ready...', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textMedium)),
          ] else ...[
            const Text('🏆', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text('Great job!', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.success)),
            Text('+${a['xp']} XP earned!', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: c)),
          ],
          const SizedBox(height: 32),

          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => setState(() { _actIdx = -1; _running = false; }),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: BorderSide(color: c)),
              child: Text('Back', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: c)))),
            const SizedBox(width: 12),
            if (done) Expanded(child: PrimaryButton(label: 'Next Activity', onPressed: () {
              final next = (_actIdx + 1) % _activities.length;
              _startActivity(next);
            }, color: c)),
          ]),
        ])))),
    );
  }
}
