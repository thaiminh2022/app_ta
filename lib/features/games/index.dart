import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:app_ta/features/games/wordle/presentation/index.dart';
import 'package:flutter/material.dart';

class GameData {
  final Widget view;
  final String imagePath;
  final String name;

  const GameData(this.view, this.imagePath, this.name);
}

class GameSpace extends StatelessWidget {
  GameSpace({super.key});

  final _datas = <GameData>[
    GameData(Hangman(), 'assets/gamespace_icon/hangman.png', "Hangman"),
    GameData(WordleView(), 'assets/gamespace_icon/wordle.png', "Wordle"),
    GameData(
      Placeholder(),
      'assets/gamespace_icon/wordmatch.png',
      "Match word",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageHeader("GameSpace"),
        actions: [ProfileMenu()],
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // Maximum width of each item
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: _datas.length,
            itemBuilder: (context, index) {
              final data = _datas[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => data.view),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(data.imagePath, fit: BoxFit.contain),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data.name),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
