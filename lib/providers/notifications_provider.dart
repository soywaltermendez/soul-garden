import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../config/constants.dart';
import '../models/achievement.dart';
import '../config/navigation.dart';
import '../screens/check_in_screen.dart';
import '../widgets/notification_overlay.dart';

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, void>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<void> {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  NotificationsNotifier() : super(null);

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final context = AppNavigation.navigatorKey.currentContext;
        if (context != null) {
          _navigateToCheckIn(context);
        }
      },
    );
  }

  Future<void> scheduleDailyReminder({required TimeOfDay time}) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      0,
      'Es hora de tu check-in',
      '¿Cómo te sientes hoy?',
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showAchievementUnlocked(Achievement achievement) async {
    await _notifications.show(
      1,
      '¡Logro Desbloqueado!',
      achievement.title,
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  void showDailyReminder() {
    final context = AppNavigation.navigatorKey.currentContext;
    if (context == null) return;

    NotificationOverlay.showSnackBar(
      context: context,
      message: '¡No olvides hacer tu check-in diario!',
      action: SnackBarAction(
        label: 'Hacer Check-in',
        onPressed: () => NotificationOverlay.navigateToCheckIn(context),
      ),
    );
  }

  void showExerciseCompleted() {
    final context = AppNavigation.navigatorKey.currentContext;
    if (context == null) return;

    NotificationOverlay.showSnackBar(
      context: context,
      message: '¡Ejercicio completado! Todas tus plantas han sido regadas.',
      duration: const Duration(seconds: 4),
    );
  }

  void _navigateToCheckIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckInScreen()),
    );
  }
} 