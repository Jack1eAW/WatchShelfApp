import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  LocalStore(this._preferences);

  static const watchlistKey = 'watch_shelf.watchlist';
  static const ratingsKey = 'watch_shelf.ratings';

  final SharedPreferencesAsync _preferences;

  Future<List<String>> loadWatchlistKeys() async {
    return await _preferences.getStringList(watchlistKey) ?? const [];
  }

  Future<void> saveWatchlistKeys(List<String> keys) {
    return _preferences.setStringList(watchlistKey, keys);
  }

  Future<Map<String, int>> loadRatings() async {
    final encoded = await _preferences.getString(ratingsKey);
    if (encoded == null || encoded.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(encoded) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  Future<void> saveRatings(Map<String, int> ratings) {
    return _preferences.setString(ratingsKey, jsonEncode(ratings));
  }
}
