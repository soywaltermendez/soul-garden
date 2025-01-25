import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';

part 'exercise.g.dart';

@HiveType(typeId: HiveTypeIds.exerciseType)
enum ExerciseType {
  @HiveField(0)
  breathing,
  @HiveField(1)
  meditation,
  @HiveField(2)
  mindfulness,
}

@HiveType(typeId: HiveTypeIds.exercise)
class Exercise extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final ExerciseType type;
  
  @HiveField(4)
  final Duration duration;
  
  @HiveField(5)
  final List<String> steps;
  
  @HiveField(6)
  final bool isPremium;
  
  @HiveField(7)
  final int completionCount;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.duration,
    required this.steps,
    this.isPremium = false,
    this.completionCount = 0,
  });

  Exercise copyWith({
    String? id,
    String? title,
    String? description,
    ExerciseType? type,
    Duration? duration,
    List<String>? steps,
    bool? isPremium,
    int? completionCount,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      steps: steps ?? this.steps,
      isPremium: isPremium ?? this.isPremium,
      completionCount: completionCount ?? this.completionCount,
    );
  }
} 