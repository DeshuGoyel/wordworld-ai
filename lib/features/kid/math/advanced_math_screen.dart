import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/xp_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../../shared/widgets/quiz_result_screen.dart';

/// Advanced Math — Money, Time, Measurement modules
class AdvancedMathScreen extends ConsumerStatefulWidget {
  const AdvancedMathScreen({super.key});
  @override ConsumerState<AdvancedMathScreen> createState() => _AdvancedMathScreenState();
}

class _AdvancedMathScreenState extends ConsumerState<AdvancedMathScreen> {
  int _selectedModule = -1;

  static const _modules = [
    {'emoji': '💰', 'title': 'Money', 'desc': 'Coins, notes & counting money', 'color': 0xFF00B894},
    {'emoji': '🕐', 'title': 'Time', 'desc': 'Reading clocks & telling time', 'color': 0xFF0984E3},
    {'emoji': '📏', 'title': 'Measurement', 'desc': 'Length, weight & capacity', 'color': 0xFFFF9F43},
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedModule == 0) return _MoneyModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
    if (_selectedModule == 1) return _TimeModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));
    if (_selectedModule == 2) return _MeasurementModule(onBack: () => setState(() => _selectedModule = -1), xpService: ref.read(xpServiceProvider));

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            GestureDetector(onTap: () => context.pop(),
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.mathWorld.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.mathWorld))),
            const SizedBox(width: 12),
            Text('🔢 Advanced Math', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppGradients.math, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🧮', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text('Master Real-World Math!', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              Text('Money, time, and measurements', style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70)),
            ])),
          const SizedBox(height: 24),
          ...List.generate(_modules.length, (i) {
            final m = _modules[i]; final color = Color(m['color'] as int);
            return Padding(padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(onTap: () => setState(() => _selectedModule = i),
                child: Container(padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
                  child: Row(children: [
                    Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text(m['emoji'] as String, style: const TextStyle(fontSize: 24)))),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m['title'] as String, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(m['desc'] as String, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
                    ])),
                    Icon(Icons.play_circle_filled_rounded, size: 36, color: color),
                  ]))));
          }),
        ]))),
    );
  }
}

// ═══ MONEY MODULE ═══
class _MoneyModule extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _MoneyModule({required this.onBack, required this.xpService});
  @override State<_MoneyModule> createState() => _MoneyModuleState();
}
class _MoneyModuleState extends State<_MoneyModule> {
  int _q = 0; int _score = 0; String? _sel; bool _ans = false;
  static const _qs = [
    {'q': '💰 How many paise in ₹1?', 'opts': ['100', '50', '10'], 'a': '100'},
    {'q': '💵 ₹10 + ₹5 = ?', 'opts': ['₹15', '₹10', '₹20'], 'a': '₹15'},
    {'q': '🪙 3 coins of ₹2 each = ?', 'opts': ['₹6', '₹5', '₹8'], 'a': '₹6'},
    {'q': '🛒 Pencil costs ₹5, eraser ₹3. Total?', 'opts': ['₹8', '₹7', '₹10'], 'a': '₹8'},
    {'q': '💵 You pay ₹20 for ₹15 item. Change?', 'opts': ['₹5', '₹3', '₹10'], 'a': '₹5'},
    {'q': '🪙 Which coin is smallest?', 'opts': ['₹1', '₹2', '₹5'], 'a': '₹1'},
    {'q': '💵 Largest Indian note currently?', 'opts': ['₹500', '₹1000', '₹2000'], 'a': '₹500'},
    {'q': '🛍️ 4 chocolates at ₹10 each = ?', 'opts': ['₹40', '₹30', '₹50'], 'a': '₹40'},
    {'q': '💰 ₹100 - ₹35 = ?', 'opts': ['₹65', '₹55', '₹75'], 'a': '₹65'},
    {'q': '🏦 Where do we save money?', 'opts': ['Bank', 'Shop', 'School'], 'a': 'Bank'},
    {'q': '🪙 5 coins of ₹5 = ?', 'opts': ['₹25', '₹20', '₹30'], 'a': '₹25'},
    {'q': '💵 ₹200 + ₹300 = ?', 'opts': ['₹500', '₹400', '₹600'], 'a': '₹500'},
    {'q': '🛒 Toy costs ₹150. You have ₹100. Need ₹___?', 'opts': ['50', '60', '40'], 'a': '50'},
    {'q': '💰 ₹1000 ÷ 5 = ?', 'opts': ['₹200', '₹150', '₹250'], 'a': '₹200'},
    {'q': '🪙 Which is worth more: 5×₹10 or 2×₹20?', 'opts': ['5×₹10 (₹50)', '2×₹20 (₹40)', 'Same'], 'a': '5×₹10 (₹50)'},
  ];

