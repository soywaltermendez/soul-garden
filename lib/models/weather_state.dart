import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';

part 'weather_state.g.dart';

@HiveType(typeId: HiveTypeIds.weatherType)
enum WeatherType {
  @HiveField(0)
  sunny,     // Para emociones muy positivas
  @HiveField(1)
  cloudy,    // Para emociones neutras
  @HiveField(2)
  rainy,     // Para emociones tristes
  @HiveField(3)
  stormy,    // Para emociones intensas negativas
  @HiveField(4)
  rainbow,   // Para momentos de transición positiva
}

@HiveType(typeId: HiveTypeIds.weather)
class WeatherState extends HiveObject {
  @HiveField(0)
  final WeatherType type;
  
  @HiveField(1)
  final double intensity; // 0.0 a 1.0
  
  @HiveField(2)
  final DateTime lastUpdated;

  WeatherState({
    required this.type,
    this.intensity = 1.0,
    DateTime? lastUpdated,
  }) : this.lastUpdated = lastUpdated ?? DateTime.now();

  factory WeatherState.initial() {
    return WeatherState(type: WeatherType.sunny);
  }
} 