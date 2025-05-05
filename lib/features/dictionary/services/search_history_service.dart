import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  final _searchHistoryKey = "search_history";
  var _searchHistory = <String>{};

  Future<Set<String>> get searchHistory async {
    await loadSearchHistory();
    return _searchHistory;
  }

  Future<void> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyRes = prefs.getStringList(_searchHistoryKey);

    if (historyRes != null) {
      _searchHistory = historyRes.toSet();
    }
  }

  Future<bool> saveItem(String item) async {
    if (_searchHistory.isEmpty) {
      await loadSearchHistory();
    }
    var success = _searchHistory.add(item);
    await saveSearchHistory();

    return success;
  }

  Future<bool> saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();

    bool success = await prefs.setStringList(
      _searchHistoryKey,
      _searchHistory.toList(),
    );
    return success;
  }

  Future<bool> removeItem(String item) async {
    var success = _searchHistory.remove(item);
    await saveSearchHistory();
    return success;
  }
}
