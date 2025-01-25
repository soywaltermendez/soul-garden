import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';
part 'achievement.g.dart';

@HiveType(typeId: HiveTypeIds.achievementType)
enum AchievementType {
  @HiveField(0)
  firstCheckIn,
  @HiveField(1)
  weeklyStreak,
  @HiveField(2)
  plantMaster,
  @HiveField(3)
  emotionDiversity,
  @HiveField(4)
  gardenGrowth,
}

@HiveType(typeId: HiveTypeIds.achievement)
class Achievement extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final AchievementType type;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final int progress;
  
  @HiveField(5)
  final int targetProgress;
  
  @HiveField(6)
  final bool isUnlocked;
  
  @HiveField(7)
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.targetProgress,
    this.progress = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    AchievementType? type,
    String? title,
    String? description,
    int? progress,
    int? targetProgress,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      targetProgress: targetProgress ?? this.targetProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
} 