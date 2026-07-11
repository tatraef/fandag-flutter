import 'package:fandag/core/exceptions/app_exception.dart';

sealed class ApiException extends AppException {
  const ApiException({super.message, this.statusCode, this.errorCode});

  final int? statusCode;
  final String? errorCode;

  @override
  String toString() =>
      '$runtimeType(message: $message, statusCode: $statusCode, errorCode: $errorCode)';
}

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection',
    super.errorCode,
  });
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.statusCode = 401,
    super.errorCode,
  });
}

class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error',
    super.statusCode = 500,
    super.errorCode,
  });
}

class TimeoutException extends ApiException {
  const TimeoutException({super.message = 'Request timeout', super.errorCode});
}

class BadRequestException extends ApiException {
  const BadRequestException({
    super.message = 'Bad request',
    super.statusCode = 400,
    super.errorCode,
  });
}

class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Not found',
    super.statusCode = 404,
    super.errorCode,
  });
}
