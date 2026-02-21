import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';

class ClassToolsScreen extends ConsumerWidget {
  const ClassToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: const Text('Class Tools', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Nunito')),
        backgroundColor: AppColors.bgLight, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const DuoSectionHeader(title: 'Students 👨‍👩‍👦‍👦', color: AppColors.accent2),
          const SizedBox(height: 12),
          DuoCard(child: Column(children: [
            const Text('No students added yet', style: TextStyle(fontSize: 16, color: AppColors.textMedium)),
            const SizedBox(height: 12),
            DuoButton(text: '➕ Add Student', color: AppColors.accent2, onPressed: () {
              // Show add student dialog
              showDialog(context: context, builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: const Text('Add Student', style: TextStyle(fontWeight: FontWeight.w800)),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(decoration: InputDecoration(labelText: 'Student Name', filled: true, fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                  const SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: 'Age', filled: true, fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    keyboardType: TextInputType.number),
                ]),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Add')),
                ],
              ));
            }),
          ])),
          const SizedBox(height: 24),
          const DuoSectionHeader(title: 'Classroom Activities 🎮', color: AppColors.accent2),
          const SizedBox(height: 12),
          DuoCard(child: Column(children: [
            _activityTile('🔤', 'Letter of the Day', 'Project a letter on screen for class learning'),
            const Divider(),
            _activityTile('🎯', 'Word Quiz', 'Interactive quiz for the whole class'),
            const Divider(),
            _activityTile('🎶', 'Phonics Song', 'Play letter phonics with actions'),
          ])),
        ]),
      ),
    );
  }

  Widget _activityTile(String emoji, String title, String desc) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 28)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Nunito')),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.accent2),
    );
  }
}
