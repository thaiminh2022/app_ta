class HangmanModel {
  late String word;
  List<String> badGuesses = [];
  List<int> guessedIndexes = [];

  int maxGuesses = 6;
  bool wonByGuessWord = false;

  HangmanModel(String w) {
    word = w.trim();
  }

  bool get isWon {
    return maxGuesses > 0 &&
        (guessedIndexes.length == word.length || wonByGuessWord);
  }

  bool get isGameEnded {
    return maxGuesses <= 0 || isWon;
  }

  void guess(String s) {
    if (s.isEmpty || maxGuesses <= 0 || wonByGuessWord) return;

    s = s.trim();
    if (s.length > 1) {
      // Player guess a word
      if (s != word) {
        badGuesses.add(s);
        maxGuesses--;
      } else {
        // wtf correct already?
        wonByGuessWord = true;
      }
    } else {
      // guess a character
      bool found = false;
      for (int i = 0; i < word.length; i++) {
        if (s == word[i]) {
          found = true;
          if (!guessedIndexes.contains(i)) guessedIndexes.add(i);
        }
      }
      // Did not find that character
      if (!found) {
        badGuesses.add(s);
        maxGuesses--;
      }
    }
  }

  String getDisplay() {
    if (isWon) {
      return word;
    }
    String s = "";
    for (int i = 0; i < word.length; i++) {
      if (guessedIndexes.contains(i)) {
        s += word[i];
      } else {
        s += "_ ";
      }
    }
    return s;
  }
}
