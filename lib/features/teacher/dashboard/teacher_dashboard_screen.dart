import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/shared_widgets.dart';

class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Teacher Dashboard', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Nunito')),
        backgroundColor: AppColors.bgLight, elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Class overview card
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.accent2, AppColors.accent2.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(20)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Welcome, Teacher! 👩‍🏫', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Nunito')),
              SizedBox(height: 4),
              Text('Manage your class and track progress', style: TextStyle(fontSize: 14, color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 24),

          // Quick tools
          const DuoSectionHeader(title: 'Class Tools 🛠️', color: AppColors.accent2),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.2,
            children: [
              _toolCard('👨‍👩‍👦‍👦', 'Students', 'Manage student list', AppColors.primary, () => context.push('/class-tools')),
              _toolCard('📊', 'Reports', 'Class progress reports', AppColors.accent1, () {}),
              _toolCard('📆', 'Lesson Plan', 'Weekly letter plan', AppColors.success, () {}),
              _toolCard('🖨️', 'Print', 'Print worksheets', AppColors.info, () {}),
            ],
          ),
          const SizedBox(height: 24),

          // Today's lesson
          const DuoSectionHeader(title: 'Today\'s Lesson 📖', color: AppColors.accent2),
          const SizedBox(height: 12),
          DuoCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.accent2.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.accent2)))),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Letter A - Apple', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Nunito')),
                Text('4 words • 6 activities each', style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
              ]),
            ]),
            const SizedBox(height: 12),
            DuoButton(text: '▶️ Start Class Session', color: AppColors.accent2, onPressed: () => context.push('/letter/A')),
          ])),
          const SizedBox(height: 24),

          // Letter curriculum overview
          const DuoSectionHeader(title: 'Curriculum 📚', color: AppColors.accent2),
          const SizedBox(height: 12),
          ...AppConstants.activeLetters.map((l) {
            final color = AppColors.letterColors[l] ?? AppColors.primary;
            return Container(
              margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Center(child: Text(l, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)))),
                const SizedBox(width: 12),
                Text('Letter $l', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Text(' • 4 words', style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
                const Spacer(),
                GestureDetector(onTap: () => context.push('/letter/$l'),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('View', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)))),
              ]),
            );
          }),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _toolCard(String emoji, String title, String desc, Color color, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color, fontFamily: 'Nunito')),
        Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.textMedium)),
      ]),
    ));
  }
}
