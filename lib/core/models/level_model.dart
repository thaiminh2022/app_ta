import 'package:app_ta/core/models/word_cerf.dart';

class LevelModel {
  WordCerf level;
  int exp;

  LevelModel({this.level = WordCerf.a1, this.exp = 0});
  Map<String, dynamic> toJson() {
    return {
      'level': level.toString(), // Assuming WordCerf can be stored as a string
      'exp': exp,
    };
  }

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      level: WordCerf.values.firstWhere(
        (e) => e.toString() == json['level'],
        orElse: () => WordCerf.unknown, // Default fallback
      ),
      exp: json['exp'] ?? 0,
    );
  }
}
