class RandomWordModel {
  final String word;
  final String definition;
  final String pronunciation;

  RandomWordModel({
    required this.word,
    required this.definition,
    required this.pronunciation,
  });

  factory RandomWordModel.fromJson(Map<String, dynamic> json) =>
      RandomWordModel(
        word: json["word"],
        definition: json["definition"],
        pronunciation: json["pronunciation"],
      );
}
