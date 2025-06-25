import 'package:flutter/material.dart';
import '../../../movie/data/models/movie_model.dart';
import '../../domain/usecases/search_movies.dart';

class SearchProvider with ChangeNotifier {
  final SearchMovies searchMovies;

  SearchProvider({required this.searchMovies});

  List<Movie> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;

  bool _hasSearched = false;
  bool get hasSearched => _hasSearched;

  void setSearched(bool value) {
    _hasSearched = value;
    notifyListeners();
  }

  Future<void> search(String query) async {

    if (query.isEmpty) {
      _searchResults = [];
      _searchError = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    final result = await searchMovies(query);

    result.fold(
          (failure) {
        _searchError = failure.message;
        _searchResults = [];
      },
          (movies) {
        _searchResults = movies;
      },
    );
    _isSearching = false;
    notifyListeners();
  }
}

