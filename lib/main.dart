import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/dictionary/presentation/index.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
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
    context.read<AppState>().loadLearnedWords();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade600),
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
  final List<Widget> _widgetOptions = <Widget>[DictionarySearch(), Hangman()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_idx),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
      ),
    );
  }
}
