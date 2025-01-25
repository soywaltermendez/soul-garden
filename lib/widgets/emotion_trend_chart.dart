import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/emotion_check.dart';

class EmotionTrendChart extends StatelessWidget {
  final List<EmotionCheck> checks;

  const EmotionTrendChart({
    super.key,
    required this.checks,
  });

  @override
  Widget build(BuildContext context) {
    final spots = checks.map((check) {
      return FlSpot(
        check.timestamp.millisecondsSinceEpoch.toDouble(),
        check.intensity.toDouble(),
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
} 