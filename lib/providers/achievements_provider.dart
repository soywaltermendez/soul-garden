import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/achievement.dart';
import '../models/emotion_type.dart';
import '../models/emotion_check.dart';
import '../models/plant.dart';
import '../models/reward.dart';
import '../config/constants.dart';
import 'check_in_provider.dart';
import 'garden_provider.dart';
import 'notifications_provider.dart';

final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier(ref);
});

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  final Box<Achievement> _achievementsBox = Hive.box(AppConstants.achievementsBox);
  final Ref ref;
  
  AchievementsNotifier(this.ref) : super([]) {
    _loadAchievements();
  }

  void _loadAchievements() {
    state = _achievementsBox.values.toList();
  }

  Future<void> checkAchievements(List<EmotionCheck> checks, List<Plant> plants) async {
    // Primer check-in
    if (checks.length == 1) {
      await _unlockAchievement(
        AchievementType.firstCheckIn,
        progress: 1,
        targetProgress: 1,
      );
    }

    // Racha semanal
    final lastSevenDays = DateTime.now().subtract(const Duration(days: 7));
    final dailyChecks = checks.where((c) => c.timestamp.isAfter(lastSevenDays));
    if (dailyChecks.length >= 7) {
      await _unlockAchievement(
        AchievementType.weeklyStreak,
        progress: 7,
        targetProgress: 7,
      );
    }

    // Diversidad emocional
    final uniqueEmotions = checks.map((c) => c.emotion).toSet().length;
    if (uniqueEmotions >= EmotionType.values.length) {
      await _unlockAchievement(
        AchievementType.emotionDiversity,
        progress: uniqueEmotions,
        targetProgress: EmotionType.values.length,
      );
    }

    // Plantas maduras
    final maturedPlants = plants.where((p) => p.growthStage >= 1.0).length;
    if (maturedPlants >= 5) {
      await _unlockAchievement(
        AchievementType.plantMaster,
        progress: maturedPlants,
        targetProgress: 5,
      );
    }

    // Tamaño del jardín
    if (plants.length >= 10) {
      await _unlockAchievement(
        AchievementType.gardenGrowth,
        progress: plants.length,
        targetProgress: 10,
      );
    }
  }

  Future<void> _unlockAchievement(
    AchievementType type, {
    required int progress,
    required int targetProgress,
  }) async {
    if (state.any((a) => a.type == type)) return;

    final achievement = Achievement(
      id: type.name,
      type: type,
      title: _getAchievementTitle(type),
      description: _getAchievementDescription(type),
      unlockedAt: DateTime.now(),
      progress: progress,
      targetProgress: targetProgress,
    );

    await _achievementsBox.put(achievement.id, achievement);
    state = [...state, achievement];

    // Notificar al usuario
    await ref.read(notificationsProvider.notifier).showAchievementUnlocked(achievement);
  }

  String _getAchievementTitle(AchievementType type) {
    return switch (type) {
      AchievementType.firstCheckIn => 'Primer Paso',
      AchievementType.weeklyStreak => 'Constancia',
      AchievementType.plantMaster => 'Jardinero Experto',
      AchievementType.emotionDiversity => 'Explorador Emocional',
      AchievementType.gardenGrowth => 'Jardín Floreciente',
    };
  }

  String _getAchievementDescription(AchievementType type) {
    return switch (type) {
      AchievementType.firstCheckIn => 'Realizaste tu primer check-in emocional',
      AchievementType.weeklyStreak => 'Completaste 7 días seguidos de check-ins',
      AchievementType.plantMaster => 'Cultivaste 5 plantas hasta su máximo crecimiento',
      AchievementType.emotionDiversity => 'Experimentaste todo el espectro de emociones',
      AchievementType.gardenGrowth => 'Cultivaste un jardín con 10 plantas',
    };
  }
} 