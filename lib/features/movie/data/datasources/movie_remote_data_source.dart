
import 'package:movies_app/core/network/dio_client.dart'; // Use DioClient
import 'package:movies_app/features/movie/data/models/movie_model.dart';
import '../models/movie_details.dart';

abstract class MovieRemoteDataSource {
  Future<UpcomingMoviesResponse> getUpcomingMovies();
  Future<MovieDetails> getMovieDetail(int id);
  Future<UpcomingMoviesResponse> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient dioClient;

  MovieRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UpcomingMoviesResponse> getUpcomingMovies() async {
    final response = await dioClient.get(
      '/movie/upcoming',
    );
    return UpcomingMoviesResponse.fromJson(response.data);
  }

  @override
  Future<MovieDetails> getMovieDetail(int id) async {
    final response = await dioClient.get(
      '/movie/$id',
    );
    return MovieDetails.fromJson(response.data);
  }

  @override
  Future<UpcomingMoviesResponse> searchMovies(String query) async {
    final response = await dioClient.get(
      '/search/movie',
      queryParameters: {'query': query},
    );
    return UpcomingMoviesResponse.fromJson(response.data);
  }
}
