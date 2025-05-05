import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/custom_splash_screen.dart';
import 'package:app_ta/features/dictionary/presentation/index.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:app_ta/features/dashboard/presentation/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
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
      Provider.of<AppState>(context, listen: false).loadLearnedWords();
    });
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
        scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
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
      routes: {
        '/dictionary': (context) => DictionarySearch(),
        '/hangman': (context) => Hangman(),
        '/dashboard': (context) => const Dashboard(),
      },
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
    const Dashboard(),
    DictionarySearch(),
    Hangman(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_idx),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Dictionary"),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Hangman"),
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withAlpha(
          153,
        ), // Sử dụng withAlpha thay vì withOpacity
        selectedLabelStyle: const TextStyle(fontSize: 18),
        unselectedLabelStyle: const TextStyle(fontSize: 18),
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 30),
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(30, 30, 30, 1)
                : const Color.fromRGBO(255, 255, 255, 1),
      ),
    );
  }
}
