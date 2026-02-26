import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:ui';
import '../../core/theme/app_theme.dart';

// ══════════════════════════════════════════════════════════════
//  1. PRIMARY BUTTON – Duolingo 3D press with shadow + haptic
// ══════════════════════════════════════════════════════════════

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  Color get _darkerColor {
    final hsl = HSLColor.fromColor(widget.color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0, 1)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.mediumImpact();
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        margin: EdgeInsets.only(top: _pressed ? 4 : 0),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: _pressed ? [] : [
            BoxShadow(
              color: _darkerColor,
              blurRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: widget.isLoading
            ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white)))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.label,
                    style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  2. GLASS CARD – Glassmorphism with backdrop blur
// ══════════════════════════════════════════════════════════════

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  3. WORLD ITEM CARD – Letter/Number/Topic with states
// ══════════════════════════════════════════════════════════════

enum WorldItemState { locked, unlocked, completed, current }

class WorldItemCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String? sublabel;
  final Color color;
  final WorldItemState state;
  final bool isPro;
  final VoidCallback? onTap;
  final int? stars;

  const WorldItemCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.color,
    this.sublabel,
    this.state = WorldItemState.unlocked,
    this.isPro = false,
    this.onTap,
    this.stars,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = state == WorldItemState.locked;
    final isCompleted = state == WorldItemState.completed;
    final isCurrent = state == WorldItemState.current;

    return GestureDetector(
      onTap: isLocked ? null : () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: AnimatedContainer(
        duration: AppDurations.normal,
        decoration: BoxDecoration(
          gradient: isLocked ? null : LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: isLocked ? AppColors.lockedGrey.withValues(alpha: 0.3) : null,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isCurrent ? Colors.white : (isCompleted ? AppColors.accent1 : Colors.transparent),
            width: isCurrent ? 3 : (isCompleted ? 2.5 : 0),
          ),
          boxShadow: isLocked ? [] : AppShadows.soft(color),
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: TextStyle(fontSize: isLocked ? 24 : 30)),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isLocked ? AppColors.textLight : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (sublabel != null) Text(
                    sublabel!,
                    style: GoogleFonts.nunito(fontSize: 10, color: isLocked ? AppColors.textLight : Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  // Stars row
                  if (stars != null && !isLocked)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) => Icon(
                        i < stars! ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 14,
                        color: i < stars! ? AppColors.starActive : Colors.white38,
                      )),
                    ),
                ],
              ),
            ),
            // Lock icon
            if (isLocked)
              const Center(child: Icon(Icons.lock_rounded, color: AppColors.textLight, size: 20)),
            // PRO badge
            if (isPro && isLocked)
              Positioned(
                top: 4, right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.proBadge,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('PRO', style: GoogleFonts.nunito(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
            // Completed ring
            if (isCompleted)
              Positioned(
                top: 4, right: 4,
                child: Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.accent1,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  4. BRAIN METER – XP progress bar with gradient
// ══════════════════════════════════════════════════════════════

class BrainMeter extends StatelessWidget {
  final int currentXP;
  final bool showLevel;

  const BrainMeter({super.key, required this.currentXP, this.showLevel = true});

  @override
  Widget build(BuildContext context) {
    final level = AppLevels.forXP(currentXP);
    final progress = AppLevels.progressToNext(currentXP);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.glow(AppColors.xpPurple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${level.emoji} ${level.name}',
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              const Spacer(),
              Text('$currentXP XP', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 10),
          // XP bar
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0, 1),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF6B9D), Color(0xFFFFC312)]),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [BoxShadow(color: AppColors.xpPink.withValues(alpha: 0.5), blurRadius: 8)],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  5. STREAK CHIP + STAR CHIP – Pill badges
// ══════════════════════════════════════════════════════════════

class StreakChip extends StatelessWidget {
  final int count;
  const StreakChip({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.streakOrange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.streakOrange.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Text('🔥', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text('$count', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.streakOrange)),
      ]),
    );
  }
}

class StarChip extends StatelessWidget {
  final int count;
  const StarChip({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.starActive.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.starActive.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.star_rounded, size: 16, color: AppColors.starActive),
        const SizedBox(width: 4),
        Text('$count', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.starActive)),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  6. HEARTS DISPLAY – ❤️ depletion for 5-7 yrs
// ══════════════════════════════════════════════════════════════

class HeartsDisplay extends StatelessWidget {
  final int hearts;
  final int maxHearts;

  const HeartsDisplay({super.key, this.hearts = 3, this.maxHearts = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxHearts, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedSwitcher(
          duration: AppDurations.normal,
          child: Icon(
            i < hearts ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey('heart_$i\_${i < hearts}'),
            size: 22,
            color: i < hearts ? AppColors.heartRed : AppColors.lockedGrey,
          ),
        ),
      )),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  7. FILL BLANK WIDGET – Mimo-style sentence completion
// ══════════════════════════════════════════════════════════════

class FillBlankWidget extends StatefulWidget {
  final String sentenceBefore;  // "The apple"
  final String sentenceAfter;   // "red and sweet."
  final List<String> options;   // ["is", "am", "are", "was"]
  final String correctAnswer;   // "is"
  final Function(bool correct)? onAnswer;

  const FillBlankWidget({
    super.key,
    required this.sentenceBefore,
    required this.sentenceAfter,
    required this.options,
    required this.correctAnswer,
    this.onAnswer,
  });

  @override
  State<FillBlankWidget> createState() => _FillBlankWidgetState();
}

class _FillBlankWidgetState extends State<FillBlankWidget> with SingleTickerProviderStateMixin {
  String? _selected;
  bool? _isCorrect;
  late AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() { _shakeCtrl.dispose(); super.dispose(); }

  void _selectOption(String option) {
    if (_selected != null) return;
    final correct = option == widget.correctAnswer;
    setState(() { _selected = option; _isCorrect = correct; });
    if (correct) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward(from: 0);
    }
    widget.onAnswer?.call(correct);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sentence with blank
        AnimatedBuilder(
          animation: _shakeCtrl,
          builder: (context, child) {
            final dx = _shakeCtrl.isAnimating ? sin(_shakeCtrl.value * pi * 4) * 8 : 0.0;
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: _isCorrect == null ? AppColors.textLight
                    : (_isCorrect! ? AppColors.success : AppColors.error),
                width: 2,
              ),
              boxShadow: AppShadows.card,
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('${widget.sentenceBefore} ',
                    style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                // The blank
                AnimatedContainer(
                  duration: AppDurations.normal,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _selected == null ? AppColors.primary.withValues(alpha: 0.08)
                        : (_isCorrect! ? AppColors.success.withValues(alpha: 0.15) : AppColors.error.withValues(alpha: 0.15)),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: _selected == null ? AppColors.primary
                          : (_isCorrect! ? AppColors.success : AppColors.error),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _selected ?? '______',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _selected == null ? AppColors.primary
                          : (_isCorrect! ? AppColors.success : AppColors.error),
                    ),
                  ),
                ),
                Text(' ${widget.sentenceAfter}',
                    style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Options chips
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.options.map((opt) {
            final isThis = _selected == opt;
            final showCorrect = _selected != null && opt == widget.correctAnswer;
            return GestureDetector(
              onTap: () => _selectOption(opt),
              child: AnimatedContainer(
                duration: AppDurations.normal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isThis
                      ? (_isCorrect! ? AppColors.success : AppColors.error)
                      : (showCorrect ? AppColors.success.withValues(alpha: 0.2) : Colors.white),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: isThis
                        ? (_isCorrect! ? AppColors.success : AppColors.error)
                        : (showCorrect ? AppColors.success : AppColors.textLight),
                    width: 2,
                  ),
                  boxShadow: isThis ? [] : AppShadows.button3D(
                    showCorrect ? AppColors.success : AppColors.textLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  opt,
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isThis ? Colors.white : (showCorrect ? AppColors.success : AppColors.textDark),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  8. SENTENCE BUILDER WIDGET – Drag blocks into order
// ══════════════════════════════════════════════════════════════

class SentenceBuilderWidget extends StatefulWidget {
  final List<String> correctOrder;  // ["The", "dog", "eats", "meat", "."]
  final Function(bool correct)? onComplete;

  const SentenceBuilderWidget({
    super.key,
    required this.correctOrder,
    this.onComplete,
  });

  @override
  State<SentenceBuilderWidget> createState() => _SentenceBuilderWidgetState();
}

class _SentenceBuilderWidgetState extends State<SentenceBuilderWidget> {
  late List<String> _available;
  final List<String> _placed = [];
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _available = List.from(widget.correctOrder)..shuffle();
  }

  void _placeWord(String word) {
    setState(() {
      _available.remove(word);
      _placed.add(word);
    });
    HapticFeedback.lightImpact();

    if (_available.isEmpty) {
      final correct = _placed.join(' ') == widget.correctOrder.join(' ');
      setState(() => _isCorrect = correct);
      if (correct) HapticFeedback.mediumImpact();
      widget.onComplete?.call(correct);
    }
  }

  void _removePlaced(int index) {
    if (_isCorrect != null) return;
    setState(() {
      _available.add(_placed.removeAt(index));
    });
  }

  void _reset() {
    setState(() {
      _available = List.from(widget.correctOrder)..shuffle();
      _placed.clear();
      _isCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Answer area
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isCorrect == null ? Colors.white
                : (_isCorrect! ? AppColors.success.withValues(alpha: 0.08) : AppColors.error.withValues(alpha: 0.08)),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: _isCorrect == null ? AppColors.textLight
                  : (_isCorrect! ? AppColors.success : AppColors.error),
              width: 2,
            ),
          ),
          child: _placed.isEmpty
              ? Text('Tap words to build the sentence',
                  style: GoogleFonts.nunito(fontSize: 15, color: AppColors.textLight))
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_placed.length, (i) => GestureDetector(
                    onTap: () => _removePlaced(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      child: Text(_placed[i],
                          style: GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                  )),
                ),
        ),
        const SizedBox(height: 16),
        // Available words
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _available.map((word) => GestureDetector(
            onTap: () => _placeWord(word),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.textLight, width: 1.5),
                boxShadow: AppShadows.button3D(AppColors.textLight.withValues(alpha: 0.3)),
              ),
              child: Text(word, style: GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            ),
          )).toList(),
        ),
        if (_isCorrect == false) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _reset,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 18),
              const SizedBox(width: 4),
              Text('Try again', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ]),
          ),
        ],
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  9. SUBJECT WORLD TILE – Home screen world entry card
// ══════════════════════════════════════════════════════════════

class SubjectWorldTile extends StatelessWidget {
  final String emoji;
  final String title;
  final LinearGradient gradient;
  final int progress; // 0–100
  final bool isLocked;
  final VoidCallback? onTap;

  const SubjectWorldTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.gradient,
    this.progress = 0,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isLocked ? null : gradient,
          color: isLocked ? AppColors.lockedGrey.withValues(alpha: 0.15) : null,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: isLocked ? [] : AppShadows.soft(gradient.colors.first),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: TextStyle(fontSize: isLocked ? 28 : 36)),
                  const SizedBox(height: 8),
                  Text(title, style: GoogleFonts.nunito(
                    fontSize: 14, fontWeight: FontWeight.w800,
                    color: isLocked ? AppColors.textLight : Colors.white,
                  )),
                  if (!isLocked && progress > 0) ...[
                    const SizedBox(height: 8),
                    // Mini progress bar
                    Stack(children: [
                      Container(height: 4, decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      )),
                      FractionallySizedBox(
                        widthFactor: progress / 100,
                        child: Container(height: 4, decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        )),
                      ),
                    ]),
                  ],
                ],
              ),
            ),
            if (isLocked)
              Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.lock_rounded, color: AppColors.textLight, size: 18),
                  Text('Coming Soon', style: GoogleFonts.nunito(fontSize: 9, color: AppColors.textLight, fontWeight: FontWeight.w700)),
                ],
              )),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  10. FREEMIUM OVERLAY – Paywall bottom sheet
