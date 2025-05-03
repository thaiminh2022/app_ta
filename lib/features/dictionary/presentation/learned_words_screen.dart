import 'package:app_ta/core/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnedWordsScreen extends StatelessWidget {
  const LearnedWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learned Words"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          var displayedWords = appState.learnedWords.length > 10
              ? appState.learnedWords.sublist(0, 10)
              : appState.learnedWords;
          return ListView.builder(
            itemCount: displayedWords.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(displayedWords[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    appState.removeWordFromLearned(displayedWords[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}