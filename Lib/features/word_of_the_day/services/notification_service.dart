import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_ta/features/word_of_the_day/models/notification_config.dart';
import 'dart:convert';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // xử lý khi user bấm vào thông báo
      },
    );
  }

  Future<void> scheduleDailyNotification(NotificationConfig config) async {
    final scheduledTime = _nextInstanceOfTime(config.hour, config.minute);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      config.title,
      config.body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'word_channel_id',
          'Word of the Day',
          importance: Importance.max,
          priority: Priority.high,
          visibility: NotificationVisibility.public,
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );

    await _saveConfig(config);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> _saveConfig(NotificationConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('notification_config', jsonEncode(config.toJson()));
  }

  Future<NotificationConfig?> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('notification_config');
    if (jsonStr == null) return null;
    final json = jsonDecode(jsonStr);
    return NotificationConfig.fromJson(json);
  }
}
