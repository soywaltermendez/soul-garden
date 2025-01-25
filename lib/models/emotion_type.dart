import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';
part 'emotion_type.g.dart';

@HiveType(typeId: HiveTypeIds.emotionType)
enum EmotionType {
  @HiveField(0)
  joy,
  @HiveField(1)
  gratitude,
  @HiveField(2)
  calm,
  @HiveField(3)
  anxiety,
  @HiveField(4)
  sadness,
} 