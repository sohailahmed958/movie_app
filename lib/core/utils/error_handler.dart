import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movies_app/core/errors/failures.dart';
import '../errors/exceptions.dart';

class ErrorHandler {
  static Failure handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutFailure('Request timeout');
        case DioExceptionType.badResponse:
          return _handleResponseError(error.response!);
        case DioExceptionType.cancel:
          return const ServerFailure('Request cancelled');
        case DioExceptionType.connectionError:
          return const NetworkFailure('No internet connection');
        case DioExceptionType.unknown:
        default:
          return const ServerFailure('An unknown Dio error occurred');
      }
    } else if (error is SocketException) {
      return const NetworkFailure('No internet connection');
    } else if (error is FormatException) {
      return const ServerFailure('Unable to process the data');
    } else if (error is AppException) {
      if (error is ServerException) return ServerFailure(error.message, error.statusCode);
      if (error is CacheException) return CacheFailure(error.message);
      if (error is NetworkException) return NetworkFailure(error.message);
      if (error is NotFoundException) return NotFoundFailure(error.message, error.statusCode);
      if (error is BadRequestException) return BadRequestFailure(error.message, error.statusCode);
      if (error is UnauthorizedException) return UnauthorizedFailure(error.message, error.statusCode);
      if (error is TimeoutException) return TimeoutFailure(error.message);
      if (error is TooManyRequestsException) return TooManyRequestsFailure(error.message, error.statusCode);
      if (error is ServiceUnavailableException) return ServiceUnavailableFailure(error.message, error.statusCode);
      return ServerFailure(error.message, error.statusCode); // Generic AppException fallback
    } else {
      return ServerFailure('Something went wrong: ${error.toString()}');
    }
  }

  static Failure _handleResponseError(Response response) {
    switch (response.statusCode) {
      case 400:
        return BadRequestFailure(response.data['status_message'] ?? 'Bad request', response.statusCode);
      case 401:
        return UnauthorizedFailure(response.data['status_message'] ?? 'Unauthorized', response.statusCode);
      case 403:
        return UnauthorizedFailure(response.data['status_message'] ?? 'Forbidden', response.statusCode);
      case 404:
        return NotFoundFailure(response.data['status_message'] ?? 'Not found', response.statusCode);
      case 429:
        return TooManyRequestsFailure(response.data['status_message'] ?? 'Too many requests', response.statusCode);
      case 500:
        return ServerFailure(
          response.data['status_message'] ?? 'Internal server error',
          response.statusCode,
        );
      case 503:
        return ServiceUnavailableFailure(
          response.data['status_message'] ?? 'Service unavailable',
          response.statusCode,
        );
      default:
        return ServerFailure(
          response.data['status_message'] ?? 'Something went wrong with the server response',
          response.statusCode,
        );
    }
  }

  static String getErrorMessage(Failure failure) {
    return failure.message;
  }
}

