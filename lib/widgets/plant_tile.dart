import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../models/emotion_type.dart';

class PlantTile extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;

  const PlantTile({
    super.key,
    required this.plant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getPlantIcon(),
                size: 28,
                color: _getPlantColor(context),
              ),
              const SizedBox(height: 2),
              Text(
                plant.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              LinearProgressIndicator(
                value: plant.growthStage,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                color: _getPlantColor(context),
                minHeight: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPlantIcon() {
    if (plant.growthStage < 0.3) {
      return Icons.grass;
    } else if (plant.growthStage < 0.7) {
      return Icons.local_florist;
    } else {
      return Icons.park;
    }
  }

  Color _getPlantColor(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return switch (plant.emotionType) {
      EmotionType.joy => colors.primary,
      EmotionType.gratitude => colors.tertiary,
      EmotionType.calm => colors.secondary,
      EmotionType.anxiety => colors.error,
      EmotionType.sadness => colors.surfaceTint,
    };
  }
} 