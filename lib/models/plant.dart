import 'package:hive/hive.dart';
import 'emotion_type.dart';
import '../config/hive_type_ids.dart';
part 'plant.g.dart';

@HiveType(typeId: HiveTypeIds.plant)
class Plant extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final EmotionType emotionType;
  
  @HiveField(3)
  final double growthStage; // 0.0 to 1.0
  
  @HiveField(4)
  final DateTime plantedAt;
  
  @HiveField(5)
  final DateTime lastWatered;

  Plant({
    required this.id,
    required this.name,
    required this.emotionType,
    this.growthStage = 0.0,
    DateTime? plantedAt,
    DateTime? lastWatered,
  }) : this.plantedAt = plantedAt ?? DateTime.now(),
       this.lastWatered = lastWatered ?? DateTime.now();

  Plant copyWith({
    String? id,
    String? name,
    EmotionType? emotionType,
    double? growthStage,
    DateTime? plantedAt,
    DateTime? lastWatered,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      emotionType: emotionType ?? this.emotionType,
      growthStage: growthStage ?? this.growthStage,
      plantedAt: plantedAt ?? this.plantedAt,
      lastWatered: lastWatered ?? this.lastWatered,
    );
  }
} 