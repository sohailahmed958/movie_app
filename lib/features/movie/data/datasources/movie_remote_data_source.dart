// features/movie/data/datasources/movie_remote_data_source.dart


import 'package:movies_app/core/network/dio_client.dart'; // Use DioClient
import 'package:movies_app/features/movie/data/models/movie_model.dart';
import '../models/movie_details.dart';

abstract class MovieRemoteDataSource {
  Future<UpcomingMoviesResponse> getUpcomingMovies();
  Future<MovieDetails> getMovieDetail(int id);
  Future<UpcomingMoviesResponse> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient dioClient; // Dependency changed to DioClient

  MovieRemoteDataSourceImpl({required this.dioClient}); // Constructor updated

  @override
  Future<UpcomingMoviesResponse> getUpcomingMovies() async {
    final response = await dioClient.get(
      '/movie/upcoming',
      // API key is now handled by DioClient's interceptor, no need to pass it here
    );
    // Directly parse the response data into UpcomingMoviesResponse
    return UpcomingMoviesResponse.fromJson(response.data);
  }

  @override
  Future<MovieDetails> getMovieDetail(int id) async {
    final response = await dioClient.get(
      '/movie/$id',
      // API key handled by DioClient
    );
    return MovieDetails.fromJson(response.data);
  }

  @override
  Future<UpcomingMoviesResponse> searchMovies(String query) async {
    final response = await dioClient.get(
      '/search/movie',
      queryParameters: {'query': query}, // Pass the search query
      // API key handled by DioClient
    );
    return UpcomingMoviesResponse.fromJson(response.data);
  }
}
