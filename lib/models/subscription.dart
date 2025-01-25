import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';
part 'subscription.g.dart';

@HiveType(typeId: HiveTypeIds.subscriptionTier)
enum SubscriptionTier {
  @HiveField(0)
  free,
  @HiveField(1)
  monthly,
  @HiveField(2)
  yearly,
}

@HiveType(typeId: HiveTypeIds.subscription)
class Subscription extends HiveObject {
  @HiveField(0)
  final SubscriptionTier tier;
  
  @HiveField(1)
  final DateTime startDate;
  
  @HiveField(2)
  final DateTime endDate;

  Subscription({
    required this.tier,
    required this.startDate,
    required this.endDate,
  });

  bool get isActive => 
    tier != SubscriptionTier.free && 
    DateTime.now().isBefore(endDate);

  bool get isPremium => tier != SubscriptionTier.free;

  static Subscription get free => Subscription(
    tier: SubscriptionTier.free,
    startDate: DateTime.now(),
    endDate: DateTime.now(),
  );

  Subscription copyWith({
    SubscriptionTier? tier,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Subscription(
      tier: tier ?? this.tier,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
} 