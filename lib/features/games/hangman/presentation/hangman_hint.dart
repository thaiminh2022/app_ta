import 'dart:developer';

import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/games/hangman/presentation/widgets/simplex_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HangmanHint extends StatefulWidget {
  const HangmanHint({super.key, required this.word});
  final String word;

  @override
  State<HangmanHint> createState() => _HangmanHintState();
}

class _HangmanHintState extends State<HangmanHint> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: context.read<AppState>().searchWord(widget.word),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("There are no hints");
            } else if (snapshot.hasData) {
              var dataRes = snapshot.requireData;
              if (dataRes.isError) {
                log(
                  "Loading word data for hints error: ${dataRes.unwrapError()}",
                );
                return Text("There are no hints");
              }

              var data = dataRes.unwrap();
              var examples = <String>[];
              outer:
              for (var m in data.meanings.values) {
                for (var def in m) {
                  if (def.exmaple != null && def.exmaple!.isNotEmpty) {
                    if (def.exmaple!.contains(widget.word)) {
                      examples.add(def.exmaple!);
                    }
                  }

                  if (examples.length >= 3) break outer;
                }
              }

              if (examples.isEmpty) {
                log("cannot find hints in word: ${widget.word}");
                return Text("There are no hints");
              }

              var examplesData =
                  examples.map((e) => e.replaceAll(widget.word, "_")).toList();

              return Column(
                children:
                    examplesData.indexed.map((p) {
                      var i = p.$1;
                      var e = p.$2;
                      return SimplexExpansionPanel(header: "Hint $i", desc: e);
                    }).toList(),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text("Loading hints"),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
