import 'package:fandag/core/storage/storage.dart';
import 'package:fandag/features/favorites/data/data.dart';
import 'package:fandag/features/favorites/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorites_providers.g.dart';

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(Ref ref) {
  final SharedPreferences prefs = ref.watch(sharedPrefsProvider);

  return FavoritesRepositoryImpl(
    localDataSource: FavoritesLocalDataSource(prefs: prefs),
  );
}
