

import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies_app/features/movie/data/models/movie_model.dart'; // Ensure Movie is imported
import 'dart:convert'; // For JSON encoding/decoding

import '../../../../core/errors/exceptions.dart'; // Import for CacheException

abstract class MovieLocalDataSource {
  Future<void> cacheMovies(List<Movie> movies);
  Future<List<Movie>> getCachedMovies();
  Future<void> clearCachedMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_MOVIES_KEY = 'CACHED_MOVIES';

  MovieLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheMovies(List<Movie> movies) async {
    try {
      final String jsonString = json.encode(movies.map((movie) => movie.toJson()).toList());
      await sharedPreferences.setString(CACHED_MOVIES_KEY, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache movies: $e');
    }
  }

  @override
  Future<List<Movie>> getCachedMovies() async {
    try {
      final String? jsonString = sharedPreferences.getString(CACHED_MOVIES_KEY);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => Movie.fromJson(json)).toList();
      } else {
        return []; // No cached movies found
      }
    } catch (e) {
      throw CacheException('Failed to get cached movies: $e');
    }
  }

  @override
  Future<void> clearCachedMovies() async {
    try {
      await sharedPreferences.remove(CACHED_MOVIES_KEY);
    } catch (e) {
      throw CacheException('Failed to clear cached movies: $e');
    }
  }
}

