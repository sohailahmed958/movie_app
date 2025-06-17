import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart'; // Import dartz
import '../../../movie/data/models/movie_model.dart';
import '../../domain/usecases/search_movies.dart';
import '../../../../core/errors/failures.dart'; // Import Failure classes

class SearchProvider with ChangeNotifier {
  final SearchMovies searchMovies;

  SearchProvider({required this.searchMovies});

  List<Movie> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;

  Future<void> search(String query) async {
    // If query is empty, clear results and reset state
    if (query.isEmpty) {
      _searchResults = [];
      _searchError = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null; // Clear previous errors
    notifyListeners();

    final result = await searchMovies(query); // Call the search use case

    // Handle the Either result: success (Right) or failure (Left)
    result.fold(
          (failure) {
        _searchError = failure.message; // Set error message
        _searchResults = []; // Clear results on error
      },
          (movies) {
        _searchResults = movies; // Update search results on success
      },
    );
    _isSearching = false;
    notifyListeners();
  }
}

