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

  // Fetches upcoming movies and updates state
  Future<void> fetchUpcomingMovies() async {
    _isLoading = true;
    _error = null; // Clear previous errors
    notifyListeners();

    final result = await getUpcomingMovies(); // Call the use case

    // Handle the Either result: success (Right) or failure (Left)
    result.fold(
          (failure) {
        _error = failure.message; // Set error message from Failure
        _movies = []; // Clear movies on error
      },
          (movies) {
        _movies = movies; // Update movies list on success
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  // Fetches details for a specific movie and updates state
  Future<void> fetchMovieDetails(int movieId) async {
    _isLoading = true;
    _error = null; // Clear previous errors
    _selectedMovie = null; // Clear previous movie details
    notifyListeners();

    final result = await getMovieDetails(movieId); // Call the use case

    // Handle the Either result
    result.fold(
          (failure) {
        _error = failure.message; // Set error message
        _selectedMovie = null;
      },
          (movieDetails) {
        _selectedMovie = movieDetails; // Set movie details on success
      },
    );
    _isLoading = false;
    notifyListeners();
  }
}


/*
import 'package:flutter/material.dart';
import 'package:movies_app/features/movie/presentation/providers/movie_provider.dart' as remoteDataSource;
// import '../../domain/entities/movie.dart';
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

    try {
      _movies = await getUpcomingMovies();
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMovieDetails(int movieId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedMovie = await getMovieDetails(movieId);
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
*/


/*
class MovieProvider with ChangeNotifier {
  final GetUpcomingMovies getUpcomingMovies;

  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _error;

  MovieProvider({required this.getUpcomingMovies});

  List<Movie> get movies => _movies;
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
        _isLoading = false;
        notifyListeners();
      },
          (movies) {
        _movies = movies;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
*/
