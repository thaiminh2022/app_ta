class WordPosModel {
  final int wordPosId;
  final int wordId;
  final int posTagId;
  final int frequencyCount;
  final double level;

  WordPosModel({
    required this.wordPosId,
    required this.wordId,
    required this.posTagId,
    required this.frequencyCount,
    required this.level,
  });

  factory WordPosModel.fromCsv(List<dynamic> row) {
    return WordPosModel(
      wordPosId: int.parse(row[0]),
      wordId: int.parse(row[1]),
      posTagId: int.parse(row[2]),
      frequencyCount: int.parse(row[4]),
      level: double.parse(row[5]),
    );
  }
}
