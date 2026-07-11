import 'package:dio/dio.dart';
import 'package:fandag/core/network/api_exception.dart';

/// Converts any error (especially [DioException]) to [ApiException].
///
/// Used as error interceptor strategy in [ApiClient].
abstract class ApiExceptionConverter {
  /// Converts any error to [ApiException].
  ///
  /// If [error] is a [DioException], maps it to the appropriate [ApiException] subtype.
  /// Otherwise, wraps it in a generic [ServerException].
  static ApiException convert(Object error) {
    return error is DioException
        ? _convertDioException(error)
        : _convertUnknownException(error);
  }

  static ApiException _convertDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _convertBadResponse(e);
      default:
        return ServerException(message: e.message);
    }
  }

  static ApiException _convertBadResponse(DioException e) {
    final int? statusCode = e.response?.statusCode;
    final dynamic data = e.response?.data;

    // Extract server error details if available
    final _ServerErrorData errorData = _extractServerErrorData(data);

    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: errorData.message ?? e.message,
          errorCode: errorData.code,
        );
      case 401:
        return UnauthorizedException(
          message: errorData.message,
          errorCode: errorData.code,
        );
      case 404:
        return NotFoundException(
          message: errorData.message ?? e.message,
          errorCode: errorData.code,
        );
      default:
        return ServerException(
          message: errorData.message ?? e.message,
          statusCode: statusCode,
          errorCode: errorData.code,
        );
    }
  }

  static _ServerErrorData _extractServerErrorData(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return const _ServerErrorData(message: null, code: null);
    }

    final String? message =
        data['message'] as String? ??
        data['error'] as String? ??
        data['error_message'] as String?;

    final String? code =
        data['code'] as String? ??
        data['error_code'] as String? ??
        data['errorCode'] as String?;

    return _ServerErrorData(message: message, code: code);
  }

  static ApiException _convertUnknownException(Object error) {
    return ServerException(message: error.toString());
  }
}

class _ServerErrorData {
  const _ServerErrorData({required this.message, required this.code});

  final String? message;
  final String? code;
}
