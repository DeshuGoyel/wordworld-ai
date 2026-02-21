import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/xp_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../../shared/widgets/quiz_result_screen.dart';

/// Advanced EVS — Plants, Animals, Weather, Community Helpers
class AdvancedEVSScreen extends ConsumerStatefulWidget {
  const AdvancedEVSScreen({super.key});
  @override ConsumerState<AdvancedEVSScreen> createState() => _AdvancedEVSScreenState();
}

class _AdvancedEVSScreenState extends ConsumerState<AdvancedEVSScreen> {
  int _sel = -1;
  static const _modules = [
    {'emoji': '🌱', 'title': 'Plants', 'desc': 'Parts, lifecycle, photosynthesis', 'color': 0xFF00B894},
    {'emoji': '🦁', 'title': 'Animals', 'desc': 'Habitats, diets, classification', 'color': 0xFFFF9F43},
    {'emoji': '🌤️', 'title': 'Weather', 'desc': 'Seasons, water cycle, climate', 'color': 0xFF0984E3},
    {'emoji': '👨‍⚕️', 'title': 'Community Helpers', 'desc': 'Professions, roles, tools', 'color': 0xFFE17055},
  ];

  @override
  Widget build(BuildContext context) {
    if (_sel >= 0) {
      switch (_sel) {
        case 0: return _PlantsModule(onBack: () => setState(() => _sel = -1), xpService: ref.read(xpServiceProvider));
        case 1: return _AnimalsModule(onBack: () => setState(() => _sel = -1), xpService: ref.read(xpServiceProvider));
        case 2: return _WeatherModule(onBack: () => setState(() => _sel = -1), xpService: ref.read(xpServiceProvider));
        case 3: return _CommunityModule(onBack: () => setState(() => _sel = -1), xpService: ref.read(xpServiceProvider));
      }
    }

    return Scaffold(backgroundColor: AppColors.bgLight,
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            GestureDetector(onTap: () => context.pop(),
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.evsWorld.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.evsWorld))),
            const SizedBox(width: 12),
            Text('🌍 Advanced EVS', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppGradients.evs, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🌍🌿🦋', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text('Explore the World Around You!', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              Text('Plants, animals, weather & helpers', style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70)),
            ])),
          const SizedBox(height: 24),
          ...List.generate(_modules.length, (i) {
            final m = _modules[i]; final c = Color(m['color'] as int);
            return Padding(padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(onTap: () => setState(() => _sel = i),
                child: Container(padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
                  child: Row(children: [
                    Container(width: 50, height: 50, decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text(m['emoji'] as String, style: const TextStyle(fontSize: 24)))),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m['title'] as String, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(m['desc'] as String, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMedium)),
                    ])),
                    Icon(Icons.play_circle_filled_rounded, size: 36, color: c),
                  ]))));
          }),
        ]))));
  }
}