  @override
  Widget build(BuildContext context) => _buildQuiz('💰 Money', const Color(0xFF00B894));

  Widget _buildQuiz(String title, Color color) {
    if (_q >= _qs.length) return QuizResultScreen(
      score: _score, total: _qs.length, title: title, color: color,
      onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _sel = null; _ans = false; }));
    final q = _qs[_q]; final isCorrect = _sel == q['a'];
    return Scaffold(backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            GestureDetector(onTap: widget.onBack, child: Container(width: 40, height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.arrow_back_rounded, color: color))),
            const SizedBox(width: 12),
            Expanded(child: Text('$title ${_q + 1}/${_qs.length}', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800))),
            Text('⭐ $_score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (_q + 1) / _qs.length, minHeight: 8,
            backgroundColor: color.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(color))),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
            child: Text(q['q'] as String, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center)),
          const SizedBox(height: 16),
          ...(q['opts'] as List<String>).map((o) {
            final isSel = _sel == o; final isA = o == q['a'];
            Color bg = Colors.white, border = AppColors.textLight.withOpacity(0.2);
            if (_ans) { if (isA) { bg = AppColors.success.withOpacity(0.1); border = AppColors.success; }
              else if (isSel) { bg = AppColors.error.withOpacity(0.1); border = AppColors.error; } }
            return Padding(padding: const EdgeInsets.only(bottom: 10), child: GestureDetector(
              onTap: () { if (_ans) return; HapticFeedback.lightImpact();
                setState(() { _sel = o; _ans = true; if (o == q['a']) { _score++; widget.xpService.addXP(5); } }); },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 2)),
                child: Row(children: [Expanded(child: Text(o, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700))),
                  if (_ans && isA) const Icon(Icons.check_circle, color: AppColors.success),
                  if (_ans && isSel && !isA) const Icon(Icons.cancel, color: AppColors.error)]))));
          }),
          const Spacer(),
          if (_ans) PrimaryButton(label: _q < _qs.length - 1 ? 'Next →' : 'Results', onPressed: () =>
            setState(() { _q++; _sel = null; _ans = false; }), color: isCorrect ? AppColors.success : color),
        ]))));
  }
}

