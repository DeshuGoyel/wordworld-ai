import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/progress_service.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/app_providers.dart';
import '../../../../shared/widgets/shared_widgets.dart';

class ThinkTab extends ConsumerStatefulWidget {
  final WordData word;
  const ThinkTab({super.key, required this.word});
  @override
  ConsumerState<ThinkTab> createState() => _ThinkTabState();
}

class _ThinkTabState extends ConsumerState<ThinkTab> with TickerProviderStateMixin {
  int _currentGame = 0;
  bool _gameActive = true;
  String? _selectedAnswer;
  bool? _isCorrect;
  int _score = 0;
  late ConfettiController _confettiController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  ThinkGame get _game => widget.word.thinkGames[_currentGame];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));

    // Speak the first question
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final tts = ref.read(ttsServiceProvider);
        tts.speakEnglish(_game.instruction);
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    final correct = _game.config['correct'] as String;
    final isCorrect = answer == correct;
    setState(() { _selectedAnswer = answer; _isCorrect = isCorrect; });

    final sound = ref.read(soundServiceProvider);
    final tts = ref.read(ttsServiceProvider);

    if (isCorrect) {
      _score++;
      sound.playCorrect();
      _confettiController.play();
    } else {
      sound.playWrong();
      _shakeController.forward(from: 0);
    }

    Future.delayed(Duration(seconds: isCorrect ? 2 : 1), () {
      if (!mounted) return;
      if (isCorrect) {
        final child = ref.read(activeChildProvider);
        if (child != null) ref.read(progressServiceProvider).completeTab(child.id, widget.word.id, 'think');

        if (_currentGame < widget.word.thinkGames.length - 1) {
          setState(() { _currentGame++; _selectedAnswer = null; _isCorrect = null; });
          // Speak next question
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) tts.speakEnglish(widget.word.thinkGames[_currentGame].instruction);
          });
        } else {
          setState(() => _gameActive = false);
          sound.playStarEarned();
        }
      } else {
        setState(() { _selectedAnswer = null; _isCorrect = null; });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameActive) return _buildComplete();

    final options = List<String>.from(_game.config['options'] ?? []);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // ═══════ AI GAME LAB HEADER ═══════
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('🧠 AI GAME LAB', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.thinkTab.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Text('Level ${(_score ~/ 3) + 1} ⭐', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.thinkTab)),
              ),
              const Spacer(),
            ]),
            const SizedBox(height: 12),
            // Character intro with gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.thinkTab.withValues(alpha: 0.12), AppColors.thinkTab.withValues(alpha: 0.04)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.thinkTab.withValues(alpha: 0.2)),
              ),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.thinkTab.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: Text(widget.word.emoji, style: const TextStyle(fontSize: 32))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_game.title, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.thinkTab)),
                  const SizedBox(height: 2),
                  Text(_game.instruction, style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textDark)),
                  Text(_game.instructionHi, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMedium)),
                ])),
                // Speaker button
                GestureDetector(
                  onTap: () => ref.read(ttsServiceProvider).speakEnglish(_game.instruction),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.thinkTab.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.volume_up_rounded, color: AppColors.thinkTab, size: 22),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // Score + game progress
            Row(children: [
              // Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppGradients.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text('$_score', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
              ),
              const SizedBox(width: 8),
              // Progress
              Expanded(child: DuoProgressBar(
                progress: (_currentGame + 1) / widget.word.thinkGames.length,
                color: AppColors.thinkTab, height: 12,
              )),
              const SizedBox(width: 8),
              Text('${_currentGame + 1}/${widget.word.thinkGames.length}',
                style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMedium)),
            ]),
            const SizedBox(height: 20),

            // Options grid with animations
            if (_game.type == 'find') ...[
              AnimatedBuilder(
                animation: _shakeController,
                builder: (_, child) => Transform.translate(
                  offset: Offset(sin(_shakeController.value * pi * 4) * 6, 0),
                  child: child,
                ),
                child: GridView.count(
                  crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12, crossAxisSpacing: 12,
                  children: options.map((opt) {
                    final isSelected = _selectedAnswer == opt;
                    final isRight = isSelected && _isCorrect == true;
                    final isWrong = isSelected && _isCorrect == false;

                    return BounceWidget(
                      onTap: _selectedAnswer == null ? () => _checkAnswer(opt) : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: isRight
                              ? LinearGradient(colors: [AppColors.success.withValues(alpha: 0.2), AppColors.success.withValues(alpha: 0.05)])
                              : isWrong
                                  ? LinearGradient(colors: [AppColors.error.withValues(alpha: 0.2), AppColors.error.withValues(alpha: 0.05)])
                                  : null,
                          color: isRight || isWrong ? null : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isRight ? AppColors.success : isWrong ? AppColors.error
                                : isSelected ? AppColors.thinkTab : Colors.grey.shade200,
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: [BoxShadow(color: isRight ? AppColors.success.withValues(alpha: 0.2)
                              : isWrong ? AppColors.error.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.08),
                              blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(opt, style: const TextStyle(fontSize: 52)),
                          if (isRight) ...[
                            const SizedBox(height: 4),
                            Text('✅ Correct!', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
                          ],
                          if (isWrong) ...[
                            const SizedBox(height: 4),
                            Text('❌ Try again', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.error)),
                          ],
                        ]),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            // Feedback bar
            if (_isCorrect != null) ...[
              const SizedBox(height: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isCorrect!
                        ? [AppColors.success.withValues(alpha: 0.15), AppColors.success.withValues(alpha: 0.05)]
                        : [AppColors.error.withValues(alpha: 0.15), AppColors.error.withValues(alpha: 0.05)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (_isCorrect! ? AppColors.success : AppColors.error).withValues(alpha: 0.3)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_isCorrect! ? '🎉' : '💪', style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(_isCorrect! ? 'Amazing! Keep going!' : 'Almost! Try again!',
                    style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700,
                      color: _isCorrect! ? AppColors.success : AppColors.error)),
                ]),
              ),
            ],
          ]),
        ),

        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [AppColors.primary, AppColors.secondary, AppColors.accent1, AppColors.accent2, AppColors.accent3],
            numberOfParticles: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildComplete() {
    return Stack(
      children: [
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🎉', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text('All games completed!', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(gradient: AppGradients.gold, borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star_rounded, color: Colors.white, size: 28),
              const SizedBox(width: 6),
              Text('Score: $_score', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
            ]),
          ),
          const SizedBox(height: 24),
          DuoButton(text: '🔄 Play Again', width: 180, color: AppColors.thinkTab, onPressed: () {
            setState(() { _currentGame = 0; _gameActive = true; _selectedAnswer = null; _isCorrect = null; _score = 0; });
            final tts = ref.read(ttsServiceProvider);
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) tts.speakEnglish(widget.word.thinkGames[0].instruction);
            });
          }),
        ])),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController..play(),
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [AppColors.primary, AppColors.secondary, AppColors.accent1, AppColors.accent2, AppColors.accent3],
            numberOfParticles: 30,
          ),
        ),
      ],
    );
  }
}
