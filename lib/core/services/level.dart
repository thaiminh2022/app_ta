import 'package:app_ta/core/models/level_model.dart';
import 'package:app_ta/core/models/word_cerf.dart';

class LevelService {
  LevelModel levelData;
  LevelService({required this.levelData});

  WordCerf get level => levelData.level;
  int get exp => levelData.exp;

  static const Map<WordCerf, int> expThreashold = {
    WordCerf.a1: 10,
    WordCerf.a2: 32,
    WordCerf.b1: 45,
    WordCerf.b2: 10,
    WordCerf.c1: 56,
    WordCerf.c2: 10,
  };

  void addExp(int amount) {
    levelData.exp += amount;
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
    int threashold = expThreashold[levelData.level]!;
    return levelData.exp >= threashold;
  }
}