// ═══ TIME MODULE ═══
class _TimeModule extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _TimeModule({required this.onBack, required this.xpService});
  @override State<_TimeModule> createState() => _TimeModuleState();
}
class _TimeModuleState extends State<_TimeModule> {
  int _q = 0; int _score = 0; String? _sel; bool _ans = false;
  static const _qs = [
    {'q': '🕐 How many hours in a day?', 'opts': ['24', '12', '48'], 'a': '24'},
    {'q': '🕐 How many minutes in an hour?', 'opts': ['60', '30', '100'], 'a': '60'},
    {'q': '🕐 Short hand shows ___', 'opts': ['Hours', 'Minutes', 'Seconds'], 'a': 'Hours'},
    {'q': '🕐 Long hand shows ___', 'opts': ['Minutes', 'Hours', 'Days'], 'a': 'Minutes'},
    {'q': '🕛 12:00 means ___', 'opts': ['Noon/Midnight', 'Morning', 'Evening'], 'a': 'Noon/Midnight'},
    {'q': '🕒 3:00 — hour hand points to?', 'opts': ['3', '12', '6'], 'a': '3'},
    {'q': '⏰ 1 hour = ___ seconds', 'opts': ['3600', '360', '60'], 'a': '3600'},
    {'q': '📅 How many days in a week?', 'opts': ['7', '5', '10'], 'a': '7'},
    {'q': '📅 How many months in a year?', 'opts': ['12', '10', '52'], 'a': '12'},
    {'q': '🕕 Half past 6 = ?', 'opts': ['6:30', '6:00', '6:15'], 'a': '6:30'},
    {'q': '🕘 Quarter past 9 = ?', 'opts': ['9:15', '9:30', '9:45'], 'a': '9:15'},
    {'q': '📅 How many days in February (normal)?', 'opts': ['28', '29', '30'], 'a': '28'},
    {'q': '⌚ AM stands for?', 'opts': ['Before noon', 'After noon', 'At midnight'], 'a': 'Before noon'},
    {'q': '⌚ PM stands for?', 'opts': ['After noon', 'Before noon', 'Past midnight'], 'a': 'After noon'},
    {'q': '📅 Leap year has ___ days', 'opts': ['366', '365', '364'], 'a': '366'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _qs.length) return QuizResultScreen(
      score: _score, total: _qs.length, title: '🕐 Time', color: const Color(0xFF0984E3),
      onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _sel = null; _ans = false; }));
    final q = _qs[_q]; final isCorrect = _sel == q['a'];
    return Scaffold(backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            GestureDetector(onTap: widget.onBack, child: Container(width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFF0984E3).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0984E3)))),
            const SizedBox(width: 12),
            Expanded(child: Text('🕐 Time ${_q + 1}/${_qs.length}', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800))),
            Text('⭐ $_score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (_q + 1) / _qs.length, minHeight: 8,
            backgroundColor: const Color(0xFF0984E3).withOpacity(0.1), valueColor: const AlwaysStoppedAnimation(Color(0xFF0984E3)))),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
            child: Text(q['q'] as String, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center)),
          const SizedBox(height: 16),
          ...(q['opts'] as List<String>).map((o) {
            final isSel = _sel == o; final isA = o == q['a'];
            Color bg = Colors.white, border = AppColors.textLight.withOpacity(0.2);
            if (_ans) { if (isA) { bg = AppColors.success.withOpacity(0.1); border = AppColors.success; }
              else if (isSel) { bg = AppColors.error.withOpacity(0.1); border = AppColors.error; } }
            return Padding(padding: const EdgeInsets.only(bottom: 10), child: GestureDetector(
              onTap: () { if (_ans) return; HapticFeedback.lightImpact();
                setState(() { _sel = o; _ans = true; if (o == q['a']) { _score++; widget.xpService.addXP(5); } }); },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 2)),
                child: Row(children: [Expanded(child: Text(o, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700))),
                  if (_ans && isA) const Icon(Icons.check_circle, color: AppColors.success),
                  if (_ans && isSel && !isA) const Icon(Icons.cancel, color: AppColors.error)]))));
          }),
          const Spacer(),
          if (_ans) PrimaryButton(label: _q < _qs.length - 1 ? 'Next →' : 'Results', onPressed: () =>
            setState(() { _q++; _sel = null; _ans = false; }), color: isCorrect ? AppColors.success : const Color(0xFF0984E3)),
        ]))));
  }
}

