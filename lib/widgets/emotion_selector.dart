import 'package:flutter/material.dart';
import '../models/emotion_type.dart';

class EmotionSelector extends StatelessWidget {
  final EmotionType? selectedEmotion;
  final ValueChanged<EmotionType> onEmotionSelected;

  const EmotionSelector({
    super.key,
    this.selectedEmotion,
    required this.onEmotionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: EmotionType.values.map((emotion) {
        final isSelected = emotion == selectedEmotion;
        
        return InkWell(
          onTap: () => onEmotionSelected(emotion),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getEmotionIcon(emotion),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 4),
                Text(
                  _getEmotionLabel(emotion),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getEmotionIcon(EmotionType emotion) {
    return switch (emotion) {
      EmotionType.joy => Icons.sentiment_very_satisfied,
      EmotionType.gratitude => Icons.favorite,
      EmotionType.calm => Icons.spa,
      EmotionType.anxiety => Icons.sentiment_dissatisfied,
      EmotionType.sadness => Icons.sentiment_very_dissatisfied,
    };
  }

  String _getEmotionLabel(EmotionType emotion) {
    return switch (emotion) {
      EmotionType.joy => 'Alegría',
      EmotionType.gratitude => 'Gratitud',
      EmotionType.calm => 'Calma',
      EmotionType.anxiety => 'Ansiedad',
      EmotionType.sadness => 'Tristeza',
    };
  }
} 