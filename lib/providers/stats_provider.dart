import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/emotion_stats.dart';
import '../models/emotion_type.dart';
import 'check_in_provider.dart';
import 'garden_provider.dart';

final statsProvider = Provider<EmotionStats>((ref) {
  final checkIns = ref.watch(checkInProvider);
  final plants = ref.watch(gardenProvider);
  return EmotionStats.calculate(checkIns, plants);
}); 