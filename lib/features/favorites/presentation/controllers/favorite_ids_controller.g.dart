// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_ids_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The set of favorite hike ids, kept in memory and mirrored to local storage.

@ProviderFor(FavoriteIds)
final favoriteIdsProvider = FavoriteIdsProvider._();

/// The set of favorite hike ids, kept in memory and mirrored to local storage.
final class FavoriteIdsProvider
    extends $NotifierProvider<FavoriteIds, Set<int>> {
  /// The set of favorite hike ids, kept in memory and mirrored to local storage.
  FavoriteIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteIdsHash();

  @$internal
  @override
  FavoriteIds create() => FavoriteIds();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$favoriteIdsHash() => r'94617c1295b0e236c0ab4530e8548da9c7591dfa';

/// The set of favorite hike ids, kept in memory and mirrored to local storage.

abstract class _$FavoriteIds extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
