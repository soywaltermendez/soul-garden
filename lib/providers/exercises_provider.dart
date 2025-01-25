import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/exercise.dart';

final exercisesProvider = StateNotifierProvider<ExercisesNotifier, List<Exercise>>((ref) {
  return ExercisesNotifier();
});

class ExercisesNotifier extends StateNotifier<List<Exercise>> {
  final Box<Exercise> _exercisesBox = Hive.box('exercises');
  
  ExercisesNotifier() : super([]) {
    _loadExercises();
  }

  void _loadExercises() {
    final exercises = _exercisesBox.values.toList();
    if (exercises.isEmpty) {
      state = _getDefaultExercises();
    } else {
      state = exercises;
    }
  }

  List<Exercise> _getDefaultExercises() {
    return [
      Exercise(
        id: const Uuid().v4(),
        title: 'Respiración consciente',
        description: 'Un ejercicio simple de respiración',
        type: ExerciseType.breathing,
        duration: const Duration(minutes: 5),
        steps: [
          'Siéntate cómodamente',
          'Inhala profundamente por 4 segundos',
          'Mantén la respiración por 4 segundos',
          'Exhala lentamente por 4 segundos',
          'Repite el ciclo',
        ],
      ),
      Exercise(
        id: const Uuid().v4(),
        title: 'Meditación guiada',
        description: 'Meditación para principiantes',
        type: ExerciseType.meditation,
        duration: const Duration(minutes: 10),
        steps: [
          'Encuentra un lugar tranquilo',
          'Cierra los ojos',
          'Enfócate en tu respiración',
          'Observa tus pensamientos sin juzgar',
        ],
        isPremium: true,
      ),
    ];
  }

  Future<void> completeExercise(String id) async {
    final updatedExercises = [
      for (final exercise in state)
        if (exercise.id == id)
          exercise.copyWith(completionCount: exercise.completionCount + 1)
        else
          exercise,
    ];

    final updatedExercise = updatedExercises.firstWhere((e) => e.id == id);
    await _exercisesBox.put(id, updatedExercise);
    state = updatedExercises;
  }
} 