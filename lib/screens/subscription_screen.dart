import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _FeaturesList(),
          const SizedBox(height: 24),
          _SubscriptionPlans(currentTier: subscription.tier),
        ],
      ),
    );
  }
}

class _FeaturesList extends StatelessWidget {
  const _FeaturesList();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Características Premium',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: Icons.auto_awesome,
              title: 'Ejercicios Avanzados',
              description: 'Accede a todos los ejercicios de mindfulness',
            ),
            _buildFeatureItem(
              icon: Icons.park,
              title: 'Plantas Especiales',
              description: 'Desbloquea plantas únicas para tu jardín',
            ),
            _buildFeatureItem(
              icon: Icons.insights,
              title: 'Estadísticas Detalladas',
              description: 'Analiza tu progreso en profundidad',
            ),
            _buildFeatureItem(
              icon: Icons.block,
              title: 'Sin Anuncios',
              description: 'Disfruta de una experiencia sin interrupciones',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionPlans extends ConsumerWidget {
  final SubscriptionTier currentTier;

  const _SubscriptionPlans({required this.currentTier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildPlanCard(
          context,
          title: 'Plan Mensual',
          price: '\$4.99/mes',
          tier: SubscriptionTier.monthly,
          ref: ref,
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          context,
          title: 'Plan Anual',
          price: '\$49.99/año',
          subtitle: '¡Ahorra 17%!',
          tier: SubscriptionTier.yearly,
          ref: ref,
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    String? subtitle,
    required SubscriptionTier tier,
    required WidgetRef ref,
  }) {
    final isSelected = currentTier == tier;

    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              price,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: isSelected
                  ? null
                  : () => _subscribe(context, ref, tier),
              child: Text(isSelected ? 'Plan Actual' : 'Seleccionar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _subscribe(
    BuildContext context,
    WidgetRef ref,
    SubscriptionTier tier,
  ) async {
    // TODO: Implementar lógica de suscripción real
    final now = DateTime.now();
    final endDate = switch (tier) {
      SubscriptionTier.monthly => now.add(const Duration(days: 30)),
      SubscriptionTier.yearly => now.add(const Duration(days: 365)),
      _ => now,
    };

    await ref.read(subscriptionProvider.notifier).updateSubscription(
          Subscription(
            tier: tier,
            startDate: now,
            endDate: endDate,
          ),
        );

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
} 