// ══════════════════════════════════════════════════════════════

class FreemiumOverlay extends StatelessWidget {
  final VoidCallback? onSubscribe;
  final VoidCallback? onDismiss;

  const FreemiumOverlay({super.key, this.onSubscribe, this.onDismiss});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FreemiumOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(
            color: AppColors.textLight, borderRadius: BorderRadius.circular(2),
          )),
          const SizedBox(height: 24),
          const Text('🔒', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('Unlock Full Learning', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Get access to all subjects & features',
              style: GoogleFonts.nunito(fontSize: 15, color: AppColors.textMedium)),
          const SizedBox(height: 24),
          // Benefits
          ...[
            ('🔤', 'All 26 Letters + Grammar'),
            ('🔢', 'Math World — Numbers & Shapes'),
            ('🌿', 'EVS World — Science & Nature'),
            ('🧘', 'Values — Emotions & Life Skills'),
            ('📖', 'AI Story Generator'),
            ('📊', 'Full Parent Dashboard'),
          ].map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Text(b.$1, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(child: Text(b.$2, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600))),
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
            ]),
          )),
          const SizedBox(height: 20),
          // Price
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppGradients.gold,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(children: [
              Text('₹199/month', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
              Text('or ₹999/year (save 58%)', style: GoogleFonts.nunito(fontSize: 14, color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Start 7-Day Free Trial',
            onPressed: () {
              onSubscribe?.call();
              Navigator.of(context).pop();
            },
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              onDismiss?.call();
              Navigator.of(context).pop();
            },
            child: Text('Maybe later', style: GoogleFonts.nunito(color: AppColors.textMedium, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  EXISTING WIDGETS (preserved from original)
// ══════════════════════════════════════════════════════════════

/// Duolingo-style elevated button with gradient, shadow and bounce effect
class DuoButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double width;

  const DuoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primary,
    this.width = double.infinity,
  });

  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onPressed(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _pressed ? [] : [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.4),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        transform: _pressed ? (Matrix4.identity()..translate(0.0, 4.0)) : Matrix4.identity(),
        child: Center(
          child: Text(widget.text, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ),
    );
  }
}

/// Duolingo-style progress bar with animated fill
class DuoProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;

  const DuoProgressBar({
    super.key,
    required this.progress,
    this.color = AppColors.primary,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(height / 2)),
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0, 1),
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 4)],
          ),
        ),
      ),
    );
  }
}

