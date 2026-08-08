import 'package:fandag/core/environment/app_config.dart';
import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/hikes/data/data.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hikes_providers.g.dart';

@riverpod
HikeRemoteDataSource hikeRemoteDataSource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);

  return HikeRemoteDataSource(apiClient: apiClient);
}

@riverpod
HikeRepository hikeRepository(Ref ref) {
  if (AppConfig.useMock) {
    return HikeRepositoryMock();
  }

  final HikeRemoteDataSource dataSource = ref.watch(
    hikeRemoteDataSourceProvider,
  );

  return HikeRepositoryImpl(remoteDataSource: dataSource);
}

/// All organizers — used to populate the filter dropdown.
@riverpod
Future<List<Organizer>> organizersList(Ref ref) {
  return ref.watch(hikeRepositoryProvider).getOrganizers();
}
