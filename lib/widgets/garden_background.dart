import 'package:flutter/material.dart';
import '../models/weather_state.dart';

class GardenBackground extends StatelessWidget {
  final WeatherState weather;
  final Widget child;

  const GardenBackground({
    super.key,
    required this.weather,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _WeatherEffects(weather: weather),
        child,
      ],
    );
  }
}

class _WeatherEffects extends StatelessWidget {
  final WeatherState weather;

  const _WeatherEffects({required this.weather});

  @override
  Widget build(BuildContext context) {
    return switch (weather.type) {
      WeatherType.sunny => _buildSunnyEffect(intensity: weather.intensity),
      WeatherType.cloudy => _buildCloudyEffect(intensity: weather.intensity),
      WeatherType.rainy => _buildRainyEffect(intensity: weather.intensity),
      WeatherType.stormy => _buildStormyEffect(intensity: weather.intensity),
      WeatherType.rainbow => _buildRainbowEffect(intensity: weather.intensity),
    };
  }

  Widget _buildSunnyEffect({required double intensity}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.yellow.withOpacity(0.2 * intensity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildCloudyEffect({required double intensity}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.withOpacity(0.3 * intensity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildRainyEffect({required double intensity}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blueGrey.withOpacity(0.3 * intensity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildStormyEffect({required double intensity}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.withOpacity(0.4 * intensity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildRainbowEffect({required double intensity}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple.withOpacity(0.2 * intensity),
            Colors.blue.withOpacity(0.2 * intensity),
            Colors.green.withOpacity(0.2 * intensity),
            Colors.yellow.withOpacity(0.2 * intensity),
            Colors.orange.withOpacity(0.2 * intensity),
            Colors.red.withOpacity(0.2 * intensity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
} 