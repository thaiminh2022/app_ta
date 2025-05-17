import 'package:app_ta/core/models/level_model.dart';
import 'package:app_ta/core/models/word_cerf.dart';

class LevelService {
  LevelModel levelData;
  LevelService({required this.levelData});

  WordCerf get level => levelData.level;
  double get exp => levelData.exp;

  static const Map<WordCerf, int> expThreshold = {
    WordCerf.a1: 0,
    WordCerf.a2: 500,
    WordCerf.b1: 1000,
    WordCerf.b2: 2000,
    WordCerf.c1: 4000,
    WordCerf.c2: 8000,
  };

  static const Map<WordCerf, int> wordToExp = {
    WordCerf.unknown: 1,
    WordCerf.a1: 1,
    WordCerf.a2: 2,
    WordCerf.b1: 4,
    WordCerf.b2: 8,
    WordCerf.c1: 12,
    WordCerf.c2: 20,
  };

  double getDailyStreakBonusPercentage(int streak) {
    if (streak >= 50) return 2;
    if (streak >= 30) return 1.5;
    if (streak >= 10) return 1.2;
    if (streak >= 3) return 1.1;

    return 1;
  }

  double _calExp(int amount, {int streak = 0}) {
    return amount * getDailyStreakBonusPercentage(streak);
  }

  void addExp(int base, {int streak = 0}) {
    levelData.exp += _calExp(base, streak: streak);
  }

  void removeExp(int base, {int streak = 0}) {
    levelData.exp -= _calExp(base, streak: streak);
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
    if (!expThreshold.containsKey(levelData.level)) {
      return false;
    }
    int threshold = expThreshold[levelData.level]!;
    return levelData.exp >= threshold;
  }

  // New method to set the level
  void setLevel(WordCerf newLevel) {
    if (expThreshold.containsKey(newLevel)) {
      levelData.level = newLevel;
      levelData.exp = 0; // Reset exp when setting a new level
    }
  }
}