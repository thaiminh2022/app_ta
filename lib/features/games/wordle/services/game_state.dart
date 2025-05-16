class GameState {
  final String targetWord;
  final int maxGuesses;
  final List<String> _guesses = [];
  List<String> get guesses => _guesses;
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
        _guesses.add(currentGuess.substring(0, word.length));
      } else {
        _guesses.add(currentGuess);
      }
      currentGuess = '';
    }
  }

  bool hasWon() {
    return _guesses.isNotEmpty &&
        _guesses.last.toUpperCase() == targetWord.toUpperCase();
  }

  bool hasLost() {
    return _guesses.length >= maxGuesses && !hasWon();
  }
}
