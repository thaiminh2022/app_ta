class GameState {
  final String targetWord;
  final int maxGuesses;
  List<String> guesses = [];
  String currentGuess = '';

  GameState({required this.targetWord, required this.maxGuesses});

  void addLetter(String letter) {
    if (currentGuess.length < targetWord.length) {
      currentGuess += letter;
    }
  }

  void deleteLastLetter() {
    if (currentGuess.isNotEmpty) {
      currentGuess = currentGuess.substring(0, currentGuess.length - 1);
    }
  }

  bool canSubmitGuess() {
    return currentGuess.length == targetWord.length;
  }

  void submitGuess() {
    if (canSubmitGuess()) {
      guesses.add(currentGuess);
      currentGuess = '';
    }
  }

  bool hasWon() {
    return guesses.isNotEmpty && guesses.last == targetWord;
  }

  bool hasLost() {
    return guesses.length >= maxGuesses && !hasWon();
  }

  Map<String, String> getUsedLetters() {
    Map<String, String> usedLetters = {};
    for (var guess in guesses) {
      for (int i = 0; i < guess.length; i++) {
        String letter = guess[i];
        if (!usedLetters.containsKey(letter)) {
          if (targetWord[i] == letter) {
            usedLetters[letter] = 'correct';
          } else if (targetWord.contains(letter)) {
            usedLetters[letter] = 'present';
          } else {
            usedLetters[letter] = 'absent';
          }
        }
      }
    }
    return usedLetters;
  }
}
