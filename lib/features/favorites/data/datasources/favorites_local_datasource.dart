import 'package:shared_preferences/shared_preferences.dart';

/// Persists favorite hike ids on the device via [SharedPreferences].
class FavoritesLocalDataSource {
  FavoritesLocalDataSource({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _key = 'favorite_hike_ids';

  List<int> readIds() {
    final List<String> raw = _prefs.getStringList(_key) ?? <String>[];

    return raw
        .map(int.tryParse)
        .whereType<int>()
        .toList(growable: false);
  }

  Future<void> writeIds(List<int> ids) async {
    await _prefs.setStringList(
      _key,
      ids.map((int id) => id.toString()).toList(growable: false),
    );
  }
}
