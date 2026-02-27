import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/exercise_bank.dart';

class DragMatchGame extends StatelessWidget {
  final Exercise exercise;
  final Color color;
  final bool isAnswered;
  final String? selectedAnswer;
  final Function(String) onAnswer;
  final String topicEmoji;

  const DragMatchGame({
    super.key,
    required this.exercise,
    required this.color,
    required this.isAnswered,
    this.selectedAnswer,
    required this.onAnswer,
    required this.topicEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = selectedAnswer == exercise.correctAnswer;

    return Column(
      children: [
        // Question Area
        Text(topicEmoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 12),
        Text(
          exercise.question,
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Target Drop Zone
        DragTarget<String>(
          onAcceptWithDetails: (details) {
            HapticFeedback.lightImpact();
            onAnswer(details.data);
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            
            return AnimatedContainer(
              duration: AppDurations.fast,
              width: 200,
              height: 140,
              decoration: BoxDecoration(
                color: selectedAnswer == null 
                  ? (isHovering ? color.withValues(alpha: 0.2) : Colors.white)
                  : (isAnswered ? (isCorrect ? AppColors.success.withValues(alpha: 0.2) : AppColors.error.withValues(alpha: 0.2)) : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selectedAnswer == null
                    ? (isHovering ? color : AppColors.textLight.withValues(alpha: 0.3))
                    : (isAnswered ? (isCorrect ? AppColors.success : AppColors.error) : color),
                  width: isHovering || selectedAnswer != null ? 4 : 2,
                  style: BorderStyle.solid,
                ),
                boxShadow: isHovering ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12)] : AppShadows.card,
              ),
              child: Center(
                child: selectedAnswer != null
                  ? Text(
                      selectedAnswer!,
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isAnswered ? (isCorrect ? AppColors.success : AppColors.error) : color,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.move_to_inbox_rounded, 
                            size: 40, 
                            color: AppColors.textLight.withValues(alpha: 0.5)),
                        const SizedBox(height: 8),
                        Text(
                          'Drop here',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textLight.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
              ),
            );
          },
        ),
        const SizedBox(height: 48),

        // Draggable Options
        if (selectedAnswer == null)
          Expanded(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: exercise.options.map((opt) {
                return Draggable<String>(
                  data: opt,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 8))],
                      ),
                      child: Text(
                        opt,
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Text(
                      opt,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
                      boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 8)],
                    ),
                    child: Text(
                      opt,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        else
          // Empty space to prevent layout jump and show hint if wrong
          Expanded(
            child: isAnswered && !isCorrect && exercise.hint.isNotEmpty
              ? Text(
                  '💡 ${exercise.hint}',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: AppColors.textMedium,
                    fontStyle: FontStyle.italic,
                  ),
                )
              : const SizedBox(),
          ),
      ],
    );
  }
}
