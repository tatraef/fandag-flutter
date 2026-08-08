// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_hikes_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the hikes behind the saved favorite ids.
///
/// Ids that 404 (the hike passed and was cleaned up on the backend) are
/// silently dropped from local storage.

@ProviderFor(favoriteHikes)
final favoriteHikesProvider = FavoriteHikesProvider._();

/// Loads the hikes behind the saved favorite ids.
///
/// Ids that 404 (the hike passed and was cleaned up on the backend) are
/// silently dropped from local storage.

final class FavoriteHikesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Hike>>,
          List<Hike>,
          FutureOr<List<Hike>>
        >
    with $FutureModifier<List<Hike>>, $FutureProvider<List<Hike>> {
  /// Loads the hikes behind the saved favorite ids.
  ///
  /// Ids that 404 (the hike passed and was cleaned up on the backend) are
  /// silently dropped from local storage.
  FavoriteHikesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteHikesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteHikesHash();

  @$internal
  @override
  $FutureProviderElement<List<Hike>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Hike>> create(Ref ref) {
    return favoriteHikes(ref);
  }
}

String _$favoriteHikesHash() => r'afdcb684bc1201e9e7f4f142055318d11c445556';
