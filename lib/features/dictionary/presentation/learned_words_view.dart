import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/dictionary/presentation/widget/learned_button.dart';
import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnedWordsView extends StatelessWidget {
  LearnedWordsView({super.key});

  final List<String> _deletedWords = [];
  static const routeName = "/learnedWords";

  @override
  Widget build(BuildContext context) {
    var notFavoriteTextStyle = TextStyle(
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.italic,
      decoration: TextDecoration.lineThrough,
    );

    var learnedWords = context.watch<AppState>().learnedWords;
    return Scaffold(
      appBar: AppBar(title: Text("Learned Words")),
      body: ListView(
        children: [
          Visibility(
            visible: learnedWords.isEmpty,
            child: Text(
              "Tap the heart when searching in dictionary to learn",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          for (var word in learnedWords)
            ListTile(
              title: Row(
                children: [
                  Expanded(child: Text(word)),
                  LearnedButton(
                    word: word,
                    onDelete: (deletedWord) {
                      _deletedWords.add(deletedWord);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  WordInfoView.routeName,
                  arguments: WordInfoViewArgs(word),
                );
              },
            ),

          for (var word in _deletedWords)
            ListTile(
              title: Row(
                children: [
                  Expanded(child: Text(word, style: notFavoriteTextStyle)),
                  LearnedButton(
                    word: word,
                    onAdded: (addedWord) {
                      _deletedWords.remove(addedWord);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
