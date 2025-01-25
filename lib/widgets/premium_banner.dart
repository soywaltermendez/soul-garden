import 'package:flutter/material.dart';

class PremiumBanner extends StatelessWidget {
  final VoidCallback onUpgrade;

  const PremiumBanner({
    super.key,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.amber),
        title: const Text('¡Desbloquea todas las funciones!'),
        subtitle: const Text('Accede a ejercicios premium y más'),
        trailing: FilledButton(
          onPressed: onUpgrade,
          child: const Text('Actualizar'),
        ),
      ),
    );
  }
} 