import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soul-garden/providers/exercises_provider.dart';
import 'package:soul-garden/models/exercise.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  group('ExercisesProvider', () {
    late ProviderContainer container;
    late Box<Exercise> mockBox;

    setUp(() {
      mockBox = MockBox<Exercise>();
      when(() => mockBox.values).thenReturn([]);
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should start with default exercises when box is empty', () {
      final exercises = container.read(exercisesProvider);
      
      expect(exercises.length, greaterThan(0));
      expect(
        exercises.any((e) => e.type == ExerciseType.breathing),
        true,
      );
    });

    test('should mark exercise as completed', () async {
      final notifier = container.read(exercisesProvider.notifier);
      final exercise = notifier.state.first;
      
      await notifier.completeExercise(exercise.id);
      
      final updated = notifier.state
          .firstWhere((e) => e.id == exercise.id);
      expect(updated.completionCount, 1);
    });
  });
} 