/// Star rating display
class StarRating extends StatelessWidget {
  final int stars;
  final int maxStars;
  final double size;

  const StarRating({super.key, int? stars, int? current, int? maxStars, int? max, this.size = 28})
      : stars = stars ?? current ?? 0,
        maxStars = maxStars ?? max ?? 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) => Icon(
        i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
        color: i < stars ? AppColors.starActive : AppColors.starInactive,
        size: size,
      )),
    );
  }
}

/// Circular progress ring
class ProgressRing extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.progress,
    this.color = AppColors.primary,
    this.size = 80,
    this.strokeWidth = 8,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox(
          width: size, height: size,
          child: CircularProgressIndicator(
            value: progress.clamp(0, 1),
            strokeWidth: strokeWidth,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        if (child != null) child!,
      ]),
    );
  }
}

/// Animated character emoji
class CharacterEmoji extends StatelessWidget {
  final String emoji;
  final double size;

  const CharacterEmoji({super.key, required this.emoji, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Text(emoji, style: TextStyle(fontSize: size));
  }
}

/// Premium glassmorphism card
class DuoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final LinearGradient? gradient;

  const DuoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? Colors.white) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }
}

/// Section header
class DuoSectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  final Color? color;

  const DuoSectionHeader({super.key, required this.title, this.trailing, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
      const Spacer(),
      if (trailing != null) Text(trailing!, style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMedium)),
    ]);
  }
}

