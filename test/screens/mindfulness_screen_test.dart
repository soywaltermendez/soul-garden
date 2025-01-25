import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soul-garden/screens/mindfulness_screen.dart';
import 'package:soul-garden/providers/exercises_provider.dart';
import 'package:soul-garden/providers/subscription_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockExercisesNotifier extends StateNotifier<List<Exercise>>
    with Mock
    implements ExercisesNotifier {
  MockExercisesNotifier() : super([]);
}

void main() {
  group('MindfulnessScreen', () {
    late MockExercisesNotifier mockExercisesNotifier;

    setUp(() {
      mockExercisesNotifier = MockExercisesNotifier();
      when(() => mockExercisesNotifier.state).thenReturn([
        Exercise(
          id: '1',
          title: 'Test Exercise',
          description: 'Description',
          type: ExerciseType.breathing,
          duration: const Duration(minutes: 5),
          steps: ['Step 1'],
        ),
      ]);
    });

    testWidgets('should display exercise tabs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exercisesProvider.notifier
                .overrideWith(() => mockExercisesNotifier),
          ],
          child: const MaterialApp(
            home: MindfulnessScreen(),
          ),
        ),
      );

      expect(find.text('Respiración'), findsOneWidget);
      expect(find.text('Meditación'), findsOneWidget);
    });

    testWidgets('should show premium dialog for locked exercises',
        (tester) async {
      final exercise = Exercise(
        id: '2',
        title: 'Premium Exercise',
        description: 'Premium',
        type: ExerciseType.meditation,
        duration: const Duration(minutes: 10),
        steps: ['Step 1'],
        isPremium: true,
      );

      when(() => mockExercisesNotifier.state).thenReturn([exercise]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exercisesProvider.notifier
                .overrideWith(() => mockExercisesNotifier),
            subscriptionProvider
                .overrideWith((ref) => Subscription(tier: SubscriptionTier.free)),
          ],
          child: const MaterialApp(
            home: MindfulnessScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Premium Exercise'));
      await tester.pumpAndSettle();

      expect(find.text('Ejercicio Premium'), findsOneWidget);
      expect(find.text('Ver planes'), findsOneWidget);
    });
  });
} 