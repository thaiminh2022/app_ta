import 'dart:async';
import 'dart:ui' show Locale;

import 'package:app_ta/features/wordle/src/feature/game/model/game_result.dart';
import 'package:app_ta/features/wordle/src/feature/level/data/level_datasource.dart';

abstract interface class ILevelRepository {
  Future<List<GameResult>?> getLevels(Locale dictionary);

  Future<void> setLevels(Locale dictionary, GameResult levelInfo);
}

final class LevelRepository implements ILevelRepository {
  const LevelRepository({required ILevelDatasource levelDataSource})
    : _levelDataSource = levelDataSource;

  final ILevelDatasource _levelDataSource;

  @override
  Future<List<GameResult>?> getLevels(Locale dictionary) =>
      _levelDataSource.getLevels(dictionary.languageCode);

  @override
  Future<void> setLevels(Locale dictionary, GameResult levelInfo) async =>
      _levelDataSource.setLevel(dictionary.languageCode, levelInfo);
}
