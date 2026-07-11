import 'package:fandag/features/favorites/data/datasources/datasources.dart';
import 'package:fandag/features/favorites/domain/domain.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required FavoritesLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final FavoritesLocalDataSource _localDataSource;

  @override
  List<int> getFavoriteIds() => _localDataSource.readIds();

  @override
  Future<void> add(int hikeId) async {
    final List<int> ids = _localDataSource.readIds();

    if (ids.contains(hikeId)) {
      return;
    }

    await _localDataSource.writeIds(<int>[hikeId, ...ids]);
  }

  @override
  Future<void> remove(int hikeId) async {
    final List<int> ids = _localDataSource.readIds()
      ..removeWhere((int id) => id == hikeId);

    await _localDataSource.writeIds(ids);
  }
}
