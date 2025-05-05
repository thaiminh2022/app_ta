import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/dictionary/presentation/index.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/features/word_of_the_day/presentation/index.dart'; // Thêm màn hình Word of the Day
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo binding
  tz.initializeTimeZones(); // Cấu hình Timezone
  final appState = AppState();
  await appState.loadLearnedWords(); // Load trước khi runApp
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
  _initializeNotifications();
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AppState>().loadLearnedWords();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    tz.initializeTimeZones(); // Quan trọng

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Không cần yêu cầu quyền nữa, vì Android tự động xử lý quyền thông báo
    await _scheduleDailyWordNotification();
  }

  Future<void> _scheduleDailyWordNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Word of the Day',
      'Tap to see today\'s word!',
      _nextInstanceOfHour(8), // 8 giờ sáng, tuỳ chọn
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'word_daily_channel',
          'Word Daily',
          channelDescription: 'Shows a word every day',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Mỗi ngày
    );
  }

  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );
    return scheduled.isBefore(now)
        ? scheduled.add(const Duration(days: 1))
        : scheduled;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BottomNavbar(),
    );
  }
}

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  var _idx = 0;
  final List<Widget> _widgetOptions = <Widget>[
    DictionarySearch(),
    Hangman(),
    WordOfTheDayScreen(), // Thêm màn hình Word of the Day vào đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_idx),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Dictionary"),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Hangman"),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: "Word of the Day",
          ), // Thêm item mới cho Word of the Day
        ],
        currentIndex: _idx,
        onTap: (value) {
          if (value >= _widgetOptions.length || value < 0) return;
          if (value != _idx) {
            setState(() {
              _idx = value;
            });
          }
        },
      ),
    );
  }
}
