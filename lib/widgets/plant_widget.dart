import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../models/emotion_type.dart';

class PlantWidget extends StatelessWidget {
  final Plant plant;
  final VoidCallback? onTap;
  final bool showDetails;

  const PlantWidget({
    super.key,
    required this.plant,
    this.onTap,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: plant.growthStage,
                    backgroundColor: Colors.grey.shade200,
                    color: _getEmotionColor(plant.emotionType),
                  ),
                  Icon(
                    _getEmotionIcon(plant.emotionType),
                    size: 32,
                    color: _getEmotionColor(plant.emotionType),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                plant.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (showDetails) ...[
                const SizedBox(height: 8),
                Text(
                  'Plantada: ${_formatDate(plant.plantedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Último riego: ${_formatDate(plant.lastWatered)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getEmotionIcon(EmotionType emotion) {
    return switch (plant.emotionType) {
      EmotionType.joy => Icons.local_florist,
      EmotionType.gratitude => Icons.favorite,
      EmotionType.calm => Icons.spa,
      EmotionType.anxiety => Icons.psychology,
      EmotionType.sadness => Icons.water,
    };
  }

  Color _getEmotionColor(EmotionType emotion) {
    return switch (plant.emotionType) {
      EmotionType.joy => Colors.yellow,
      EmotionType.gratitude => Colors.pink,
      EmotionType.calm => Colors.purple,
      EmotionType.anxiety => Colors.orange,
      EmotionType.sadness => Colors.blue,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 