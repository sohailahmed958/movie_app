abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);
}

class ServerException extends AppException {
  const ServerException(String message, [int? statusCode]) : super(message, statusCode);
}

class CacheException extends AppException {
  const CacheException(String message) : super(message);
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class NotFoundException extends AppException {
  const NotFoundException(String message, [int? statusCode]) : super(message, statusCode);
}

class BadRequestException extends AppException {
  const BadRequestException(String message, [int? statusCode]) : super(message, statusCode);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message, [int? statusCode]) : super(message, statusCode);
}

class TimeoutException extends AppException {
  const TimeoutException(String message) : super(message);
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException(String message, [int? statusCode]) : super(message, statusCode);
}

class ServiceUnavailableException extends AppException {
  const ServiceUnavailableException(String message, [int? statusCode]) : super(message, statusCode);
}



/*abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);
}

class ServerException extends AppException {
  const ServerException(String message, [int? statusCode])
      : super(message, statusCode);
}

class CacheException extends AppException {
  const CacheException(String message) : super(message);
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message);
}

class BadRequestException extends AppException {
  const BadRequestException(String message) : super(message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message) : super(message);
}

class TimeoutException extends AppException {
  const TimeoutException(String message) : super(message);
}*/