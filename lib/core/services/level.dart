import 'package:app_ta/core/models/level_model.dart';
import 'package:app_ta/core/models/word_cerf.dart';

class LevelService {
  LevelModel levelData;
  LevelService({required this.levelData});

  WordCerf get level => levelData.level;
  double get exp => levelData.exp;
  set exp(double value) {
    levelData.exp = value;
  }

  static const Map<WordCerf, double> expThreashold = {
    WordCerf.a1: 0,
    WordCerf.a2: 100,
    WordCerf.b1: 500,
    WordCerf.b2: 2000,
    WordCerf.c1: 4000,
    WordCerf.c2: 5000,
  };

  static const Map<WordCerf, double> wordToExp = {
    WordCerf.unknown: 1,
    WordCerf.a1: 1,
    WordCerf.a2: 2,
    WordCerf.b1: 4,
    WordCerf.b2: 8,
    WordCerf.c1: 12,
    WordCerf.c2: 20,
  };

  double getDailyStreakBonusPercentage(int streek) {
    if (streek >= 50) return 2;
    if (streek >= 30) return 1.5;
    if (streek >= 10) return 1.2;
    if (streek >= 3) return 1.1;

    return 1;
  }

  double _calExp(int amount, {int streek = 0}) {
    return amount * getDailyStreakBonusPercentage(streek);
  }

  void addExp(int base, {int streek = 0}) {
    levelData.exp += _calExp(base, streek: streek);
  }

  void addExpForGame(WordCerf cerf, {int streek = 0}) {
    final baseExp = wordToExp[cerf] ?? 1;
    addExp(baseExp.toInt(), streek: streek);
  }

  void addExpForLearnedWord(WordCerf cerf, {int streek = 0}) {
    final baseExp = wordToExp[cerf] ?? 1;
    addExp(baseExp.toInt(), streek: streek);
  }

  void removeExp(int base, {int streek = 0}) {
    levelData.exp -= _calExp(base, streek: streek);
  }

  void levelUp() {
    if (levelData.level == WordCerf.c2) return;
    levelData.level = WordCerf.values[levelData.level.index + 1];
    levelData.exp = 0;
  }

  void reset() {
    levelData.level = WordCerf.a1;
    levelData.exp = 0;
  }

  bool canLevelUp() {
    if (!expThreashold.containsKey(levelData.level)) {
      return false;
    }
    final threashold = expThreashold[levelData.level]!;
    return levelData.exp >= threashold;
  }
}
