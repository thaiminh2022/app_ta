import 'package:app_ta/core/models/word_cerf.dart';

class WordOfTheDayModel {
  String word;
  WordCerf cerf;
  String? definition;

  WordOfTheDayModel({required this.word, required this.cerf, this.definition});
}
