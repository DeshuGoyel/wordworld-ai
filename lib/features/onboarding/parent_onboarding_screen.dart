import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/models.dart';
import '../../providers/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class ParentOnboardingScreen extends ConsumerStatefulWidget {
  const ParentOnboardingScreen({super.key});
  @override
  ConsumerState<ParentOnboardingScreen> createState() => _ParentOnboardingScreenState();
}

class _ParentOnboardingScreenState extends ConsumerState<ParentOnboardingScreen> {
  int _step = 0; // 0=PIN, 1=child info, 2=avatar
  final _pinControllers = List.generate(4, (_) => TextEditingController());
  final _nameController = TextEditingController();
  int _selectedAge = 4;
  String _selectedLang = 'en_hi';
  String _selectedAvatar = 'avatar_1';

  final _avatars = ['🦊','🐼','🦁','🐰','🐸','🦄','🐶','🐱','🐻','🦋'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress
              Row(children: [
                IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () {
                  if (_step > 0) setState(() => _step--); else context.pop();
                }),
                Expanded(child: DuoProgressBar(progress: (_step + 1) / 3, color: AppColors.primary)),
                const SizedBox(width: 16),
                Text('${_step + 1}/3', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textMedium)),
              ]),
              const SizedBox(height: 32),
              Expanded(child: _buildStep()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0: return _buildPinStep();
      case 1: return _buildChildInfoStep();
      case 2: return _buildAvatarStep();
      default: return const SizedBox();
    }
  }

  Widget _buildPinStep() {
    return Column(children: [
      const Text('🔒', style: TextStyle(fontSize: 60)),
      const SizedBox(height: 16),
      const Text('Create a Parent PIN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, fontFamily: 'Nunito')),
      const SizedBox(height: 8),
      const Text('This keeps parent settings safe', style: TextStyle(fontSize: 14, color: AppColors.textMedium, fontFamily: 'Nunito')),
      const SizedBox(height: 32),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (i) =>
        Container(
          width: 56, height: 64, margin: const EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
            controller: _pinControllers[i],
            textAlign: TextAlign.center, keyboardType: TextInputType.number,
            maxLength: 1, obscureText: true,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            decoration: InputDecoration(
              counterText: '', filled: true, fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
            ),
            onChanged: (v) { if (v.isNotEmpty && i < 3) FocusScope.of(context).nextFocus(); },
          ),
        ),
      )),
      const Spacer(),
      DuoButton(text: 'Continue', onPressed: () {
        final pin = _pinControllers.map((c) => c.text).join();
        if (pin.length == 4) { ref.read(storageServiceProvider).savePin(pin); setState(() => _step = 1); }
      }),
    ]);
  }

  Widget _buildChildInfoStep() {
    return SingleChildScrollView(child: Column(children: [
      const Text('👶', style: TextStyle(fontSize: 60)),
      const SizedBox(height: 16),
      const Text('Add Your Child', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, fontFamily: 'Nunito')),
      const SizedBox(height: 24),
      TextField(
        controller: _nameController,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          labelText: 'Child\'s Name / बच्चे का नाम',
          filled: true, fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        ),
      ),
      const SizedBox(height: 20),
      const Align(alignment: Alignment.centerLeft, child: Text('Age / उम्र', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Nunito'))),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: List.generate(6, (i) {
        final age = i + 2;
        final selected = _selectedAge == age;
        return ChoiceChip(
          label: Text('$age', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.textDark)),
          selected: selected, selectedColor: AppColors.primary,
          backgroundColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (_) => setState(() => _selectedAge = age),
        );
      })),
      const SizedBox(height: 20),
      const Align(alignment: Alignment.centerLeft, child: Text('Language / भाषा', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Nunito'))),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: [
        _langChip('EN', 'en'), _langChip('HI', 'hi'), _langChip('EN+HI', 'en_hi'),
      ]),
      const SizedBox(height: 32),
      DuoButton(text: 'Next', onPressed: () {
        if (_nameController.text.isNotEmpty) setState(() => _step = 2);
      }),
    ]));
  }

  Widget _langChip(String label, String value) {
    final selected = _selectedLang == value;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.textDark)),
      selected: selected, selectedColor: AppColors.accent2,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (_) => setState(() => _selectedLang = value),
    );
  }

  Widget _buildAvatarStep() {
    return Column(children: [
      const Text('Choose Avatar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, fontFamily: 'Nunito')),
      const SizedBox(height: 8),
      const Text('अवतार चुनें', style: TextStyle(fontSize: 16, color: AppColors.textMedium, fontFamily: 'Nunito')),
      const SizedBox(height: 24),
      // Selected avatar big
      Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: Center(child: Text(_avatars[_avatars.indexOf(_selectedAvatar.replaceAll('avatar_', '').isEmpty ? '🦊' : _avatars[int.tryParse(_selectedAvatar.replaceAll('avatar_', '')) != null ? (int.parse(_selectedAvatar.replaceAll('avatar_', '')) - 1).clamp(0, 9) : 0])], style: const TextStyle(fontSize: 50))),
      ),
      const SizedBox(height: 24),
      Wrap(spacing: 12, runSpacing: 12, children: List.generate(_avatars.length, (i) {
        final isSelected = _selectedAvatar == 'avatar_${i + 1}';
        return GestureDetector(
          onTap: () => setState(() => _selectedAvatar = 'avatar_${i + 1}'),
          child: Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 3),
            ),
            child: Center(child: Text(_avatars[i], style: const TextStyle(fontSize: 32))),
          ),
        );
      })),
      const Spacer(),
      DuoButton(text: 'Let\'s Go! 🚀', color: AppColors.success, onPressed: () async {
        final storage = ref.read(storageServiceProvider);
        final childId = const Uuid().v4();
        final userId = const Uuid().v4();

        final child = ChildProfile(id: childId, name: _nameController.text, age: _selectedAge, avatarId: _selectedAvatar, languageMode: _selectedLang);
        final user = AppUser(id: userId, name: 'Parent', type: 'parent', pin: _pinControllers.map((c) => c.text).join(), childIds: [childId]);

        await storage.saveChild(child);
        await storage.saveUser(user);
        await storage.saveCurrentUserId(userId);
        await storage.setActiveChildId(childId);
        await storage.setUserType('parent');
        await storage.setOnboarded(true);

        ref.read(activeChildProvider.notifier).refresh();
        if (mounted) context.go('/kid-home');
      }),
    ]);
  }
}
