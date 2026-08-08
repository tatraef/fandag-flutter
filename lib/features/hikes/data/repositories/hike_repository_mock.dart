import 'dart:convert';

import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/hikes/data/models/models.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:flutter/services.dart';

/// In-memory repository backed by a bundled JSON snapshot of `GET /hikes`.
///
/// Used when `AppConfig.useMock` is enabled (`make run-mock`) so the app can be
/// developed and demoed without a running backend.
class HikeRepositoryMock implements HikeRepository {
  static const Duration _simulatedDelay = Duration(milliseconds: 500);
  static const String _assetPath = 'assets/mock/hikes.json';

  List<Hike>? _cache;

  @override
  Future<List<Hike>> getHikes({
    required HikeFilters filters,
    required int limit,
    required int offset,
  }) async {
    await Future<void>.delayed(_simulatedDelay);

    final List<Hike> hikes = await _loadHikes();
    final List<Hike> matching = hikes
        .where((Hike hike) => _matches(hike, filters))
        .toList();

    if (offset >= matching.length) {
      return const <Hike>[];
    }

    final int end = (offset + limit).clamp(0, matching.length);

    return matching.sublist(offset, end);
  }

  @override
  Future<Hike> getHike(int id) async {
    await Future<void>.delayed(_simulatedDelay);

    final List<Hike> hikes = await _loadHikes();

    for (final Hike hike in hikes) {
      if (hike.id == id) {
        return hike;
      }
    }

    throw const NotFoundException(message: 'Поход не найден');
  }

  @override
  Future<List<Organizer>> getOrganizers() async {
    await Future<void>.delayed(_simulatedDelay);

    final List<Hike> hikes = await _loadHikes();
    final Map<int, Organizer> organizers = <int, Organizer>{};

    for (final Hike hike in hikes) {
      organizers.putIfAbsent(hike.organizer.id, () => hike.organizer);
    }

    return organizers.values.toList();
  }

  @override
  Future<Organizer> getOrganizer(int id) async {
    await Future<void>.delayed(_simulatedDelay);

    final List<Hike> hikes = await _loadHikes();
    final List<Hike> organizerHikes = hikes
        .where((Hike hike) => hike.organizer.id == id)
        .toList();

    if (organizerHikes.isEmpty) {
      throw const NotFoundException(message: 'Организатор не найден');
    }

    return organizerHikes.first.organizer.copyWith(hikes: organizerHikes);
  }

  /// Parses the bundled snapshot once and keeps it for the app session.
  Future<List<Hike>> _loadHikes() async {
    final List<Hike>? cached = _cache;

    if (cached != null) {
      return cached;
    }

    final String source = await rootBundle.loadString(_assetPath);
    final List<dynamic> json = jsonDecode(source) as List<dynamic>;
    final List<Hike> hikes =
        json
            .cast<Map<String, dynamic>>()
            .map(HikeDto.fromJson)
            .map((HikeDto dto) => dto.toDomain())
            .toList()
          ..sort(
            (Hike a, Hike b) => a.dateStart.compareTo(b.dateStart),
          );
    _cache = hikes;

    return hikes;
  }

  bool _matches(Hike hike, HikeFilters filters) {
    final DateTime? dateFrom = filters.dateFrom;
    final DateTime? dateTo = filters.dateTo;
    final int? priceMax = filters.priceMax;
    final String? region = filters.region;
    final int? organizerId = filters.organizerId;

    if (dateFrom != null && hike.dateStart.isBefore(dateFrom)) {
      return false;
    }

    if (dateTo != null && hike.dateStart.isAfter(dateTo)) {
      return false;
    }

    if (filters.difficulties.isNotEmpty &&
        !filters.difficulties.contains(hike.difficulty)) {
      return false;
    }

    if (priceMax != null && (hike.price ?? 0) > priceMax) {
      return false;
    }

    if (region != null && hike.region != region) {
      return false;
    }

    if (organizerId != null && hike.organizer.id != organizerId) {
      return false;
    }

    return true;
  }
}
