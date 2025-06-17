import 'package:dartz/dartz.dart'; // Import dartz
import '../../../../core/errors/failures.dart'; // Import Failure
import '../../data/models/movie_details.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  // Returns an Either type to handle success or failure
  Future<Either<Failure, MovieDetails>> call(int movieId) async {
    return await repository.getMovieDetails(movieId);
  }
}

