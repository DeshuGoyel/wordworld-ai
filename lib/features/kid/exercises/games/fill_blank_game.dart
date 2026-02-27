import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/exercise_bank.dart';
import '../../../../core/widgets/tappable.dart';

class FillBlankGame extends StatelessWidget {
  final Exercise exercise;
  final Color color;
  final bool isAnswered;
  final String? selectedAnswer;
  final Function(String) onAnswer;
  final String topicEmoji;

  const FillBlankGame({
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
    
    // Split the question into parts
    final parts = exercise.question.split('___');
    
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
              const SizedBox(height: 20),
              
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 12,
                children: [
                  if (parts.isNotEmpty)
                    Text(parts[0].trim(), style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                    
                  // The Blank Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedAnswer == null 
                        ? Colors.grey.shade100 
                        : (isAnswered ? (isCorrect ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1)) : color.withValues(alpha: 0.1)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedAnswer == null 
                            ? Colors.grey.shade300 
                            : (isAnswered ? (isCorrect ? AppColors.success : AppColors.error) : color),
                        width: 2,
                        style: selectedAnswer == null ? BorderStyle.solid : BorderStyle.solid,
                      ),
                    ),
                    child: Text(
                      selectedAnswer ?? '          ',
                      style: GoogleFonts.nunito(
                        fontSize: 22, 
                        fontWeight: FontWeight.w900, 
                        color: selectedAnswer == null 
                          ? Colors.transparent 
                          : (isAnswered ? (isCorrect ? AppColors.success : AppColors.error) : color),
                      ),
                    ),
                  ),
                  
                  if (parts.length > 1)
                    Text(parts[1].trim(), style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                ]
              ),

              if (isAnswered && !isCorrect && exercise.hint.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '💡 ${exercise.hint}',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppColors.textMedium,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Available Words (Draggable/Tappable Bank)
        Expanded(
          child: Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: exercise.options.map((opt) {
                final isSelected = selectedAnswer == opt;
                
                return Tappable(
                  onTap: () => onAnswer(opt),
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey.shade200 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.grey.shade300 : color.withValues(alpha: 0.3), 
                        width: 2
                      ),
                      boxShadow: isSelected ? [] : [
                        BoxShadow(
                          color: color.withValues(alpha: 0.15),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Text(
                      opt,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.grey.shade400 : AppColors.textDark,
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
