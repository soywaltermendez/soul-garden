import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';
import 'emotion_type.dart';
import 'emotion_check.dart';
import 'plant.dart';

part 'emotion_stats.g.dart';

@HiveType(typeId: HiveTypeIds.emotionStats)
class EmotionStats extends HiveObject {
  @HiveField(0)
  final int totalCheckins;
  
  @HiveField(1)
  final double averageIntensity;
  
  @HiveField(2)
  final EmotionType mostFrequent;
  
  @HiveField(3)
  final List<EmotionCheck> recentChecks;
  
  @HiveField(4)
  final int totalPlants;
  
  @HiveField(5)
  final int fullyGrownPlants;
  
  @HiveField(6)
  final Duration averageGrowthTime;

  @HiveField(7)
  final Map<EmotionType, int> emotionCounts;

  EmotionStats({
    required this.totalCheckins,
    required this.averageIntensity,
    required this.mostFrequent,
    required this.recentChecks,
    required this.totalPlants,
    required this.fullyGrownPlants,
    required this.averageGrowthTime,
    required this.emotionCounts,
  });

  static EmotionStats empty() {
    return EmotionStats(
      totalCheckins: 0,
      averageIntensity: 0,
      mostFrequent: EmotionType.calm,
      recentChecks: [],
      totalPlants: 0,
      fullyGrownPlants: 0,
      averageGrowthTime: Duration.zero,
      emotionCounts: {},
    );
  }

  EmotionStats copyWith({
    int? totalCheckins,
    double? averageIntensity,
    EmotionType? mostFrequent,
    List<EmotionCheck>? recentChecks,
    int? totalPlants,
    int? fullyGrownPlants,
    Duration? averageGrowthTime,
    Map<EmotionType, int>? emotionCounts,
  }) {
    return EmotionStats(
      totalCheckins: totalCheckins ?? this.totalCheckins,
      averageIntensity: averageIntensity ?? this.averageIntensity,
      mostFrequent: mostFrequent ?? this.mostFrequent,
      recentChecks: recentChecks ?? this.recentChecks,
      totalPlants: totalPlants ?? this.totalPlants,
      fullyGrownPlants: fullyGrownPlants ?? this.fullyGrownPlants,
      averageGrowthTime: averageGrowthTime ?? this.averageGrowthTime,
      emotionCounts: emotionCounts ?? this.emotionCounts,
    );
  }

  static EmotionStats calculate(List<EmotionCheck> checks, List<Plant> plants) {
    if (checks.isEmpty) {
      return EmotionStats(
        totalCheckins: 0,
        averageIntensity: 0,
        mostFrequent: EmotionType.calm,
        recentChecks: [],
        totalPlants: 0,
        fullyGrownPlants: 0,
        averageGrowthTime: Duration.zero,
        emotionCounts: {},
      );
    }

    // Contar emociones
    final counts = <EmotionType, int>{};
    var totalIntensity = 0.0;

    for (final check in checks) {
      counts[check.emotion] = (counts[check.emotion] ?? 0) + 1;
      totalIntensity += check.intensity;
    }

    // Encontrar la emoción más frecuente
    final mostFrequent = counts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Calcular estadísticas de plantas
    final fullyGrown = plants.where((p) => p.growthStage >= 1.0).length;

    final growthTimes = plants
        .where((p) => p.growthStage >= 1.0)
        .map((p) => p.lastWatered.difference(p.plantedAt))
        .toList();

    final avgGrowthTime = growthTimes.isEmpty
        ? Duration.zero
        : Duration(
            milliseconds: (growthTimes.fold(
                0, (sum, duration) => sum + duration.inMilliseconds) ~/ growthTimes.length));

    // Obtener checks recientes
    final recentChecks = checks
        .where((c) => c.timestamp.isAfter(
              DateTime.now().subtract(const Duration(days: 7)),
            ))
        .toList();

    return EmotionStats(
      totalCheckins: checks.length,
      averageIntensity: totalIntensity / checks.length,
      mostFrequent: mostFrequent,
      recentChecks: recentChecks,
      totalPlants: plants.length,
      fullyGrownPlants: fullyGrown,
      averageGrowthTime: avgGrowthTime,
      emotionCounts: counts,
    );
  }
} 