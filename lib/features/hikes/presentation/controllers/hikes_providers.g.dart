// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hikes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hikeRemoteDataSource)
final hikeRemoteDataSourceProvider = HikeRemoteDataSourceProvider._();

final class HikeRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          HikeRemoteDataSource,
          HikeRemoteDataSource,
          HikeRemoteDataSource
        >
    with $Provider<HikeRemoteDataSource> {
  HikeRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hikeRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hikeRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<HikeRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HikeRemoteDataSource create(Ref ref) {
    return hikeRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HikeRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HikeRemoteDataSource>(value),
    );
  }
}

String _$hikeRemoteDataSourceHash() =>
    r'b59159c97f073e90648bbaa40d9969050db07840';

@ProviderFor(hikeRepository)
final hikeRepositoryProvider = HikeRepositoryProvider._();

final class HikeRepositoryProvider
    extends $FunctionalProvider<HikeRepository, HikeRepository, HikeRepository>
    with $Provider<HikeRepository> {
  HikeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hikeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hikeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HikeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HikeRepository create(Ref ref) {
    return hikeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HikeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HikeRepository>(value),
    );
  }
}

String _$hikeRepositoryHash() => r'bd34eaf26328da8745d2c277805db8b260458d67';

/// All organizers — used to populate the filter dropdown.

@ProviderFor(organizersList)
final organizersListProvider = OrganizersListProvider._();

/// All organizers — used to populate the filter dropdown.

final class OrganizersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Organizer>>,
          List<Organizer>,
          FutureOr<List<Organizer>>
        >
    with $FutureModifier<List<Organizer>>, $FutureProvider<List<Organizer>> {
  /// All organizers — used to populate the filter dropdown.
  OrganizersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizersListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizersListHash();

  @$internal
  @override
  $FutureProviderElement<List<Organizer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Organizer>> create(Ref ref) {
    return organizersList(ref);
  }
}

String _$organizersListHash() => r'd99c9e53d51c51113e3b1f286cd0c633c7a06f60';
