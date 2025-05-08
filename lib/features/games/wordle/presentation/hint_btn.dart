import 'package:app_ta/features/games/wordle/services/wordle_service.dart';
import 'package:flutter/material.dart';

class HintBtn extends StatelessWidget {
  HintBtn({super.key, required this.targetWord});

  final String targetWord;
  final _apiService = WordleService();

  Future<void> showHint(BuildContext context) async {
    // Check if the widget is still mounted before proceeding

    if (context.mounted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Hint'),
              content: FutureBuilder(
                future: _apiService.fetchWordDefinition(targetWord),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.requireData.isEmpty
                          ? "No definition"
                          : snapshot.requireData,
                    );
                  } else if (snapshot.hasError) {
                    return Text("internal error");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          showHint(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        child: const Text('Hint'),
      ),
    );
  }
}
