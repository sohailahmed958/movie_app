import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/movie_details.dart';
import '../../data/models/movie_model.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getUpcomingMovies();
  Future<Either<Failure, MovieDetails>> getMovieDetails(int movieId);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
}

