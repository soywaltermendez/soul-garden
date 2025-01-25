import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subscription.dart';
import '../models/exercise.dart';
import '../providers/subscription_provider.dart';
import '../providers/exercises_provider.dart';
import '../widgets/premium_banner.dart';
import 'subscription_screen.dart';

class MindfulnessScreen extends ConsumerWidget {
  const MindfulnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    final exercises = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness'),
      ),
      body: Column(
        children: [
          if (!subscription.isPremium) 
            PremiumBanner(
              onUpgrade: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                );
              },
            ),
          Expanded(
            child: _ExerciseList(
              exercises: exercises,
              subscription: subscription,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseList extends StatelessWidget {
  final List<Exercise> exercises;
  final Subscription subscription;

  const _ExerciseList({
    required this.exercises,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          child: ListTile(
            title: Text(exercise.title),
            subtitle: Text(exercise.description),
            trailing: exercise.isPremium && subscription.tier == SubscriptionTier.free
                ? const Icon(Icons.lock)
                : const Icon(Icons.play_arrow),
            onTap: () {
              if (exercise.isPremium && subscription.tier == SubscriptionTier.free) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                );
              } else {
                // TODO: Navegar al ejercicio
              }
            },
          ),
        );
      },
    );
  }
} 