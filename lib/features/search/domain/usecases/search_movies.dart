import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../movie/data/models/movie_model.dart';
import '../repositories/search_repository.dart';

class SearchMovies {
  final SearchRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(String query) async {
    return await repository.searchMovies(query);
  }
}

