import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class DioClient {
  final Dio dio;
  final String baseUrl;

  DioClient({required this.dio, required this.baseUrl}) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: AppConstants.connectTimeoutInSeconds)
      ..options.receiveTimeout = const Duration(seconds: AppConstants.receiveTimeoutInSeconds)
      ..options.responseType = ResponseType.json;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = dotenv.env['TMDB_API_KEY'];
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response != null) {
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
            if (error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout) {
              throw TimeoutException('Request timeout. Please try again.');
            } else if (error.type == DioExceptionType.connectionError) {
              throw NetworkException('No internet connection. Please check your network settings.');
            } else if (error.type == DioExceptionType.badResponse) {
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
      rethrow;
    }
  }

}
