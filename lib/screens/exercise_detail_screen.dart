import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mindfulness_exercise.dart';
import '../widgets/exercise_timer.dart';
import '../providers/mindfulness_provider.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final MindfulnessExercise exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  ConsumerState<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _getExerciseIcon(widget.exercise.type),
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.exercise.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (!_isCompleted) ...[
              ExerciseTimer(
                duration: Duration(minutes: widget.exercise.durationMinutes),
                onComplete: _handleExerciseComplete,
              ),
            ] else ...[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                '¡Ejercicio Completado!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver al Jardín'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getExerciseIcon(ExerciseType type) {
    return switch (type) {
      ExerciseType.breathing => Icons.air,
      ExerciseType.meditation => Icons.self_improvement,
      ExerciseType.gratitude => Icons.favorite,
      ExerciseType.bodyScanning => Icons.accessibility_new,
      ExerciseType.visualization => Icons.remove_red_eye,
    };
  }

  Future<void> _handleExerciseComplete() async {
    await ref.read(mindfulnessProvider.notifier).completeExercise(widget.exercise.id);
    setState(() => _isCompleted = true);
  }
} 