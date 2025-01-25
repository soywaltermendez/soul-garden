import 'package:flutter/material.dart';
import '../models/achievement.dart';

class AchievementNotification extends StatelessWidget {
  final Achievement achievement;

  const AchievementNotification({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(Icons.emoji_events, color: Colors.amber),
        title: Text(
          '¡Logro Desbloqueado!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.title),
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (achievement.targetProgress > 1)
              LinearProgressIndicator(
                value: achievement.progress / achievement.targetProgress,
              ),
          ],
        ),
      ),
    );
  }
} 