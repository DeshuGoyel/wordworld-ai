import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:async';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/exercise_bank.dart';
import '../../../../core/widgets/tappable.dart';

class MemoryGame extends StatefulWidget {
  final Exercise exercise;
  final Color color;
  final bool isAnswered;
  final Function(String) onAnswer;
  final String topicEmoji;

  const MemoryGame({
    super.key,
    required this.exercise,
    required this.color,
    required this.isAnswered,
    required this.onAnswer,
    required this.topicEmoji,
  });

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late List<String> _cards;
  late List<bool> _isFlipped;
  late List<bool> _isMatched;
  
  int? _firstFlippedIndex;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    // Take options, duplicate them to make pairs
    final pairs = [...widget.exercise.options, ...widget.exercise.options];
    pairs.shuffle(Random());
    
    _cards = pairs;
    _isFlipped = List.generate(_cards.length, (i) => false);
    _isMatched = List.generate(_cards.length, (i) => false);
  }

  void _onCardTapped(int index) {
    if (_isProcessing || widget.isAnswered || _isFlipped[index] || _isMatched[index]) return;

    setState(() {
      _isFlipped[index] = true;
    });
    
    HapticFeedback.lightImpact();

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      _isProcessing = true;
      final firstIndex = _firstFlippedIndex!;
      final secondIndex = index;

      if (_cards[firstIndex] == _cards[secondIndex]) {
        // Match!
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          HapticFeedback.lightImpact();
          setState(() {
            _isMatched[firstIndex] = true;
            _isMatched[secondIndex] = true;
            _firstFlippedIndex = null;
            _isProcessing = false;
            
            _checkCompletion();
          });
        });
      } else {
        // No match
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) return;
          setState(() {
            _isFlipped[firstIndex] = false;
            _isFlipped[secondIndex] = false;
            _firstFlippedIndex = null;
            _isProcessing = false;
          });
        });
      }
    }
  }

  void _checkCompletion() {
    if (_isMatched.every((matched) => matched)) {
      // Game complete! Pass the correct answer to complete
      widget.onAnswer(widget.exercise.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.topicEmoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 12),
        Text(
          widget.exercise.question,
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = _cards.length > 6 ? 3 : 2;
              
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: _cards.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final flipped = _isFlipped[index] || _isMatched[index];
                  
                  return Tappable(
                    onTap: () => _onCardTapped(index),
                    child: AnimatedContainer(
                      duration: AppDurations.fast,
                      decoration: BoxDecoration(
                        color: flipped 
                            ? (_isMatched[index] ? AppColors.success.withValues(alpha: 0.1) : Colors.white)
                            : widget.color.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: flipped 
                              ? (_isMatched[index] ? AppColors.success : widget.color.withValues(alpha: 0.3))
                              : widget.color,
                          width: flipped ? 2 : 0,
                        ),
                        boxShadow: flipped && !_isMatched[index] 
                            ? AppShadows.card 
                            : (_isMatched[index] ? [] : [BoxShadow(color: widget.color.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4))]),
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: AppDurations.fast,
                          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                          child: flipped
                              ? Text(
                                  _cards[index],
                                  key: ValueKey('flipped_$index'),
                                  style: GoogleFonts.nunito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textDark,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Icon(
                                  Icons.help_outline_rounded,
                                  key: ValueKey('unflipped_$index'),
                                  size: 40,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
