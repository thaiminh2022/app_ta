import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/word_of_the_day/models/word_of_the_day_model.dart';

class WordOfTheDayService {
  Future<Result<WordOfTheDayModel, String>> getWordOfTheDay(
      AppState appState, [
        bool refresh = false,
      ]) async {
    final randomWordRes = await appState.getRandomWordCerf();
    if (randomWordRes.isError) {
      return Result.err(randomWordRes.unwrapError());
    }

    final wordInfo = randomWordRes.unwrap().wordInfo;
    final cerf = randomWordRes.unwrap().cerf;

    var definition =
        wordInfo.meanings.values.firstOrNull?.firstOrNull?.definition;

    return Result.ok(
      WordOfTheDayModel(
        word: wordInfo.word,
        cerf: cerf,
        definition: definition,
      ),
    );
  }
}