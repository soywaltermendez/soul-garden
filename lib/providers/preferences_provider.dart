import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/preferences.dart';
import '../services/notifications_service.dart';
import '../config/constants.dart';

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, UserPreferences>((ref) {
  return PreferencesNotifier();
});

class PreferencesNotifier extends StateNotifier<UserPreferences> {
  PreferencesNotifier() : super(UserPreferences.defaults) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final box = await Hive.openBox<UserPreferences>('preferences');
    state = box.get('user_preferences') ?? UserPreferences.defaults;
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    final box = await Hive.openBox<UserPreferences>('preferences');
    await box.put('user_preferences', preferences);
    state = preferences;

    if (preferences.dailyReminders) {
      await NotificationsService.scheduleDailyReminder(
        time: preferences.reminderTime,
      );
    } else {
      await NotificationsService.cancelAllNotifications();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await updatePreferences(state.copyWith(theme: mode));
  }
} 