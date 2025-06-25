import 'package:dartz/dartz.dart';
import 'package:movies_app/core/errors/exceptions.dart';
import 'package:movies_app/core/errors/failures.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/movie/data/models/movie_model.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_details.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MovieDetails>> getMovieDetails(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMovieDetail(movieId);
        return Right(result);
      } on AppException catch (e) {

        if (e is ServerException) return Left(ServerFailure(e.message, e.statusCode));
        if (e is NotFoundException) return Left(NotFoundFailure(e.message, e.statusCode));
        if (e is UnauthorizedException) return Left(UnauthorizedFailure(e.message, e.statusCode));
        if (e is BadRequestException) return Left(BadRequestFailure(e.message, e.statusCode));
        if (e is TimeoutException) return Left(TimeoutFailure(e.message));
        if (e is TooManyRequestsException) return Left(TooManyRequestsFailure(e.message, e.statusCode));
        if (e is ServiceUnavailableException) return Left(ServiceUnavailableFailure(e.message, e.statusCode));
        return Left(ServerFailure(e.message, e.statusCode)); // Fallback for other AppExceptions
      } catch (e) {

        return Left(ServerFailure('An unexpected error occurred while fetching movie details: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection. Please check your network.'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getUpcomingMovies();

        await localDataSource.cacheMovies(response.results);
        return Right(response.results);
      } on AppException catch (e) {

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

    }
  }
}



