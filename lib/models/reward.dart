import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';

part 'reward.g.dart';

@HiveType(typeId: HiveTypeIds.rewardType)
enum RewardType {
  @HiveField(0)
  plant,
  @HiveField(1)
  background,
  @HiveField(2)
  theme,
}

@HiveType(typeId: HiveTypeIds.reward)
class Reward extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final RewardType type;

  @HiveField(4)
  final String assetPath;

  @HiveField(5)
  final bool isUnlocked;

  @HiveField(6)
  final int requiredPoints;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.assetPath,
    this.isUnlocked = false,
    required this.requiredPoints,
  });

  Reward copyWith({
    String? id,
    String? title,
    String? description,
    RewardType? type,
    String? assetPath,
    bool? isUnlocked,
    int? requiredPoints,
  }) {
    return Reward(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      assetPath: assetPath ?? this.assetPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      requiredPoints: requiredPoints ?? this.requiredPoints,
    );
  }

  static List<Reward> get defaults => [
        Reward(
          id: 'plant_rose',
          title: 'Rosa Mística',
          description: 'Una hermosa rosa que brilla con luz propia',
          type: RewardType.plant,
          assetPath: 'assets/images/plants/rose.png',
          requiredPoints: 100,
        ),
        Reward(
          id: 'bg_sunset',
          title: 'Atardecer Sereno',
          description: 'Un fondo con tonos cálidos del atardecer',
          type: RewardType.background,
          assetPath: 'assets/images/backgrounds/sunset.png',
          requiredPoints: 200,
        ),
        Reward(
          id: 'theme_nature',
          title: 'Tema Natural',
          description: 'Un tema inspirado en los colores de la naturaleza',
          type: RewardType.theme,
          assetPath: 'assets/themes/nature.json',
          requiredPoints: 300,
        ),
      ];
} 