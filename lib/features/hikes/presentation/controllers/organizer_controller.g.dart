// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// An organizer profile with their upcoming hikes.

@ProviderFor(organizerProfile)
final organizerProfileProvider = OrganizerProfileFamily._();

/// An organizer profile with their upcoming hikes.

final class OrganizerProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<Organizer>,
          Organizer,
          FutureOr<Organizer>
        >
    with $FutureModifier<Organizer>, $FutureProvider<Organizer> {
  /// An organizer profile with their upcoming hikes.
  OrganizerProfileProvider._({
    required OrganizerProfileFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'organizerProfileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$organizerProfileHash();

  @override
  String toString() {
    return r'organizerProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Organizer> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Organizer> create(Ref ref) {
    final argument = this.argument as int;
    return organizerProfile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrganizerProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$organizerProfileHash() => r'135ef523837c1f42920f712e1c190d9a124af1de';

/// An organizer profile with their upcoming hikes.

final class OrganizerProfileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Organizer>, int> {
  OrganizerProfileFamily._()
    : super(
        retry: null,
        name: r'organizerProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// An organizer profile with their upcoming hikes.

  OrganizerProfileProvider call(int id) =>
      OrganizerProfileProvider._(argument: id, from: this);

  @override
  String toString() => r'organizerProfileProvider';
}
