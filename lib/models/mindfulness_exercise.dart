import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';

part 'mindfulness_exercise.g.dart';

@HiveType(typeId: HiveTypeIds.mindfulnessExerciseType)
enum ExerciseType {
  @HiveField(0)
  breathing,
  @HiveField(1)
  meditation,
  @HiveField(2)
  gratitude,
  @HiveField(3)
  bodyScanning,
  @HiveField(4)
  visualization,
}

@HiveType(typeId: HiveTypeIds.mindfulnessExercise)
class MindfulnessExercise extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final ExerciseType type;
  
  @HiveField(4)
  final int durationMinutes;
  
  @HiveField(5)
  final bool isPremium;

  MindfulnessExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationMinutes,
    this.isPremium = false,
  });
} 