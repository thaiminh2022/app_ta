import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/word_of_the_day/models/word_of_the_day.dart';

class WordOfTheDayService {
  /// Trả về full WordOfTheDay (word + ipa + meaning + example)
  Future<WordOfTheDay> getWordOfTheDay(AppState s) async {
    var randWord = await s.getRandomWordCerf();

    return WordOfTheDay(
      word: randWord.word,
      ipa: " ",
      meaning: " ",
      example: " ",
    );
  }
}
