// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hikes_feed_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HikesFeedController)
final hikesFeedControllerProvider = HikesFeedControllerProvider._();

final class HikesFeedControllerProvider
    extends $AsyncNotifierProvider<HikesFeedController, HikesFeedState> {
  HikesFeedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hikesFeedControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hikesFeedControllerHash();

  @$internal
  @override
  HikesFeedController create() => HikesFeedController();
}

String _$hikesFeedControllerHash() =>
    r'a3fa8a5a79cb382e958d170f1f208c10cc6d0faa';

abstract class _$HikesFeedController extends $AsyncNotifier<HikesFeedState> {
  FutureOr<HikesFeedState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HikesFeedState>, HikesFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HikesFeedState>, HikesFeedState>,
              AsyncValue<HikesFeedState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
