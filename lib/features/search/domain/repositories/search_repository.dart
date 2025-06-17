import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../movie/data/models/movie_model.dart'; // Re-use Movie model

abstract class SearchRepository {
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
}