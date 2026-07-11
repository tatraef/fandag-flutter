import 'package:dio/dio.dart';
import 'package:fandag/core/constants/constants.dart';
import 'package:fandag/core/network/network.dart';
import 'package:fandag/core/utils/date_formatting.dart';
import 'package:fandag/features/hikes/data/models/models.dart';
import 'package:fandag/features/hikes/domain/domain.dart';

class HikeRemoteDataSource {
  HikeRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<HikeDto>> getHikes({
    required HikeFilters filters,
    required int limit,
    required int offset,
  }) async {
    final Response<List<dynamic>> response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.hikes,
      queryParameters: _buildQuery(filters: filters, limit: limit, offset: offset),
    );
    final List<dynamic> data = response.data ?? <dynamic>[];

    return data.cast<Map<String, dynamic>>().map(HikeDto.fromJson).toList();
  }

  Future<HikeDto> getHike(int id) async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .get<Map<String, dynamic>>('${ApiEndpoints.hikes}/$id');
    final Map<String, dynamic>? data = response.data;

    if (data == null) {
      throw const NotFoundException(message: 'Поход не найден');
    }

    return HikeDto.fromJson(data);
  }

  Future<List<OrganizerDto>> getOrganizers() async {
    final Response<List<dynamic>> response = await _apiClient
        .get<List<dynamic>>(ApiEndpoints.organizers);
    final List<dynamic> data = response.data ?? <dynamic>[];

    return data.cast<Map<String, dynamic>>().map(OrganizerDto.fromJson).toList();
  }

  Future<OrganizerDto> getOrganizer(int id) async {
    final Response<Map<String, dynamic>> response = await _apiClient
        .get<Map<String, dynamic>>('${ApiEndpoints.organizers}/$id');
    final Map<String, dynamic>? data = response.data;

    if (data == null) {
      throw const NotFoundException(message: 'Организатор не найден');
    }

    return OrganizerDto.fromJson(data);
  }

  Map<String, dynamic> _buildQuery({
    required HikeFilters filters,
    required int limit,
    required int offset,
  }) {
    return <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (filters.dateFrom != null)
        'date_from': DateFormatting.toApiDate(filters.dateFrom!),
      if (filters.dateTo != null)
        'date_to': DateFormatting.toApiDate(filters.dateTo!),
      // The API accepts a single difficulty; when exactly one is selected we
      // delegate to the server. Multi-select is narrowed client-side in the
      // repository.
      if (filters.difficulties.length == 1)
        'difficulty': filters.difficulties.first,
      if (filters.priceMax != null) 'price_max': filters.priceMax,
      if (filters.region != null) 'region': filters.region,
      if (filters.organizerId != null) 'organizer_id': filters.organizerId,
    };
  }
}