/// Shake animation widget for wrong answers
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shake;

  const ShakeWidget({super.key, required this.child, this.shake = false});

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _anim = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticIn));
  }

  @override
  void didUpdateWidget(ShakeWidget old) {
    super.didUpdateWidget(old);
    if (widget.shake && !old.shake) trigger();
  }

  void trigger() {
    _ctrl.forward(from: 0);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(sin(_anim.value * pi * 3) * 10, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Category tile for explore row
class CategoryTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const CategoryTile({super.key, required this.emoji, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88, height: 88,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ]),
      ),
    );
  }
}

/// Bounce scale animation widget
class BounceWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const BounceWidget({super.key, required this.child, this.onTap});

  @override
  State<BounceWidget> createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<BounceWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150), lowerBound: 0.9, upperBound: 1.0, value: 1.0);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) { _ctrl.forward(); widget.onTap?.call(); },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(scale: _ctrl, child: widget.child),
    );
  }
}

/// Pulsing glow widget for attention elements
class PulseWidget extends StatefulWidget {
  final Widget child;
  final Color glowColor;

  const PulseWidget({super.key, required this.child, this.glowColor = AppColors.primary});

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: widget.glowColor.withValues(alpha: 0.15 + _ctrl.value * 0.25), blurRadius: 16 + _ctrl.value * 12, spreadRadius: _ctrl.value * 4)],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Daily mission card for home screen
class DailyMissionCard extends StatelessWidget {
  final String subject;
  final String topic;
  final int completedLessons;
  final int totalLessons;
  final Color color;
  final VoidCallback? onTap;

  const DailyMissionCard({
    super.key,
    required this.subject,
    required this.topic,
    required this.completedLessons,
    required this.totalLessons,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(topic, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            const SizedBox(height: 8),
            // Progress dots
            Row(children: List.generate(totalLessons, (i) => Container(
              width: 8, height: 8,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: i < completedLessons ? color : color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ))),
            const SizedBox(height: 4),
            Text('$completedLessons/$totalLessons', style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textMedium)),
          ],
        ),
      ),
    );
  }
}
