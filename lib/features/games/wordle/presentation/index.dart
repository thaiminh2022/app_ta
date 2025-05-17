import 'dart:math';

import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/utils/error_calls.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/games/wordle/presentation/wordle_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordleView extends StatelessWidget {
  const WordleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: PageHeader("Wordle"),
        actions: [ProfileMenu()],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gamespace_icon/wordle.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            FilledButton(
              onPressed: () async {
                var appState = context.read<AppState>();
                var learned = appState.learnedWords;

                if (learned.isEmpty) {
                  showSnackError(context, "You haven't learn any words");
                  return;
                }

                if (context.mounted) {
                  final rand = learned[Random().nextInt(learned.length)];
                  final wordInfoRes = await appState.searchWord(rand);

                  if (wordInfoRes.isError) {
                    if (context.mounted) {
                      showSnackError(context, wordInfoRes.unwrapError());
                    }
                    return;
                  }
                  final wordInfo = wordInfoRes.unwrap();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => WordleGame(wordInfo: wordInfo),
                      ),
                    );
                  }
                }
              },
              child: Text("From learned word"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                var appState = context.read<AppState>();
                var randRes = await appState.getRandomWordCerf();

                if (randRes.isError) {
                  return;
                }

                if (context.mounted) {
                  final rand = randRes.unwrap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => WordleGame(wordInfo: rand.wordInfo),
                    ),
                  );
                }
              },
              child: Text("From random word"),
            ),
          ],
        ),
      ),
    );
  }
}
