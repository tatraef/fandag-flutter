// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hike_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Full details of a single hike (includes the organizer's city).

@ProviderFor(hikeDetail)
final hikeDetailProvider = HikeDetailFamily._();

/// Full details of a single hike (includes the organizer's city).

final class HikeDetailProvider
    extends $FunctionalProvider<AsyncValue<Hike>, Hike, FutureOr<Hike>>
    with $FutureModifier<Hike>, $FutureProvider<Hike> {
  /// Full details of a single hike (includes the organizer's city).
  HikeDetailProvider._({
    required HikeDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'hikeDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hikeDetailHash();

  @override
  String toString() {
    return r'hikeDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Hike> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Hike> create(Ref ref) {
    final argument = this.argument as int;
    return hikeDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HikeDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hikeDetailHash() => r'c398479c374e167b8ce727f3e1a3d708548c8484';

/// Full details of a single hike (includes the organizer's city).

final class HikeDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Hike>, int> {
  HikeDetailFamily._()
    : super(
        retry: null,
        name: r'hikeDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Full details of a single hike (includes the organizer's city).

  HikeDetailProvider call(int id) =>
      HikeDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'hikeDetailProvider';
}
