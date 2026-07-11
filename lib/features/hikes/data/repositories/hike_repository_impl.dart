import 'package:fandag/features/hikes/data/datasources/datasources.dart';
import 'package:fandag/features/hikes/data/models/models.dart';
import 'package:fandag/features/hikes/domain/domain.dart';

class HikeRepositoryImpl implements HikeRepository {
  HikeRepositoryImpl({required HikeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final HikeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Hike>> getHikes({
    required HikeFilters filters,
    required int limit,
    required int offset,
  }) async {
    final List<HikeDto> dtos = await _remoteDataSource.getHikes(
      filters: filters,
      limit: limit,
      offset: offset,
    );

    return dtos.map((HikeDto dto) => dto.toDomain()).toList();
  }

  @override
  Future<Hike> getHike(int id) async {
    final HikeDto dto = await _remoteDataSource.getHike(id);

    return dto.toDomain();
  }

  @override
  Future<List<Organizer>> getOrganizers() async {
    final List<OrganizerDto> dtos = await _remoteDataSource.getOrganizers();

    return dtos.map((OrganizerDto dto) => dto.toDomain()).toList();
  }

  @override
  Future<Organizer> getOrganizer(int id) async {
    final OrganizerDto dto = await _remoteDataSource.getOrganizer(id);

    return dto.toDomain();
  }
}
