import 'dart:io';

import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/custom_splash_screen.dart';
import 'package:app_ta/navigators/dashboard_navigator.dart';
import 'package:app_ta/navigators/dictionary_navigator.dart';
import 'package:app_ta/navigators/hangman_navigator.dart';
import 'package:app_ta/navigators/word_of_the_day_navigator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart'; // Thêm để sử dụng SystemNavigator

// 👇 Đã chỉnh lại đường dẫn cho GameScreen
import 'package:app_ta/features/games/wordle/presentation/index.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo binding
  tz.initializeTimeZones(); // Cấu hình Timezone
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(), // Use the initialized appState
      child: const MyApp(),
    ),
  );
  _initializeNotifications();
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');
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
    // Sử dụng Future.microtask để đảm bảo context an toàn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadLearnedWords();
      context.read<AppState>().loadTheme();
      context.read<AppState>().loadStreak();
      _initNotifications();
    });
  }

  Future<void> _initNotifications() async {
    tz.initializeTimeZones(); // Quan trọng

    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Không cần yêu cầu quyền nữa, vì Android tự động xử lý quyền thông báo
    // notification not implemented for windows
    if (!Platform.isWindows) await _scheduleDailyWordNotification();
  }

  Future<void> _scheduleDailyWordNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Word of the Day',
      'Tap to see today\'s word!',
      _nextInstanceOfHour(8), // 8 giờ sáng, tùy chọn
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
    final appState = Provider.of<AppState>(context);
    return MaterialApp(
      title: 'DailyE',
      themeMode: appState.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(173, 216, 230, 1),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 250, 1),
        cardColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(173, 216, 230, 1),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        cardColor: const Color.fromRGBO(66, 66, 66, 1),
      ),
      home: const CustomSplashScreen(),
    );
  }
}

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  var _idx = 2;
  int _backPressCount = 0; // Biến đếm số lần nhấn back
  DateTime? _lastBackPressTime; // Biến lưu thời gian nhấn back cuối cùng

  final List<Widget> _widgetOptions = <Widget>[
    WordOfTheDayNavigator(),
    DictionaryNavigator(),
    DashboardNavigator(),
    HangmanNavigator(),
    WordleGame(),
  ];

  @override
  Widget build(BuildContext context) {
    var darkTheme = context.watch<AppState>().isDarkTheme;
    return PopScope(
      canPop: false, // Không cho phép pop tự động
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return; // Nếu đã pop, không làm gì thêm
        // Kiểm tra thời gian giữa 2 lần nhấn back (2 giây)
        if (_lastBackPressTime == null ||
            DateTime.now().difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _backPressCount = 1;
          _lastBackPressTime = DateTime.now();
          // Hiển thị thông báo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          _backPressCount++;
          if (_backPressCount >= 2) {
            // Thoát ứng dụng
            if (Platform.isAndroid || Platform.isIOS) {
              SystemNavigator.pop(); // Thoát hoàn toàn ứng dụng
            }
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix([
                    1, 0, 0, 0, 0, // R
                    0, 1, 0, 0, 0, // G
                    0, 0, 1, 0, 0, // B
                    0, 0, 0, 1, 0, // A
                  ]),
                  child: Image.asset(
                    darkTheme
                        ? "assets/home_screen/dashboard_black.png"
                        : "assets/home_screen/dashboard.png",
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            SafeArea(child: IndexedStack(index: _idx, children: _widgetOptions)),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.lightbulb),
              label: "Daily Word",
            ),
            NavigationDestination(icon: Icon(Icons.book), label: "Dictionary"),
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            NavigationDestination(icon: Icon(Icons.gamepad), label: "Hangman"),
            NavigationDestination(icon: Icon(Icons.grid_on), label: "Wordle"),
          ],
          selectedIndex: _idx,
          onDestinationSelected: (value) {
            if (value >= _widgetOptions.length || value < 0) return;
            if (value != _idx) {
              setState(() {
                _idx = value;
              });
            }
          },
          indicatorColor: Theme.of(context).colorScheme.primary,
          backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color.fromRGBO(30, 30, 30, 1)
              : const Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
    );
  }
}