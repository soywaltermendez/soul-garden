import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/weather_state.dart';
import '../models/emotion_check.dart';
import '../models/emotion_type.dart';
import '../config/constants.dart';

final environmentProvider = StateNotifierProvider<EnvironmentNotifier, WeatherState>((ref) {
  return EnvironmentNotifier();
});

class EnvironmentNotifier extends StateNotifier<WeatherState> {
  final Box<WeatherState> _weatherBox = Hive.box(AppConstants.weatherBox);
  
  EnvironmentNotifier() : super(WeatherState.initial()) {
    _loadWeather();
  }

  void _loadWeather() {
    final weather = _weatherBox.get('current');
    if (weather != null) {
      state = weather;
    }
  }

  Future<void> updateWeather(List<EmotionCheck> recentCheckins) async {
    if (recentCheckins.isEmpty) {
      state = WeatherState.initial();
      return;
    }

    final avgIntensity = recentCheckins
        .map((c) => c.intensity)
        .reduce((a, b) => a + b) / recentCheckins.length;

    final positiveCount = recentCheckins
        .where((c) => c.emotion == EmotionType.joy || c.emotion == EmotionType.gratitude)
        .length;

    final positiveRatio = positiveCount / recentCheckins.length;

    final weatherType = switch (positiveRatio) {
      > 0.7 => WeatherType.rainbow,
      > 0.5 => WeatherType.sunny,
      > 0.3 => WeatherType.cloudy,
      > 0.1 => WeatherType.rainy,
      _ => WeatherType.stormy,
    };

    final newWeather = WeatherState(
      type: weatherType,
      intensity: avgIntensity / 5.0,
    );

    await _weatherBox.put('current', newWeather);
    state = newWeather;
  }
} 