// ═══ PLANTS ═══
class _PlantsModule extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _PlantsModule({required this.onBack, required this.xpService});
  @override State<_PlantsModule> createState() => _PlantsModuleState();
}
class _PlantsModuleState extends State<_PlantsModule> {
  int _q = 0; int _score = 0; String? _sel; bool _ans = false;
  static const _qs = [
    {'q': '🌱 Plants make food through ___', 'opts': ['Photosynthesis', 'Digestion', 'Breathing'], 'a': 'Photosynthesis'},
    {'q': '🌿 Plants need ___ for photosynthesis', 'opts': ['Sunlight, water, CO₂', 'Milk, bread', 'Meat, fish'], 'a': 'Sunlight, water, CO₂'},
    {'q': '🌳 Which part of plant absorbs water?', 'opts': ['Roots', 'Leaves', 'Flowers'], 'a': 'Roots'},
    {'q': '🍃 Leaves are green because of ___', 'opts': ['Chlorophyll', 'Paint', 'Water'], 'a': 'Chlorophyll'},
    {'q': '🌸 Flowers help plants in ___', 'opts': ['Reproduction', 'Eating', 'Sleeping'], 'a': 'Reproduction'},
    {'q': '🌻 Sunflowers turn towards the ___', 'opts': ['Sun', 'Moon', 'Stars'], 'a': 'Sun'},
    {'q': '🫘 Seeds grow into new ___', 'opts': ['Plants', 'Animals', 'Rocks'], 'a': 'Plants'},
    {'q': '🌲 Evergreen trees keep leaves in ___', 'opts': ['All seasons', 'Only summer', 'Only spring'], 'a': 'All seasons'},
    {'q': '🍄 Mushrooms are ___', 'opts': ['Fungi', 'Plants', 'Animals'], 'a': 'Fungi'},
    {'q': '🌵 Cacti store water in their ___', 'opts': ['Stems', 'Leaves', 'Roots'], 'a': 'Stems'},
    {'q': '🪴 Plants release ___ (we breathe it)', 'opts': ['Oxygen', 'Carbon dioxide', 'Nitrogen'], 'a': 'Oxygen'},
    {'q': '🌾 Rice and wheat are ___ plants', 'opts': ['Crop/cereal', 'Ornamental', 'Medicinal'], 'a': 'Crop/cereal'},
    {'q': '🥕 Carrot is a ___', 'opts': ['Root vegetable', 'Leaf vegetable', 'Fruit'], 'a': 'Root vegetable'},
    {'q': '🍎 Which is a fruit?', 'opts': ['Apple', 'Potato', 'Onion'], 'a': 'Apple'},
    {'q': '🌿 Tulsi (basil) is a ___ plant', 'opts': ['Medicinal', 'Poisonous', 'Aquatic'], 'a': 'Medicinal'},
  ];

  @override Widget build(BuildContext context) => _evsQuiz('🌱 Plants', const Color(0xFF00B894));
  Widget _evsQuiz(String title, Color color) {
    if (_q >= _qs.length) return QuizResultScreen(
      score: _score, total: _qs.length, title: title, color: color,
      onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _sel = null; _ans = false; }));
    final q = _qs[_q]; final isC = _sel == q['a'];
    return _EVSQuizShell(title: title, q: _q, total: _qs.length, score: _score, question: q['q'] as String,
      options: q['opts'] as List<String>, answer: q['a'] as String, selected: _sel, answered: _ans,
      onBack: widget.onBack, color: color,
      onSelect: (v) { if (_ans) return; HapticFeedback.lightImpact();
        setState(() { _sel = v; _ans = true; if (v == q['a']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _sel = null; _ans = false; }));
  }
}

