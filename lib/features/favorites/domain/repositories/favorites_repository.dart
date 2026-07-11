abstract class FavoritesRepository {
  /// Locally stored ids of favorite hikes, newest first.
  ///
  /// Synchronous because the backing [SharedPreferences] is already loaded.
  List<int> getFavoriteIds();

  Future<void> add(int hikeId);

  Future<void> remove(int hikeId);
}
