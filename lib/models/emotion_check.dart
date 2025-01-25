import 'package:hive/hive.dart';
import 'emotion_type.dart';
import '../config/hive_type_ids.dart';
part 'emotion_check.g.dart';

@HiveType(typeId: HiveTypeIds.emotionCheck)
class EmotionCheck extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final EmotionType emotion;
  
  @HiveField(2)
  final int intensity;
  
  @HiveField(3)
  final String? note;
  
  @HiveField(4)
  final DateTime timestamp;

  EmotionCheck({
    required this.id,
    required this.emotion,
    required this.intensity,
    this.note,
    DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();
} 