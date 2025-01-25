import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'config/theme.dart';
import 'config/routes.dart';
import 'models/emotion_type.dart';
import 'models/emotion_check.dart';
import 'models/plant.dart';
import 'models/subscription.dart';
import 'models/reward.dart';
import 'models/weather_state.dart';
import 'models/achievement.dart';
import 'models/exercise.dart';
import 'models/emotion_stats.dart';
import 'models/preferences.dart';
import 'services/notifications_service.dart';
import 'providers/preferences_provider.dart';
import 'config/constants.dart';
import 'config/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar timezone
  tz.initializeTimeZones();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  // Registrar adaptadores en orden de typeId
  Hive.registerAdapter(EmotionTypeAdapter());       // typeId: 1
  Hive.registerAdapter(EmotionCheckAdapter());      // typeId: 2
  Hive.registerAdapter(PlantAdapter());            // typeId: 3
  Hive.registerAdapter(SubscriptionTierAdapter()); // typeId: 4
  Hive.registerAdapter(SubscriptionAdapter());     // typeId: 5
  Hive.registerAdapter(RewardTypeAdapter());       // typeId: 6
  Hive.registerAdapter(RewardAdapter());           // typeId: 7
  Hive.registerAdapter(WeatherTypeAdapter());      // typeId: 8
  Hive.registerAdapter(WeatherStateAdapter());     // typeId: 9
  Hive.registerAdapter(TimeOfDayAdapter());        // typeId: 10
  Hive.registerAdapter(AchievementTypeAdapter());  // typeId: 11
  Hive.registerAdapter(AchievementAdapter());      // typeId: 12
  Hive.registerAdapter(ExerciseTypeAdapter());     // typeId: 13
  Hive.registerAdapter(ExerciseAdapter());         // typeId: 14
  Hive.registerAdapter(EmotionStatsAdapter());     // typeId: 15
  Hive.registerAdapter(UserPreferencesAdapter());  // typeId: 16
  Hive.registerAdapter(ThemeModeAdapter());        // typeId: 19
  
  // Abrir boxes
  await Hive.openBox<EmotionCheck>(AppConstants.emotionChecksBox);
  await Hive.openBox<Plant>(AppConstants.plantsBox);
  await Hive.openBox<Subscription>(AppConstants.subscriptionBox);
  await Hive.openBox<Reward>(AppConstants.rewardsBox);
  await Hive.openBox<WeatherState>(AppConstants.weatherBox);
  await Hive.openBox<Achievement>(AppConstants.achievementsBox);
  await Hive.openBox<Exercise>(AppConstants.exercisesBox);
  await Hive.openBox<EmotionStats>(AppConstants.statsBox);
  await Hive.openBox<UserPreferences>(AppConstants.preferencesBox);
  
  // Inicializar notificaciones
  await NotificationsService.init();
  
  runApp(
    const ProviderScope(
      child: soulGardenApp(),
    ),
  );
}

class soulGardenApp extends ConsumerWidget {
  const soulGardenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);
    
    return MaterialApp(
      navigatorKey: AppNavigation.navigatorKey,
      title: 'Soul Garden',
      theme: soulGardenTheme,
      darkTheme: soulGardenDarkTheme,
      themeMode: preferences.theme,
      routes: routes,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
    );
  }
}

// Adaptador para TimeOfDay en Hive
class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final typeId = 10;

  @override
  TimeOfDay read(BinaryReader reader) {
    final hour = reader.readInt();
    final minute = reader.readInt();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeInt(obj.hour);
    writer.writeInt(obj.minute);
  }
} 