import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/services/word_info_cleanup_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'word_infos_display.dart';

class WordInfoView extends StatefulWidget {
  const WordInfoView({super.key, required this.searchWord, this.cerf});
  final String searchWord;
  final WordCerf? cerf;

  @override
  State<WordInfoView> createState() => _WordInfoViewState();
}

class _WordInfoViewState extends State<WordInfoView> {
  Future<Result<WordInfoUsable, String>> loadWord(BuildContext ctx) async {
    var res = await ctx.read<AppState>().searchWord(widget.searchWord);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.searchWord)),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: FutureBuilder<Result<WordInfoUsable, String>>(
          future: loadWord(context),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var res = snapshot.data!;
              if (res.isError) {
                return Text("cannot find word, error: ${res.error}");
              } else {
                var wordInfo = res.unwrap();
                return WordInfosDisplay(wordInfo: wordInfo);
              }
            } else if (snapshot.hasError) {
              return Text(
                "Un caught error in logic, ${snapshot.error?.toString()}",
              );
            } else {
              return LoadingCircle();
            }
          },
        ),
      ),
    );
  }
}

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 60, height: 60, child: CircularProgressIndicator()),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Awaiting result...'),
          ),
        ],
      ),
    );
  }
}
