import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/word_of_the_day/models/word_of_the_day_model.dart';

class WordOfTheDayService {
  Future<WordOfTheDayModel> getWordOfTheDay(AppState appState) async {
    final wordInfo = await appState.getRandomWordCerf();
    final wordInfoRes = await appState.searchWord(wordInfo.word);

    if (wordInfoRes.isSuccess) {
      var meaning = wordInfoRes.unwrap().meanings.values.first.first.definition;
      return WordOfTheDayModel(
        word: wordInfo.word,
        cerf: wordInfo.cerf,
        definition: meaning,
      );
    }

    return WordOfTheDayModel(word: wordInfo.word, cerf: wordInfo.cerf);
  }
}
