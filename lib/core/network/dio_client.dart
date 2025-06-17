import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class DioClient {
  final Dio dio;
  final String baseUrl;

  DioClient({required this.dio, required this.baseUrl}) {
    // Crucial fix: Set the baseUrl for Dio's options
    dio
      ..options.baseUrl = baseUrl
    // Use Duration.seconds for connect and receive timeouts
      ..options.connectTimeout = const Duration(seconds: AppConstants.connectTimeoutInSeconds)
      ..options.receiveTimeout = const Duration(seconds: AppConstants.receiveTimeoutInSeconds)
      ..options.responseType = ResponseType.json;

    // Add interceptors for API key injection and centralized error handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Dynamically inject API key from .env file
          options.queryParameters['api_key'] = dotenv.env['TMDB_API_KEY'];
          return handler.next(options); // Continue with the request
        },
        onError: (DioException error, handler) async { // Changed DioError to DioException for newer Dio versions
          if (error.response != null) {
            // Map specific HTTP status codes to custom exceptions
            switch (error.response?.statusCode) {
              case 400:
                throw BadRequestException(
                  error.response?.data['status_message'] ?? 'Bad Request',
                  400,
                );
              case 401:
                throw UnauthorizedException(
                  error.response?.data['status_message'] ?? 'Unauthorized',
                  401,
                );
              case 404:
                throw NotFoundException(
                  error.response?.data['status_message'] ?? 'Not Found',
                  404,
                );
              case 429: // Too Many Requests
                throw TooManyRequestsException(
                  error.response?.data['status_message'] ?? 'Too Many Requests',
                  429,
                );
              case 500:
                throw ServerException(
                  error.response?.data['status_message'] ?? 'Internal Server Error',
                  500,
                );
              case 503: // Service Unavailable
                throw ServiceUnavailableException(
                  error.response?.data['status_message'] ?? 'Service Unavailable',
                  503,
                );
              default:
                throw ServerException(
                  error.response?.data['status_message'] ?? 'Unknown Server Error',
                  error.response?.statusCode,
                );
            }
          } else {
            // Handle network and timeout errors
            if (error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout) {
              throw TimeoutException('Request timeout. Please try again.');
            } else if (error.type == DioExceptionType.connectionError) {
              throw NetworkException('No internet connection. Please check your network settings.');
            } else if (error.type == DioExceptionType.badResponse) {
              // This typically means the server responded with an error, but not one of the specific ones above
              throw ServerException(error.message ?? 'Server responded with an error.', error.response?.statusCode);
            }
            throw NetworkException(error.message ?? 'An unexpected network error occurred.');
          }
        },
      ),
    );
  }

  // Generic GET method for making API calls
  Future<Response> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      // Re-throw the DioException so it can be caught and mapped to a Failure
      rethrow;
    }
  }

// Add other HTTP methods (post, put, delete, etc.) as needed following the same pattern
}


/*
import 'dart:async';

import 'package:dio/dio.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../errors/exceptions.dart';

class DioClient {
  final Dio dio;
  final String baseUrl;

  DioClient({required this.dio, required this.baseUrl}) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = dotenv.env['TMDB_API_KEY'];
          return handler.next(options);
        },
        onError: (DioError error, handler) async {
          if (error.response != null) {
            switch (error.response?.statusCode) {
              case 400:
                throw BadRequestException(
                  error.response?.data['message'] ?? 'Bad Request',
                );
              case 401:
                throw UnauthorizedException(
                  error.response?.data['message'] ?? 'Unauthorized',
                );
              case 404:
                throw NotFoundException(
                  error.response?.data['message'] ?? 'Not Found',
                );
              case 500:
                throw ServerException(
                  error.response?.data['message'] ?? 'Server Error',
                  error.response?.statusCode,
                );
              default:
                throw ServerException(
                  error.response?.data['message'] ?? 'Unknown Error',
                  error.response?.statusCode,
                );
            }
          } else {
            if (error.type == DioErrorType.connectTimeout ||
                error.type == DioErrorType.receiveTimeout ||
                error.type == DioErrorType.sendTimeout) {
              throw TimeoutException('Request timeout');
            }
            throw NetworkException('No Internet Connection');
          }
        },
      ),
    );
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError {
      rethrow;
    }
  }
}
*/



/*
class DioClient {
  final Dio dio;
  final String baseUrl;
  final SharedPreferences prefs;

  DioClient({
    required this.dio,
    required this.baseUrl,
    required this.prefs,
  }) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = AppConstants.connectTimeout
      ..options.receiveTimeout = AppConstants.receiveTimeout
      ..options.responseType = ResponseType.json
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Get token from storage
            final token = prefs.getString('token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            // Add API key to all requests
            options.queryParameters['api_key'] = const String.fromEnvironment('TMDB_API_KEY');

            return handler.next(options);
          },
          onError: (DioError error, handler) async {
            if (error.response != null) {
              switch (error.response?.statusCode) {
                case 400:
                  throw BadRequestException(
                    error.response?.data['message'] ?? 'Bad Request',
                  );
                case 401:
                  throw UnauthorizedException(
                    error.response?.data['message'] ?? 'Unauthorized',
                  );
                case 404:
                  throw NotFoundException(
                    error.response?.data['message'] ?? 'Not Found',
                  );
                case 500:
                  throw ServerException(
                    error.response?.data['message'] ?? 'Server Error',
                    error.response?.statusCode,
                  );
                default:
                  throw ServerException(
                    error.response?.data['message'] ?? 'Unknown Error',
                    error.response?.statusCode,
                  );
              }
            } else {
              if (error.type == DioErrorType.connectTimeout ||
                  error.type == DioErrorType.receiveTimeout ||
                  error.type == DioErrorType.sendTimeout) {
                throw TimeoutException('Request timeout');
              }
              throw NetworkException('No Internet Connection');
            }
          },
        ),
      );
  }

  Future<Response> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError {
      rethrow;
    }
  }

// Add other HTTP methods (post, put, delete, etc.) as needed
}
*/