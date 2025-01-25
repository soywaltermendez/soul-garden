import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/check_in_provider.dart';
import '../providers/garden_provider.dart';
import '../screens/check_in_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/plant_widget.dart';
import '../widgets/garden_background.dart';
import '../widgets/garden_effects.dart';

class GardenScreen extends ConsumerWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCheckedIn = ref.watch(checkInProvider.notifier).hasCheckedInToday();
    final plants = ref.watch(gardenProvider);
    
    return GardenBackground(
      child: Stack(
        children: [
          const GardenEffects(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Mi Jardín'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.water_drop),
                  onPressed: plants.isEmpty ? null : () {
                    _showWaterAllDialog(context, ref);
                  },
                ),
              ],
            ),
            body: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: plants.length,
              itemBuilder: (context, index) {
                return PlantWidget(plant: plants[index]);
              },
            ),
            floatingActionButton: !hasCheckedIn ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckInScreen()),
              ),
              child: const Icon(Icons.add),
            ) : null,
          ),
        ],
      ),
    );
  }

  void _showWaterAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Regar todas las plantas'),
        content: const Text(
          '¿Quieres regar todas tus plantas?\n'
          'Esto ayudará a su crecimiento, pero es más efectivo si lo haces '
          'después de completar ejercicios de mindfulness.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(gardenProvider.notifier).waterAllPlants();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Todas las plantas han sido regadas!'),
                ),
              );
            },
            child: const Text('Regar todas'),
          ),
        ],
      ),
    );
  }
} 