// ═══ MEASUREMENT MODULE ═══
class _MeasurementModule extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _MeasurementModule({required this.onBack, required this.xpService});
  @override State<_MeasurementModule> createState() => _MeasurementModuleState();
}
class _MeasurementModuleState extends State<_MeasurementModule> {
  int _q = 0; int _score = 0; String? _sel; bool _ans = false;
  static const _qs = [
    {'q': '📏 We measure length in ___', 'opts': ['cm/m', 'kg', 'liters'], 'a': 'cm/m'},
    {'q': '⚖️ We measure weight in ___', 'opts': ['kg/g', 'cm', 'liters'], 'a': 'kg/g'},
    {'q': '🫗 We measure liquid in ___', 'opts': ['liters/ml', 'kg', 'cm'], 'a': 'liters/ml'},
    {'q': '📏 1 meter = ___ cm', 'opts': ['100', '10', '1000'], 'a': '100'},
    {'q': '⚖️ 1 kg = ___ grams', 'opts': ['1000', '100', '500'], 'a': '1000'},
    {'q': '🫗 1 liter = ___ ml', 'opts': ['1000', '100', '500'], 'a': '1000'},
    {'q': '📏 Which is longer: 1m or 50cm?', 'opts': ['1m', '50cm', 'Same'], 'a': '1m'},
    {'q': '⚖️ Which is heavier: 1kg or 500g?', 'opts': ['1kg', '500g', 'Same'], 'a': '1kg'},
    {'q': '🌡️ Temperature is measured in ___', 'opts': ['°C or °F', 'kg', 'liters'], 'a': '°C or °F'},
    {'q': '📏 A ruler typically measures in ___', 'opts': ['cm & inches', 'kg', 'liters'], 'a': 'cm & inches'},
    {'q': '⚖️ An elephant weighs about ___ kg', 'opts': ['5000', '50', '500'], 'a': '5000'},
    {'q': '📐 Perimeter of a square (side 5cm) = ?', 'opts': ['20cm', '25cm', '10cm'], 'a': '20cm'},
    {'q': '📐 Area of rectangle 4×3 = ?', 'opts': ['12 sq cm', '7 sq cm', '14 sq cm'], 'a': '12 sq cm'},
    {'q': '🫗 A glass holds about ___ ml', 'opts': ['250', '1000', '50'], 'a': '250'},
    {'q': '📏 1 km = ___ meters', 'opts': ['1000', '100', '10000'], 'a': '1000'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _qs.length) return QuizResultScreen(score: _score, total: _qs.length, title: '📏 Measurement', color: const Color(0xFFFF9F43), onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _sel = null; _ans = false; }));
    final q = _qs[_q]; final isCorrect = _sel == q['a'];
    return Scaffold(backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            GestureDetector(onTap: widget.onBack, child: Container(width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFFF9F43).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFF9F43)))),
            const SizedBox(width: 12),
            Expanded(child: Text('📏 Measure ${_q + 1}/${_qs.length}', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800))),
            Text('⭐ $_score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (_q + 1) / _qs.length, minHeight: 8,
            backgroundColor: const Color(0xFFFF9F43).withOpacity(0.1), valueColor: const AlwaysStoppedAnimation(Color(0xFFFF9F43)))),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
            child: Text(q['q'] as String, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center)),
          const SizedBox(height: 16),
          ...(q['opts'] as List<String>).map((o) {
            final isSel = _sel == o; final isA = o == q['a'];
            Color bg = Colors.white, border = AppColors.textLight.withOpacity(0.2);
            if (_ans) { if (isA) { bg = AppColors.success.withOpacity(0.1); border = AppColors.success; }
              else if (isSel) { bg = AppColors.error.withOpacity(0.1); border = AppColors.error; } }
            return Padding(padding: const EdgeInsets.only(bottom: 10), child: GestureDetector(
              onTap: () { if (_ans) return; HapticFeedback.lightImpact();
                setState(() { _sel = o; _ans = true; if (o == q['a']) { _score++; widget.xpService.addXP(5); } }); },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 2)),
                child: Row(children: [Expanded(child: Text(o, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700))),
                  if (_ans && isA) const Icon(Icons.check_circle, color: AppColors.success),
                  if (_ans && isSel && !isA) const Icon(Icons.cancel, color: AppColors.error)]))));
          }),
          const Spacer(),
          if (_ans) PrimaryButton(label: _q < _qs.length - 1 ? 'Next →' : 'Results', onPressed: () =>
            setState(() { _q++; _sel = null; _ans = false; }), color: isCorrect ? AppColors.success : const Color(0xFFFF9F43)),
        ]))));
  }
}

