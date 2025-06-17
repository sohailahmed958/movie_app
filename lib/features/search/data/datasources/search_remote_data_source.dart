import 'package:movies_app/core/network/dio_client.dart';
import 'package:movies_app/features/movie/data/models/movie_model.dart'; // Re-use MovieModel

abstract class SearchRemoteDataSource {
  Future<UpcomingMoviesResponse> searchMovies(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UpcomingMoviesResponse> searchMovies(String query) async {
    final response = await dioClient.get(
      '/search/movie',
      queryParameters: {'query': query},
    );
    return UpcomingMoviesResponse.fromJson(response.data);
  }
}