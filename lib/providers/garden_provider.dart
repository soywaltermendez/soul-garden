import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/plant.dart';
import '../models/emotion_type.dart';
import '../config/constants.dart';

final gardenProvider = StateNotifierProvider<GardenNotifier, List<Plant>>((ref) {
  return GardenNotifier();
});

class GardenNotifier extends StateNotifier<List<Plant>> {
  final Box<Plant> _plantsBox = Hive.box(AppConstants.plantsBox);
  
  GardenNotifier() : super([]) {
    _loadPlants();
  }

  void _loadPlants() {
    state = _plantsBox.values.toList();
  }

  Future<void> addPlant(Plant plant) async {
    await _plantsBox.put(plant.id, plant);
    state = [...state, plant];
  }

  Future<void> waterPlant(String id) async {
    final index = state.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final plant = state[index];
    final updatedPlant = plant.copyWith(
      growthStage: (plant.growthStage + 0.2).clamp(0.0, 1.0),
      lastWatered: DateTime.now(),
    );

    await _plantsBox.put(id, updatedPlant);
    state = [
      ...state.sublist(0, index),
      updatedPlant,
      ...state.sublist(index + 1),
    ];
  }

  Future<void> removePlant(String id) async {
    await _plantsBox.delete(id);
    state = state.where((p) => p.id != id).toList();
  }

  String _generatePlantName(EmotionType emotion) {
    final prefix = switch (emotion) {
      EmotionType.joy => 'Flor Solar',
      EmotionType.gratitude => 'Rosa Dorada',
      EmotionType.calm => 'Lirio Lunar',
      EmotionType.anxiety => 'Orquídea Nocturna',
      EmotionType.sadness => 'Iris Azul',
    };
    return '$prefix ${state.length + 1}';
  }
} 