// ═══ ANIMALS ═══
class _AnimalsModule extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _AnimalsModule({required this.onBack, required this.xpService});
  @override State<_AnimalsModule> createState() => _AnimalsModuleState();
}
class _AnimalsModuleState extends State<_AnimalsModule> {
  int _q = 0; int _score = 0; String? _sel; bool _ans = false;
  static const _qs = [
    {'q': '🦁 Lion lives in ___', 'opts': ['Jungle/forest', 'Ocean', 'Sky'], 'a': 'Jungle/forest'},
    {'q': '🐟 Fish breathe through ___', 'opts': ['Gills', 'Lungs', 'Nose'], 'a': 'Gills'},
    {'q': '🦅 Birds have ___ to fly', 'opts': ['Wings', 'Fins', 'Legs'], 'a': 'Wings'},
    {'q': '🐄 Cow gives us ___', 'opts': ['Milk', 'Eggs', 'Wool'], 'a': 'Milk'},
    {'q': '🐓 Hen gives us ___', 'opts': ['Eggs', 'Milk', 'Honey'], 'a': 'Eggs'},
    {'q': '🐸 Frog can live in water and ___', 'opts': ['Land (amphibian)', 'Sky', 'Underground'], 'a': 'Land (amphibian)'},
    {'q': '🐍 Snake is a ___', 'opts': ['Reptile', 'Mammal', 'Bird'], 'a': 'Reptile'},
    {'q': '🦇 Bat is a ___ (not a bird!)', 'opts': ['Mammal', 'Bird', 'Insect'], 'a': 'Mammal'},
    {'q': '🐝 Bees make ___', 'opts': ['Honey', 'Milk', 'Silk'], 'a': 'Honey'},
    {'q': '🕷️ Spider makes ___', 'opts': ['Web', 'Nest', 'Hive'], 'a': 'Web'},
    {'q': '🦋 Caterpillar becomes a ___', 'opts': ['Butterfly', 'Bird', 'Fish'], 'a': 'Butterfly'},
    {'q': '🐊 Crocodile lives in ___', 'opts': ['Water & land', 'Only water', 'Only land'], 'a': 'Water & land'},
    {'q': '🐧 Penguins live in ___', 'opts': ['Cold/Antarctic', 'Hot desert', 'Tropical'], 'a': 'Cold/Antarctic'},
    {'q': '🐪 Camel is called ship of ___', 'opts': ['Desert', 'Sea', 'Sky'], 'a': 'Desert'},
    {'q': '🐘 Elephant is the ___ land animal', 'opts': ['Largest', 'Smallest', 'Fastest'], 'a': 'Largest'},
  ];

  @override Widget build(BuildContext context) {
    if (_q >= _qs.length) return QuizResultScreen(
      score: _score, total: _qs.length, title: '🦁 Animals', color: const Color(0xFFFF9F43),
      onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _sel = null; _ans = false; }));
    final q = _qs[_q];
    return _EVSQuizShell(title: '🦁 Animals', q: _q, total: _qs.length, score: _score, question: q['q'] as String,
      options: q['opts'] as List<String>, answer: q['a'] as String, selected: _sel, answered: _ans,
      onBack: widget.onBack, color: const Color(0xFFFF9F43),
      onSelect: (v) { if (_ans) return; HapticFeedback.lightImpact();
        setState(() { _sel = v; _ans = true; if (v == q['a']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _sel = null; _ans = false; }));
  }
}

// ═══ WEATHER ═══
class _WeatherModule extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _WeatherModule({required this.onBack, required this.xpService});
  @override State<_WeatherModule> createState() => _WeatherModuleState();
}
class _WeatherModuleState extends State<_WeatherModule> {
  int _q = 0; int _score = 0; String? _sel; bool _ans = false;
  static const _qs = [
    {'q': '☀️ How many seasons in India?', 'opts': ['3 (summer, rainy, winter)', '2', '4'], 'a': '3 (summer, rainy, winter)'},
    {'q': '🌧️ Rain comes from ___', 'opts': ['Clouds', 'Sun', 'Moon'], 'a': 'Clouds'},
    {'q': '💧 Water cycle: Sun heats water → ___', 'opts': ['Evaporation', 'Freezing', 'Melting'], 'a': 'Evaporation'},
    {'q': '☁️ Clouds form when water ___ rises', 'opts': ['Vapor', 'Ice', 'Liquid'], 'a': 'Vapor'},
    {'q': '❄️ Snow forms when temperature is ___', 'opts': ['Below 0°C', 'Above 50°C', 'Exactly 20°C'], 'a': 'Below 0°C'},
    {'q': '🌈 Rainbow appears after ___', 'opts': ['Rain + sunshine', 'Snowfall', 'Earthquake'], 'a': 'Rain + sunshine'},
    {'q': '🌪️ A tornado is a spinning ___', 'opts': ['Wind funnel', 'Water wave', 'Sand hill'], 'a': 'Wind funnel'},
    {'q': '⛈️ Thunder is the ___ of lightning', 'opts': ['Sound', 'Color', 'Smell'], 'a': 'Sound'},
    {'q': '🌡️ Summer temperatures in India can reach ___', 'opts': ['45°C+', '10°C', '-5°C'], 'a': '45°C+'},
    {'q': '🧊 Winter in north India can be ___', 'opts': ['Very cold (0-5°C)', 'Very hot', 'Rainy'], 'a': 'Very cold (0-5°C)'},
    {'q': '💨 Wind is moving ___', 'opts': ['Air', 'Water', 'Earth'], 'a': 'Air'},
    {'q': '🌤️ Fog is a low-lying ___', 'opts': ['Cloud', 'Rain', 'Snow'], 'a': 'Cloud'},
    {'q': '☔ Monsoon season brings ___', 'opts': ['Heavy rains', 'Snow', 'Drought'], 'a': 'Heavy rains'},
    {'q': '🌡️ We measure temperature with a ___', 'opts': ['Thermometer', 'Ruler', 'Scale'], 'a': 'Thermometer'},
    {'q': '🌍 Climate change is caused by ___', 'opts': ['Pollution/CO₂', 'Planting trees', 'Recycling'], 'a': 'Pollution/CO₂'},
  ];

