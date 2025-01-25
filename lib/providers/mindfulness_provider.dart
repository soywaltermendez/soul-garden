import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/mindfulness_exercise.dart';

final mindfulnessProvider = StateNotifierProvider<MindfulnessNotifier, List<MindfulnessExercise>>((ref) {
  return MindfulnessNotifier();
});

class MindfulnessNotifier extends StateNotifier<List<MindfulnessExercise>> {
  MindfulnessNotifier() : super(_defaultExercises);

  static final _defaultExercises = [
    MindfulnessExercise(
      id: const Uuid().v4(),
      title: 'Respiración Consciente',
      description: 'Inhala por 4 segundos, mantén por 4, exhala por 4.',
      type: ExerciseType.breathing,
      durationMinutes: 5,
    ),
    MindfulnessExercise(
      id: const Uuid().v4(),
      title: 'Meditación Básica',
      description: 'Siéntate cómodamente y enfócate en tu respiración.',
      type: ExerciseType.meditation,
      durationMinutes: 10,
    ),
    MindfulnessExercise(
      id: const Uuid().v4(),
      title: 'Diario de Gratitud',
      description: 'Escribe tres cosas por las que estés agradecido hoy.',
      type: ExerciseType.gratitude,
      durationMinutes: 5,
    ),
    // Ejercicios premium
    MindfulnessExercise(
      id: const Uuid().v4(),
      title: 'Escaneo Corporal Guiado',
      description: 'Recorre tu cuerpo mentalmente, relajando cada parte.',
      type: ExerciseType.bodyScanning,
      durationMinutes: 15,
      isPremium: true,
    ),
  ];

  Future<void> completeExercise(String exerciseId) async {
    // Recompensar al usuario regando todas sus plantas
    ref.read(gardenProvider.notifier).waterAllPlants();
    
    // Mostrar notificación de logro
    ref.read(notificationsProvider.notifier).showExerciseCompleted();
  }
} 