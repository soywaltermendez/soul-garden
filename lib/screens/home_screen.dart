import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/garden_provider.dart';
import '../widgets/garden_grid.dart';
import '../widgets/garden_background.dart';
import '../models/weather_state.dart';
import '../providers/environment_provider.dart';
import 'check_in_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plants = ref.watch(gardenProvider);
    final weather = ref.watch(environmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Jardín'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: GardenBackground(
        weather: weather,
        child: GardenGrid(
          plants: plants,
          onPlantTap: (plant) {
            ref.read(gardenProvider.notifier).waterPlant(plant.id);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CheckInScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.park),
            label: 'Jardín',
          ),
          NavigationDestination(
            icon: Icon(Icons.self_improvement),
            label: 'Mindfulness',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights),
            label: 'Estadísticas',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/mindfulness');
              break;
            case 2:
              Navigator.pushNamed(context, '/stats');
              break;
          }
        },
      ),
    );
  }
} 