import 'package:dartz/dartz.dart'; // For Either
import 'package:movies_app/core/errors/exceptions.dart';
import 'package:movies_app/core/errors/failures.dart';
import 'package:movies_app/core/network/network_info.dart'; // Import NetworkInfo
import 'package:movies_app/features/movie/data/models/movie_model.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_details.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo; // Added NetworkInfo dependency

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo, // Updated constructor
  });

  @override
  Future<Either<Failure, MovieDetails>> getMovieDetails(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMovieDetail(movieId);
        return Right(result);
      } on AppException catch (e) {
        // Map caught exceptions to appropriate failures
        if (e is ServerException) return Left(ServerFailure(e.message, e.statusCode));
        if (e is NotFoundException) return Left(NotFoundFailure(e.message, e.statusCode));
        if (e is UnauthorizedException) return Left(UnauthorizedFailure(e.message, e.statusCode));
        if (e is BadRequestException) return Left(BadRequestFailure(e.message, e.statusCode));
        if (e is TimeoutException) return Left(TimeoutFailure(e.message));
        if (e is TooManyRequestsException) return Left(TooManyRequestsFailure(e.message, e.statusCode));
        if (e is ServiceUnavailableException) return Left(ServiceUnavailableFailure(e.message, e.statusCode));
        return Left(ServerFailure(e.message, e.statusCode)); // Fallback for other AppExceptions
      } catch (e) {
        // Catch any other unexpected errors
        return Left(ServerFailure('An unexpected error occurred while fetching movie details: ${e.toString()}'));
      }
    } else {
      // Return network failure if no internet connection
      return const Left(NetworkFailure('No internet connection. Please check your network.'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getUpcomingMovies();
        // Cache the fetched movies locally
        await localDataSource.cacheMovies(response.results);
        return Right(response.results);
      } on AppException catch (e) {
        // Map caught exceptions to appropriate failures
        if (e is ServerException) return Left(ServerFailure(e.message, e.statusCode));
        if (e is NotFoundException) return Left(NotFoundFailure(e.message, e.statusCode));
        if (e is UnauthorizedException) return Left(UnauthorizedFailure(e.message, e.statusCode));
        if (e is BadRequestException) return Left(BadRequestFailure(e.message, e.statusCode));
        if (e is TimeoutException) return Left(TimeoutFailure(e.message));
        if (e is TooManyRequestsException) return Left(TooManyRequestsFailure(e.message, e.statusCode));
        if (e is ServiceUnavailableException) return Left(ServiceUnavailableFailure(e.message, e.statusCode));
        return Left(ServerFailure(e.message, e.statusCode));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred while fetching upcoming movies: ${e.toString()}'));
      }
    } else {
      // If no internet, try to get from local cache
      try {
        final cachedMovies = await localDataSource.getCachedMovies();
        if (cachedMovies.isNotEmpty) {
          return Right(cachedMovies);
        } else {
          return const Left(NetworkFailure('No internet connection and no cached movies available.'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('Failed to retrieve cached movies: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.searchMovies(query);
        return Right(response.results);
      } on AppException catch (e) {
        // Map caught exceptions to appropriate failures
        if (e is ServerException) return Left(ServerFailure(e.message, e.statusCode));
        if (e is NotFoundException) return Left(NotFoundFailure(e.message, e.statusCode));
        if (e is UnauthorizedException) return Left(UnauthorizedFailure(e.message, e.statusCode));
        if (e is BadRequestException) return Left(BadRequestFailure(e.message, e.statusCode));
        if (e is TimeoutException) return Left(TimeoutFailure(e.message));
        if (e is TooManyRequestsException) return Left(TooManyRequestsFailure(e.message, e.statusCode));
        if (e is ServiceUnavailableException) return Left(ServiceUnavailableFailure(e.message, e.statusCode));
        return Left(ServerFailure(e.message, e.statusCode));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred during movie search: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection for search.'));
      // Search results are typically not cached locally in this pattern,
      // as they are dynamic based on the query.
    }
  }
}



