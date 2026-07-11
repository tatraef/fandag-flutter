import 'package:dio/dio.dart';
import 'package:fandag/core/network/api_exception.dart';

/// Error interceptor callback type.
///
/// Converts any error to [ApiException].
typedef ApiErrorInterceptor = ApiException Function(Object error);

/// HTTP client wrapper with automatic error conversion.
///
/// Wraps [Dio] and uses [errorInterceptor] to convert all errors
/// to [ApiException] before rethrowing them.
///
/// This ensures that datasources never expose [DioException] to repositories.
class ApiClient {
  ApiClient({required Dio dio, required this.errorInterceptor}) : _dio = dio;

  final Dio _dio;
  final ApiErrorInterceptor errorInterceptor;

  /// Performs a generic HTTP request.
  ///
  /// All errors are converted to [ApiException] via [errorInterceptor].
  Future<Response<T>> request<T>(
    String path, {
    required String method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
      );
    } catch (err) {
      throw errorInterceptor(err);
    }
  }

  /// Performs a GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Performs a POST request.
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Performs a PUT request.
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Performs a PATCH request.
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Performs a DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
