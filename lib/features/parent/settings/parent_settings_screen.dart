import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../providers/app_providers.dart';
import '../../../shared/widgets/shared_widgets.dart';

class ParentSettingsScreen extends ConsumerStatefulWidget {
  const ParentSettingsScreen({super.key});
  @override
  ConsumerState<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends ConsumerState<ParentSettingsScreen> {
  late TextEditingController _nameCtrl;
  late int _age;
  late String _lang;

  @override
  void initState() {
    super.initState();
    final child = ref.read(activeChildProvider);
    _nameCtrl = TextEditingController(text: child?.name ?? '');
    _age = child?.age ?? 4;
    _lang = child?.languageMode ?? 'en_hi';
  }

  @override
  Widget build(BuildContext context) {
    final child = ref.watch(activeChildProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Nunito')),
        backgroundColor: AppColors.bgLight, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const DuoSectionHeader(title: 'Child Profile 👶'),
          const SizedBox(height: 12),
          DuoCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 12),
            const Text('Age', style: TextStyle(fontWeight: FontWeight.w700)),
            Wrap(spacing: 8, children: List.generate(6, (i) {
              final a = i + 2;
              return ChoiceChip(label: Text('$a'), selected: _age == a, selectedColor: AppColors.primary,
                onSelected: (_) => setState(() => _age = a));
            })),
            const SizedBox(height: 12),
            const Text('Language', style: TextStyle(fontWeight: FontWeight.w700)),
            Wrap(spacing: 8, children: [
              ChoiceChip(label: const Text('EN'), selected: _lang == 'en', onSelected: (_) => setState(() => _lang = 'en'), selectedColor: AppColors.accent2),
              ChoiceChip(label: const Text('HI'), selected: _lang == 'hi', onSelected: (_) => setState(() => _lang = 'hi'), selectedColor: AppColors.accent2),
              ChoiceChip(label: const Text('EN+HI'), selected: _lang == 'en_hi', onSelected: (_) => setState(() => _lang = 'en_hi'), selectedColor: AppColors.accent2),
            ]),
          ])),
          const SizedBox(height: 16),
          DuoButton(text: '💾 Save Changes', color: AppColors.success, onPressed: () async {
            if (child != null) {
              final updated = child.copyWith(name: _nameCtrl.text, age: _age, languageMode: _lang);
              await ref.read(activeChildProvider.notifier).updateChild(updated);
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved! ✅')));
            }
          }),
          const SizedBox(height: 24),
          const DuoSectionHeader(title: 'App Settings ⚙️'),
          const SizedBox(height: 12),
          DuoCard(child: Column(children: [
            SwitchListTile(title: const Text('Dark Mode'), value: false, onChanged: (_) {}),
            SwitchListTile(title: const Text('Sound Effects'), value: true, onChanged: (_) {}),
            SwitchListTile(title: const Text('Auto-play TTS'), value: true, onChanged: (_) {}),
          ])),
          const SizedBox(height: 24),
          DuoButton(text: '🔄 Reset Progress', color: AppColors.error, onPressed: () {
            showDialog(context: context, builder: (ctx) => AlertDialog(
              title: const Text('Reset Progress?'), content: const Text('This will erase all stars and progress.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                TextButton(onPressed: () { Navigator.pop(ctx); }, child: const Text('Reset', style: TextStyle(color: AppColors.error))),
              ],
            ));
          }),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}
