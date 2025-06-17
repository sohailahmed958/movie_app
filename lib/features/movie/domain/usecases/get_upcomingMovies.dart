import 'package:dartz/dartz.dart'; // Import dartz
import '../../../../core/errors/failures.dart'; // Import Failure
import '../../data/models/movie_model.dart';
import '../repositories/movie_repository.dart';

class GetUpcomingMovies {
  final MovieRepository repository;

  GetUpcomingMovies(this.repository);

  // Returns an Either type to handle success or failure
  Future<Either<Failure, List<Movie>>> call() async {
    return await repository.getUpcomingMovies();
  }
}

