// import 'package:app_ta/core/models/result.dart';
// import 'package:app_ta/core/models/word_info.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/word_of_the_day/models/word_of_the_day.dart';

class WordOfTheDayService {
  Future<WordOfTheDay> getWordOfTheDay(AppState appState) async {
    var word = await appState.getRandomWordCerf();

    return WordOfTheDay(word: word.word, ipa: '', meaning: '', example: '');
  }
}
