import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/movie_model.dart';
import '../repositories/movie_repository.dart';

class GetUpcomingMovies {
  final MovieRepository repository;

  GetUpcomingMovies(this.repository);


  Future<Either<Failure, List<Movie>>> call() async {
    return await repository.getUpcomingMovies();
  }
}