  @override Widget build(BuildContext context) {
    if (_q >= _qs.length) return QuizResultScreen(
      score: _score, total: _qs.length, title: '🌤️ Weather', color: const Color(0xFF0984E3),
      onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _sel = null; _ans = false; }));
    final q = _qs[_q];
    return _EVSQuizShell(title: '🌤️ Weather', q: _q, total: _qs.length, score: _score, question: q['q'] as String,
      options: q['opts'] as List<String>, answer: q['a'] as String, selected: _sel, answered: _ans,
      onBack: widget.onBack, color: const Color(0xFF0984E3),
      onSelect: (v) { if (_ans) return; HapticFeedback.lightImpact();
        setState(() { _sel = v; _ans = true; if (v == q['a']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _sel = null; _ans = false; }));
  }
}

// ═══ COMMUNITY HELPERS ═══
class _CommunityModule extends StatefulWidget {
  final VoidCallback onBack; final XPService xpService;
  const _CommunityModule({required this.onBack, required this.xpService});
  @override State<_CommunityModule> createState() => _CommunityModuleState();
}
class _CommunityModuleState extends State<_CommunityModule> {
  int _q = 0; int _score = 0; String? _sel; bool _ans = false;
  static const _qs = [
    {'q': '👨‍⚕️ A doctor helps us when we are ___', 'opts': ['Sick', 'Hungry', 'Bored'], 'a': 'Sick'},
    {'q': '👩‍🏫 A teacher works in a ___', 'opts': ['School', 'Hospital', 'Farm'], 'a': 'School'},
    {'q': '🚒 A firefighter puts out ___', 'opts': ['Fires', 'Water', 'Food'], 'a': 'Fires'},
    {'q': '👮 A police officer keeps us ___', 'opts': ['Safe', 'Hungry', 'Sleepy'], 'a': 'Safe'},
    {'q': '🧑‍🌾 A farmer grows ___', 'opts': ['Food/crops', 'Buildings', 'Cars'], 'a': 'Food/crops'},
    {'q': '📮 A postman delivers ___', 'opts': ['Letters/mail', 'Food', 'Clothes'], 'a': 'Letters/mail'},
    {'q': '👨‍🍳 A chef works in a ___', 'opts': ['Kitchen/restaurant', 'Hospital', 'School'], 'a': 'Kitchen/restaurant'},
    {'q': '🧑‍✈️ A pilot flies ___', 'opts': ['Airplanes', 'Cars', 'Boats'], 'a': 'Airplanes'},
    {'q': '👷 A construction worker builds ___', 'opts': ['Buildings', 'Food', 'Clothes'], 'a': 'Buildings'},
    {'q': '🧑‍⚖️ A judge works in a ___', 'opts': ['Court', 'Hospital', 'Farm'], 'a': 'Court'},
    {'q': '🚑 Ambulance takes people to ___', 'opts': ['Hospital', 'School', 'Park'], 'a': 'Hospital'},
    {'q': '🧹 A sweeper keeps our city ___', 'opts': ['Clean', 'Dirty', 'Noisy'], 'a': 'Clean'},
    {'q': '💊 A pharmacist gives us ___', 'opts': ['Medicine', 'Food', 'Toys'], 'a': 'Medicine'},
    {'q': '🚌 A bus driver helps people ___', 'opts': ['Travel', 'Cook', 'Study'], 'a': 'Travel'},
    {'q': '📰 A journalist reports ___', 'opts': ['News', 'Weather only', 'Sports only'], 'a': 'News'},
  ];

