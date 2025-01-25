import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../config/hive_type_ids.dart';
part 'preferences.g.dart';

@HiveType(typeId: HiveTypeIds.userPreferences)
class UserPreferences extends HiveObject {
  @HiveField(0)
  final bool dailyReminders;
  
  @HiveField(1)
  final TimeOfDay reminderTime;
  
  @HiveField(2)
  final ThemeMode theme;

  UserPreferences({
    required this.dailyReminders,
    required this.reminderTime,
    required this.theme,
  });

  static UserPreferences get defaults => UserPreferences(
        dailyReminders: true,
        reminderTime: const TimeOfDay(hour: 20, minute: 0),
        theme: ThemeMode.system,
      );

  UserPreferences copyWith({
    bool? dailyReminders,
    TimeOfDay? reminderTime,
    ThemeMode? theme,
  }) {
    return UserPreferences(
      dailyReminders: dailyReminders ?? this.dailyReminders,
      reminderTime: reminderTime ?? this.reminderTime,
      theme: theme ?? this.theme,
    );
  }
}

// Adaptadores para Hive
class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = HiveTypeIds.themeMode;

  @override
  ThemeMode read(BinaryReader reader) {
    return ThemeMode.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.writeByte(ThemeMode.values.indexOf(obj));
  }
}

class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = HiveTypeIds.timeOfDay;

  @override
  TimeOfDay read(BinaryReader reader) {
    final hour = reader.readByte();
    final minute = reader.readByte();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeByte(obj.hour);
    writer.writeByte(obj.minute);
  }
} 