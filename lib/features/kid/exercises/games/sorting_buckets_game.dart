import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/exercise_bank.dart';

class SortingBucketsGame extends StatelessWidget {
  final Exercise exercise;
  final Color color;
  final bool isAnswered;
  final String? selectedAnswer;
  final Function(String) onAnswer;
  final String topicEmoji;

  const SortingBucketsGame({
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
        // The Object to sort
        if (selectedAnswer == null)
          Draggable<String>(
            data: exercise.question,
            feedback: Material(
              color: Colors.transparent,
              child: _buildItemCard(exercise.question, color, true),
            ),
            childWhenDragging: _buildItemCard(exercise.question, Colors.grey.shade300, false),
            child: _buildItemCard(exercise.question, AppColors.textDark, false),
          )
        else
          _buildItemCard(exercise.question, isAnswered ? (isCorrect ? AppColors.success : AppColors.error) : AppColors.textDark, false),
        
        const SizedBox(height: 12),
        Text('Drag to the correct bucket!', style: GoogleFonts.nunito(fontSize: 16, color: AppColors.textMedium, fontWeight: FontWeight.w700)),
        const SizedBox(height: 48),

        // The Buckets (Options)
        Expanded(
          child: GridView.count(
            crossAxisCount: exercise.options.length > 2 ? 2 : exercise.options.length,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            physics: const NeverScrollableScrollPhysics(),
            children: exercise.options.map((opt) {
              final isSelectedBucket = selectedAnswer == opt;
              
              return DragTarget<String>(
                onAcceptWithDetails: (details) {
                  HapticFeedback.lightImpact();
                  onAnswer(opt);
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovering = candidateData.isNotEmpty;
                  Color bucketColor = color;
                  if (isSelectedBucket && isAnswered) {
                    bucketColor = isCorrect ? AppColors.success : AppColors.error;
                  }

                  return AnimatedContainer(
                    duration: AppDurations.fast,
                    decoration: BoxDecoration(
                      color: isHovering ? bucketColor.withValues(alpha: 0.2) : (isSelectedBucket ? bucketColor.withValues(alpha: 0.1) : Colors.white),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: isHovering || isSelectedBucket ? bucketColor : AppColors.textLight.withValues(alpha: 0.3),
                        width: isHovering || isSelectedBucket ? 4 : 2,
                      ),
                      boxShadow: isHovering ? [BoxShadow(color: bucketColor.withValues(alpha: 0.3), blurRadius: 12)] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelectedBucket ? Icons.inventory_rounded : (isHovering ? Icons.inventory_2_rounded : Icons.inventory_2_outlined),
                          size: 40,
                          color: isHovering || isSelectedBucket ? bucketColor : AppColors.textMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          opt,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isHovering || isSelectedBucket ? bucketColor : AppColors.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(String text, Color textColor, bool isDragging) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.5), width: 2),
        boxShadow: isDragging 
            ? [BoxShadow(color: textColor.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 10))]
            : AppShadows.card,
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
