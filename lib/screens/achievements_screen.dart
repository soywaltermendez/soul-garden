import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement.dart';
import '../providers/achievements_provider.dart';
import '../models/reward.dart';
import '../providers/rewards_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    final rewards = ref.watch(rewardsProvider);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Logros'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Logros'),
              Tab(text: 'Recompensas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAchievementsTab(achievements),
            _buildRewardsTab(rewards),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview(List<Achievement> achievements) {
    final totalAchievements = AchievementType.values.length;
    final unlockedAchievements = achievements.length;
    final progress = unlockedAchievements / totalAchievements;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '$unlockedAchievements/$totalAchievements',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toInt()}% completado',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsTab(List<Achievement> achievements) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProgressOverview(achievements),
        const SizedBox(height: 24),
        _buildAchievementsList(achievements),
      ],
    );
  }

  Widget _buildAchievementsList(List<Achievement> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Logros Desbloqueados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...achievements.map((achievement) => _AchievementTile(
          achievement: achievement,
          isLocked: false,
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Por Desbloquear',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...AchievementType.values
            .where((type) => !achievements.any((a) => a.type == type))
            .map((type) => _AchievementTile(
              achievement: Achievement(
                id: '',
                type: type,
                title: _getLockedAchievementTitle(type),
                description: _getLockedAchievementDescription(type),
                unlockedAt: DateTime.now(),
                progress: 0,
                targetProgress: _getTargetProgress(type),
              ),
              isLocked: true,
            )),
      ],
    );
  }

  Widget _buildRewardsTab(List<Reward> rewards) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...rewards.map((reward) => Card(
          child: ListTile(
            leading: Image.asset(
              reward.assetPath,
              width: 48,
              height: 48,
              errorBuilder: (_, __, ___) => Icon(
                _getRewardIcon(reward.type),
                size: 32,
                color: reward.isUnlocked ? Colors.amber : Colors.grey,
              ),
            ),
            title: Text(
              reward.title,
              style: TextStyle(
                color: reward.isUnlocked ? null : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              reward.description,
              style: TextStyle(
                color: reward.isUnlocked ? null : Colors.grey,
              ),
            ),
            trailing: reward.isUnlocked
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.lock, color: Colors.grey),
          ),
        )),
      ],
    );
  }

  String _getLockedAchievementTitle(AchievementType type) {
    return switch (type) {
      AchievementType.firstCheckIn => 'Primer Paso',
      AchievementType.weeklyStreak => 'Constancia',
      AchievementType.plantMaster => 'Jardinero Experto',
      AchievementType.emotionDiversity => 'Explorador Emocional',
      AchievementType.gardenGrowth => 'Jardín Floreciente',
    };
  }

  String _getLockedAchievementDescription(AchievementType type) {
    return switch (type) {
      AchievementType.firstCheckIn => 'Realiza tu primer check-in emocional',
      AchievementType.weeklyStreak => 'Completa 7 días seguidos de check-ins',
      AchievementType.plantMaster => 'Cultiva 5 plantas hasta su máximo crecimiento',
      AchievementType.emotionDiversity => 'Experimenta todo el espectro de emociones',
      AchievementType.gardenGrowth => 'Cultiva un jardín con 10 plantas',
    };
  }

  int _getTargetProgress(AchievementType type) {
    return switch (type) {
      AchievementType.firstCheckIn => 1,
      AchievementType.weeklyStreak => 7,
      AchievementType.plantMaster => 5,
      AchievementType.emotionDiversity => 5,
      AchievementType.gardenGrowth => 10,
    };
  }

  IconData _getRewardIcon(RewardType type) {
    return switch (type) {
      RewardType.plant => Icons.park,
      RewardType.background => Icons.landscape,
      RewardType.theme => Icons.palette,
    };
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;
  final bool isLocked;

  const _AchievementTile({
    required this.achievement,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isLocked ? Colors.grey[100] : null,
      child: ListTile(
        leading: Icon(
          isLocked ? Icons.lock : Icons.emoji_events,
          color: isLocked ? Colors.grey : Colors.amber,
        ),
        title: Text(
          achievement.title,
          style: TextStyle(
            color: isLocked ? Colors.grey : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
              style: TextStyle(
                color: isLocked ? Colors.grey : null,
              ),
            ),
            if (achievement.targetProgress > 1)
              LinearProgressIndicator(
                value: achievement.progress / achievement.targetProgress,
              ),
          ],
        ),
        trailing: isLocked ? null : Text(
          achievement.unlockedAt.toString().split(' ')[0],
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
} 