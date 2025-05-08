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
    return currentGuess.length >= targetWord.length;
  }

  void submitGuess() {
    if (canSubmitGuess()) {
      var word = targetWord.toUpperCase();
      if (currentGuess.length > word.length) {
        guesses.add(currentGuess.substring(0, word.length));
      } else {
        guesses.add(currentGuess);
      }
      currentGuess = '';
    }
  }

  bool hasWon() {
    return guesses.isNotEmpty && guesses.last == targetWord;
  }

  bool hasLost() {
    return guesses.length >= maxGuesses && !hasWon();
  }
}
