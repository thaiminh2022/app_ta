import 'package:app_ta/features/wordle/src/core/constant/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/dictionary/presentation/index.dart';
import 'package:app_ta/features/wordle/src/core/constant/localization/localization.dart';
import 'package:app_ta/features/wordle/src/feature/game/bloc/game_bloc.dart';
import 'package:app_ta/features/wordle/src/feature/game/widget/game_page.dart';
import 'package:app_ta/features/wordle/src/feature/game/data/game_repository.dart';
import 'package:app_ta/features/wordle/src/feature/level/data/level_repository.dart';
import 'package:app_ta/features/wordle/src/feature/statistic/data/statistics_repository.dart';
import 'package:app_ta/features/wordle/src/feature/game/model/game_result.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => AppState(), child: MyApp()),
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('ru', '')],
      home: const BottomNavbar(),
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
    const DictionarySearch(),
    const Center(child: Text('Hangman Placeholder')),
    const WordleGame(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_idx),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Dictionary'),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Hangman'),
          BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Wordle'),
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

class WordleGame extends StatelessWidget {
  const WordleGame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => GameBloc(
            dictionary: const Locale('en'),
            gameDataSource: GameRepository(),
            statisticsRepository: StatisticsRepository(),
            levelDataSource:
                LevelRepository(), // Ensure LevelRepository is implemented correctly
            savedResult: null,
          ),
      child: const GamePage(),
    );
  }
}
