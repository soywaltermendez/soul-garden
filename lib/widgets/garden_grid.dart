import 'package:flutter/material.dart';
import '../models/plant.dart';
import 'plant_tile.dart';

class GardenGrid extends StatelessWidget {
  final List<Plant> plants;
  final Function(Plant) onPlantTap;

  const GardenGrid({
    super.key,
    required this.plants,
    required this.onPlantTap,
  });

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return const Center(
        child: Text('Registra tus emociones para comenzar a cultivar tu jardín'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(6),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.75,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return PlantTile(
          plant: plant,
          onTap: () => onPlantTap(plant),
        );
      },
    );
  }
} 