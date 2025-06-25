// features/movie/presentation/providers/movie_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/movie_details.dart';
import '../../data/models/movie_model.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/get_upcomingMovies.dart';

class MovieProvider with ChangeNotifier {
  final GetUpcomingMovies getUpcomingMovies;
  final GetMovieDetails getMovieDetails;

  MovieProvider({
    required this.getUpcomingMovies,
    required this.getMovieDetails,
  });

  List<Movie> _movies = [];
  MovieDetails? _selectedMovie;
  bool _isLoading = false;
  String? _error;

  List<Movie> get movies => _movies;
  MovieDetails? get selectedMovie => _selectedMovie;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> fetchUpcomingMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getUpcomingMovies();

    result.fold(
          (failure) {
        _error = failure.message;
        _movies = [];
      },
          (movies) {
        _movies = movies;
      },
    );
    _isLoading = false;
    notifyListeners();
  }


  Future<void> fetchMovieDetails(int movieId) async {
    _isLoading = true;
    _error = null;
    _selectedMovie = null;
    notifyListeners();

    final result = await getMovieDetails(movieId);


    result.fold(
          (failure) {
        _error = failure.message;
        _selectedMovie = null;
      },
          (movieDetails) {
        _selectedMovie = movieDetails;
      },
    );
    _isLoading = false;
    notifyListeners();
  }
}

