import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:app_ta/features/games/word_match/presentation/index.dart';
import 'package:app_ta/features/games/wordle/presentation/index.dart';
import 'package:flutter/material.dart';

class GameData {
  final Widget view;
  final IconData icon;
  final String name;

  const GameData(this.view, this.icon, this.name);
}

class GameSpace extends StatelessWidget {
  GameSpace({super.key});

  final _datas = <GameData>[
    GameData(Hangman(), Icons.man, "Hangman"),
    GameData(WordleView(), Icons.abc, "Wordle"),
    GameData(
      // Placeholder
      WordMatch(),
      Icons.dataset_linked_sharp,
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
                      Expanded(child: Icon(data.icon, size: 100)),
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