  @override Widget build(BuildContext context) {
    if (_q >= _qs.length) return QuizResultScreen(
      score: _score, total: _qs.length, title: '👨‍⚕️ Community', color: const Color(0xFFE17055),
      onBack: widget.onBack,
      onRetry: () => setState(() { _q = 0; _score = 0; _sel = null; _ans = false; }));
    final q = _qs[_q];
    return _EVSQuizShell(title: '👨‍⚕️ Helpers', q: _q, total: _qs.length, score: _score, question: q['q'] as String,
      options: q['opts'] as List<String>, answer: q['a'] as String, selected: _sel, answered: _ans,
      onBack: widget.onBack, color: const Color(0xFFE17055),
      onSelect: (v) { if (_ans) return; HapticFeedback.lightImpact();
        setState(() { _sel = v; _ans = true; if (v == q['a']) { _score++; widget.xpService.addXP(5); } }); },
      onNext: () => setState(() { _q++; _sel = null; _ans = false; }));
  }
}

// ═══════════ SHARED EVS QUIZ SHELL ═══════════
class _EVSQuizShell extends StatelessWidget {
  final String title, question, answer;
  final int q, total, score;
  final List<String> options;
  final String? selected;
  final bool answered;
  final Color color;
  final VoidCallback onBack, onNext;
  final ValueChanged<String> onSelect;

  const _EVSQuizShell({required this.title, required this.q, required this.total, required this.score,
    required this.question, required this.options, required this.answer, required this.selected,
    required this.answered, required this.onBack, required this.onNext, required this.onSelect, required this.color});

  @override Widget build(BuildContext context) {
    final isCorrect = selected == answer;
    return Scaffold(backgroundColor: AppColors.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            GestureDetector(onTap: onBack, child: Container(width: 40, height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.arrow_back_rounded, color: color))),
            const SizedBox(width: 12),
            Expanded(child: Text('$title ${q + 1}/$total', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800))),
            Text('⭐ $score', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.starActive)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: (q + 1) / total, minHeight: 8,
              backgroundColor: color.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(color))),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: AppShadows.card),
            child: Text(question, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center)),
          const SizedBox(height: 16),
          ...options.map((opt) {
            final isThis = selected == opt; final isAns = opt == answer;
            Color bg = Colors.white, border = AppColors.textLight.withOpacity(0.2);
            if (answered) { if (isAns) { bg = AppColors.success.withOpacity(0.1); border = AppColors.success; }
              else if (isThis) { bg = AppColors.error.withOpacity(0.1); border = AppColors.error; } }
            return Padding(padding: const EdgeInsets.only(bottom: 10), child: GestureDetector(onTap: () => onSelect(opt),
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 2)),
                child: Row(children: [Expanded(child: Text(opt, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700))),
                  if (answered && isAns) const Icon(Icons.check_circle, color: AppColors.success),
                  if (answered && isThis && !isAns) const Icon(Icons.cancel, color: AppColors.error)]))));
          }),
          const Spacer(),
          if (answered) PrimaryButton(label: q < total - 1 ? 'Next →' : 'Results', onPressed: onNext, color: isCorrect ? AppColors.success : color),
        ]))));
  }
}

