import 'package:flutter_test/flutter_test.dart';
import 'package:soul-garden/models/exercise.dart';

void main() {
  group('Exercise', () {
    test('should create an Exercise instance with required parameters', () {
      final exercise = Exercise(
        id: '1',
        title: 'Respiración consciente',
        description: 'Un ejercicio simple de respiración',
        type: ExerciseType.breathing,
        duration: const Duration(minutes: 5),
        steps: ['Inhala', 'Exhala'],
      );

      expect(exercise.id, '1');
      expect(exercise.title, 'Respiración consciente');
      expect(exercise.description, 'Un ejercicio simple de respiración');
      expect(exercise.type, ExerciseType.breathing);
      expect(exercise.duration, const Duration(minutes: 5));
      expect(exercise.isPremium, false);
      expect(exercise.steps, ['Inhala', 'Exhala']);
      expect(exercise.completionCount, 0);
    });

    test('copyWith should create a new instance with updated values', () {
      final exercise = Exercise(
        id: '1',
        title: 'Original',
        description: 'Description',
        type: ExerciseType.breathing,
        duration: const Duration(minutes: 5),
        steps: ['Step 1'],
      );

      final updated = exercise.copyWith(
        title: 'Updated',
        completionCount: 1,
      );

      expect(updated.id, exercise.id);
      expect(updated.title, 'Updated');
      expect(updated.description, exercise.description);
      expect(updated.completionCount, 1);
    });
  });
} 