import 'package:dartz/dartz.dart';
import 'package:movies_app/core/errors/exceptions.dart';
import 'package:movies_app/core/errors/failures.dart';
import 'package:movies_app/core/network/network_info.dart';
import 'package:movies_app/features/movie/data/models/movie_model.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

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
        return Left(ServerFailure('An unexpected error occurred during search: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection for search.'));
    }
  }
}