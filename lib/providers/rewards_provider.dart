import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/reward.dart';
import '../config/constants.dart';

final rewardsProvider = StateNotifierProvider<RewardsNotifier, List<Reward>>((ref) {
  return RewardsNotifier();
});

class RewardsNotifier extends StateNotifier<List<Reward>> {
  final Box<Reward> _rewardsBox = Hive.box(AppConstants.rewardsBox);

  RewardsNotifier() : super([]) {
    _loadRewards();
  }

  void _loadRewards() {
    if (_rewardsBox.isEmpty) {
      _initializeDefaultRewards();
    }
    state = _rewardsBox.values.toList();
  }

  Future<void> _initializeDefaultRewards() async {
    final defaultRewards = [
      Reward(
        id: 'plant_rose',
        title: 'Rosa Mística',
        description: 'Una rosa que brilla con luz propia',
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

    for (final reward in defaultRewards) {
      await _rewardsBox.put(reward.id, reward);
    }
  }

  Future<void> unlockReward(String id) async {
    final reward = _rewardsBox.get(id);
    if (reward != null && !reward.isUnlocked) {
      final updatedReward = reward.copyWith(isUnlocked: true);
      await _rewardsBox.put(id, updatedReward);
      state = _rewardsBox.values.toList();
    }
  }
} 