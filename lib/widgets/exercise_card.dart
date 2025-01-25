import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mindfulness_exercise.dart';
import '../screens/exercise_detail_screen.dart';

class ExerciseCard extends ConsumerWidget {
  final MindfulnessExercise exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: Icon(_getExerciseIcon(exercise.type)),
        title: Row(
          children: [
            Expanded(child: Text(exercise.title)),
            if (exercise.isPremium)
              const Icon(Icons.star, color: Colors.amber),
          ],
        ),
        subtitle: Text(
          '${exercise.durationMinutes} minutos',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          if (exercise.isPremium && !ref.read(premiumProvider)) {
            _showPremiumDialog(context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExerciseDetailScreen(exercise: exercise),
              ),
            );
          }
        },
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

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contenido Premium'),
        content: const Text(
          'Este ejercicio está disponible solo para usuarios premium.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navegar a la pantalla de suscripción
            },
            child: const Text('Obtener Premium'),
          ),
        ],
      ),
    );
  }
} 