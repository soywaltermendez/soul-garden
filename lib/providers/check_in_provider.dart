import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/emotion_check.dart';
import '../models/plant.dart';
import '../config/constants.dart';
import 'garden_provider.dart';
import 'achievements_provider.dart';

final checkInProvider = StateNotifierProvider<CheckInNotifier, List<EmotionCheck>>((ref) {
  return CheckInNotifier(ref);
});

class CheckInNotifier extends StateNotifier<List<EmotionCheck>> {
  final Box<EmotionCheck> _checkInsBox = Hive.box(AppConstants.emotionChecksBox);
  final Ref ref;
  
  CheckInNotifier(this.ref) : super([]) {
    _loadCheckIns();
  }

  void _loadCheckIns() {
    state = _checkInsBox.values.toList();
  }

  Future<void> addCheckIn(EmotionCheck check) async {
    await _checkInsBox.add(check);
    state = [...state, check];

    // Crear una nueva planta
    final plant = Plant(
      id: const Uuid().v4(),
      name: 'Semilla de ${check.emotion.name}',
      emotionType: check.emotion,
      growthStage: 0.0,
    );
    
    // Añadir la planta al jardín
    ref.read(gardenProvider.notifier).addPlant(plant);

    // Actualizar logros
    ref.read(achievementsProvider.notifier).checkAchievements(
      state,
      ref.read(gardenProvider),
    );
  }

  bool hasCheckedInToday() {
    final now = DateTime.now();
    return state.any((check) => 
      check.timestamp.year == now.year && 
      check.timestamp.month == now.month &&
      check.timestamp.day == now.day
    );
  }
} 