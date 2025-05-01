class WordCerfModel {
  final int wordId;
  final String word;

  WordCerfModel({required this.wordId, required this.word});

  factory WordCerfModel.fromCsv(List<dynamic> row) {
    return WordCerfModel(wordId: int.parse(row[0]), word: row[1]);
  }
}

enum WordCerf { a1, a2, b1, b2, c1, c2, unknown }
