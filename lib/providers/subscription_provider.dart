import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/subscription.dart';

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, Subscription>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<Subscription> {
  final Box<Subscription> _subscriptionBox = Hive.box('subscription');
  
  SubscriptionNotifier() : super(
    Subscription(
      tier: SubscriptionTier.free,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),
  ) {
    _loadSubscription();
  }

  void _loadSubscription() {
    final subscription = _subscriptionBox.get('current');
    if (subscription != null) {
      state = subscription;
    }
  }

  Future<void> updateSubscription(Subscription subscription) async {
    await _subscriptionBox.put('current', subscription);
    state = subscription;
  }

  Future<void> cancelSubscription() async {
    final freeSubscription = Subscription(
      tier: SubscriptionTier.free,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
    await _subscriptionBox.put('current', freeSubscription);
    state = freeSubscription;
  }
} 