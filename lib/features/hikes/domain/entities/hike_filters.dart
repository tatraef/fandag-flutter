import 'package:freezed_annotation/freezed_annotation.dart';

part 'hike_filters.freezed.dart';

/// User-selected feed filters. Maps to query parameters of `GET /hikes`.
@freezed
abstract class HikeFilters with _$HikeFilters {
  const factory HikeFilters({
    DateTime? dateFrom,
    DateTime? dateTo,
    @Default(<String>{}) Set<String> difficulties,
    int? priceMax,
    String? region,
    int? organizerId,
  }) = _HikeFilters;

  const HikeFilters._();

  /// Whether any filter is active (used for the AppBar indicator).
  bool get isActive =>
      dateFrom != null ||
      dateTo != null ||
      difficulties.isNotEmpty ||
      priceMax != null ||
      region != null ||
      organizerId != null;
}
