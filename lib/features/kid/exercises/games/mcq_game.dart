import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/exercise_bank.dart';
import '../../../../core/widgets/tappable.dart';

class McqGame extends StatelessWidget {
  final Exercise exercise;
  final Color color;
  final bool isAnswered;
  final String? selectedAnswer;
  final Function(String) onAnswer;
  final String topicEmoji;

  const McqGame({
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
        // Question card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              Text(topicEmoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(
                exercise.question,
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              if (isAnswered && !isCorrect && exercise.hint.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '💡 ${exercise.hint}',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppColors.textMedium,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Options
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: exercise.options.map((opt) {
                final isSelected = selectedAnswer == opt;
                final isCorrectOpt = opt == exercise.correctAnswer;
                
                Color bgColor = Colors.white;
                Color borderColor = AppColors.textLight.withValues(alpha: 0.2);
                
                if (isAnswered) {
                  if (isCorrectOpt) {
                    bgColor = AppColors.success.withValues(alpha: 0.1);
                    borderColor = AppColors.success;
                  } else if (isSelected) {
                    bgColor = AppColors.error.withValues(alpha: 0.1);
                    borderColor = AppColors.error;
                  }
                } else if (isSelected) {
                  borderColor = color;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Tappable(
                    onTap: () => onAnswer(opt),
                    child: AnimatedContainer(
                      duration: AppDurations.fast,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opt,
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          if (isAnswered && isCorrectOpt)
                            const Icon(Icons.check_circle, color: AppColors.success),
                          if (isAnswered && isSelected && !isCorrectOpt)
                            const Icon(Icons.cancel, color: AppColors.error),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
