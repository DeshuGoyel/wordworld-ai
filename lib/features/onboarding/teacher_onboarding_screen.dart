import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/shared_widgets.dart';

class TeacherOnboardingScreen extends ConsumerStatefulWidget {
  const TeacherOnboardingScreen({super.key});
  @override
  ConsumerState<TeacherOnboardingScreen> createState() => _TeacherOnboardingScreenState();
}

class _TeacherOnboardingScreenState extends ConsumerState<TeacherOnboardingScreen> {
  final _nameCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _classCtrl = TextEditingController();
  String _selectedClass = 'Nursery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
              const Expanded(child: DuoProgressBar(progress: 1, color: AppColors.accent2)),
            ]),
            const SizedBox(height: 24),
            const Text('👩‍🏫', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text('Teacher Setup', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, fontFamily: 'Nunito')),
            const SizedBox(height: 24),
            _field(_nameCtrl, 'Your Name / आपका नाम'),
            const SizedBox(height: 16),
            _field(_schoolCtrl, 'School Name (optional)'),
            const SizedBox(height: 16),
            const Align(alignment: Alignment.centerLeft, child: Text('Class / कक्षा', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: ['Nursery', 'LKG', 'UKG', 'Grade 1'].map((c) =>
              ChoiceChip(
                label: Text(c, style: TextStyle(fontWeight: FontWeight.w700, color: _selectedClass == c ? Colors.white : AppColors.textDark)),
                selected: _selectedClass == c, selectedColor: AppColors.accent2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (_) => setState(() => _selectedClass = c),
              )).toList()),
            const SizedBox(height: 16),
            _field(_classCtrl, 'Class Name (e.g., Section A)'),
            const SizedBox(height: 32),
            DuoButton(text: 'Start Teaching! 📚', color: AppColors.accent2, onPressed: () async {
              if (_nameCtrl.text.isEmpty) return;
              final s = ref.read(storageServiceProvider);
              final userId = const Uuid().v4();
              final user = AppUser(id: userId, name: _nameCtrl.text, type: 'teacher', pin: '0000', schoolName: _schoolCtrl.text, className: '$_selectedClass - ${_classCtrl.text}');
              await s.saveUser(user);
              await s.saveCurrentUserId(userId);
              await s.setUserType('teacher');
              await s.setOnboarded(true);
              if (mounted) context.go('/teacher-dashboard');
            }),
          ]),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label) {
    return TextField(controller: ctrl, style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent2, width: 2))));
  }
}
