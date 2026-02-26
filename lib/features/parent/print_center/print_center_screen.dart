import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';

class PrintCenterScreen extends ConsumerWidget {
  const PrintCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: const Text('Print Center 🖨️', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Nunito')),
        backgroundColor: AppColors.bgLight, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
          children: [
            _printCard('📝 Tracing Sheets', 'Print letter and word tracing worksheets', AppColors.writeTab, () {}),
            _printCard('🎨 Coloring Pages', 'Print coloring pages for each word', AppColors.drawTab, () {}),
            _printCard('🔤 Flashcards', 'Print word-emoji flashcards', AppColors.thinkTab, () {}),
            _printCard('📊 Progress Report', 'Print child\'s learning report', AppColors.primary, () {}),
          ],
        ),
      ),
    );
  }

  Widget _printCard(String title, String desc, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color, fontFamily: 'Nunito')),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
        ]),
      ),
    );
  }
}
