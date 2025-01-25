import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/emotion_stats.dart';
import '../models/emotion_type.dart';
import '../models/subscription.dart';
import '../providers/stats_provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/emotion_trend_chart.dart';
import '../widgets/stats_card.dart';
import '../widgets/premium_banner.dart';
import 'subscription_screen.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final subscription = ref.watch(subscriptionProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOverviewCard(context, stats),
          const SizedBox(height: 16),
          _buildEmotionsCard(context, stats),
          const SizedBox(height: 16),
          _buildGardenCard(context, stats),
          if (subscription.tier == SubscriptionTier.free)
            PremiumBanner(
              onUpgrade: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubscriptionScreen(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, EmotionStats stats) {
    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildStatRow(context, 'Total de check-ins:', '${stats.totalCheckins}'),
          _buildStatRow(context, 'Intensidad promedio:', 
            '${(stats.averageIntensity * 100).round() / 100}'),
          _buildStatRow(context, 'Emoción más frecuente:', 
            _getEmotionLabel(stats.mostFrequent)),
        ],
      ),
    );
  }

  Widget _buildEmotionsCard(BuildContext context, EmotionStats stats) {
    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tendencias Emocionales',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _buildPieSections(stats),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenCard(BuildContext context, EmotionStats stats) {
    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jardín',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildStatRow(context, 'Total de plantas:', '${stats.totalPlants}'),
          _buildStatRow(context, 'Plantas maduras:', '${stats.fullyGrownPlants}'),
          _buildStatRow(
            context, 
            'Tiempo promedio de crecimiento:', 
            '${stats.averageGrowthTime.inDays} días',
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(EmotionStats stats) {
    return stats.emotionCounts.entries.map((entry) {
      final emotion = entry.key;
      final count = entry.value;
      final total = stats.totalCheckins;
      
      return PieChartSectionData(
        color: _getEmotionColor(emotion),
        value: count.toDouble(),
        title: '${(count / total * 100).round()}%',
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  String _getEmotionLabel(EmotionType emotion) {
    return switch (emotion) {
      EmotionType.joy => 'Alegría',
      EmotionType.gratitude => 'Gratitud',
      EmotionType.calm => 'Calma',
      EmotionType.anxiety => 'Ansiedad',
      EmotionType.sadness => 'Tristeza',
    };
  }

  Color _getEmotionColor(EmotionType emotion) {
    return switch (emotion) {
      EmotionType.joy => Colors.yellow.shade600,
      EmotionType.gratitude => Colors.pink.shade300,
      EmotionType.calm => Colors.purple.shade300,
      EmotionType.anxiety => Colors.orange.shade400,
      EmotionType.sadness => Colors.blue.shade400,
    };
  }
} 