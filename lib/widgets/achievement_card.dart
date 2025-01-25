import 'package:flutter/material.dart';
import '../models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool showProgress;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getAchievementIcon(),
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        achievement.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showProgress && achievement.targetProgress > 1) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: achievement.progress / achievement.targetProgress,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                '${achievement.progress}/${achievement.targetProgress}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getAchievementIcon() {
    return switch (achievement.type) {
      AchievementType.firstCheckIn => Icons.emoji_events,
      AchievementType.weeklyStreak => Icons.calendar_today,
      AchievementType.plantMaster => Icons.local_florist,
      AchievementType.emotionDiversity => Icons.psychology,
      AchievementType.gardenGrowth => Icons.park,
    };
  }
} 