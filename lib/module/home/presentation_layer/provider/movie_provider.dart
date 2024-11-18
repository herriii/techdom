import 'package:flutter/material.dart';

import '../../data_layer/data_sources/movie_database.dart';
import '../../data_layer/data_sources/movie_service.dart';
import '../../data_layer/model/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  final MovieApiService movieApiService;
  final MovieDatabase movieDatabase;

  List<Movie> _allMovies = [];
  List<Movie> get allMovies => _allMovies;

  List<Movie> _favoriteMovies = [];
  List<Movie> get favoriteMovies => _favoriteMovies;

  MovieProvider({required this.movieApiService, required this.movieDatabase});

  // Search Movies
  void searchMovies(String query) {
    _favoriteMovies = _allMovies
        .where(
            (movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // Load Movies from API and Database
  Future<void> loadMovies() async {
    try {
      // Attempt to load movies from the API
      _allMovies = await movieApiService.fetchMovies();
      notifyListeners();
      // Cache in local DB only if not already present
      for (var movie in _allMovies) {
        final exists = await movieDatabase.checkMovieExists(movie.id);
        notifyListeners();
        if (!exists) {
          await movieDatabase.insertMovie(movie);
          notifyListeners();
        }
      }
      notifyListeners(); // Notify listeners after successfully loading movies
    } catch (_) {
      // If API fails, load movies from local database
      try {
        _allMovies = await movieDatabase.getAllMovies();
        notifyListeners(); // Notify listeners after loading from local DB
      } catch (error) {
        throw Exception(
            'Failed to load movies from both API and local database.');
      }
    }
  }

  // Load favourite movies from local DB
  Future<void> loadFavouriteMovies() async {
    try {
      _favoriteMovies = await movieDatabase.getAllFavouriteMovies();
      notifyListeners(); // Notify listeners after successfully loading favourites
    } catch (error) {
      throw Exception('Failed to load favourite movies.');
    }
  }

  // Toggle Favourite status
  Future<void> toggleFavourite(Movie movie) async {
    try {
      final isFavourite =
          await movieDatabase.checkFavouriteMovieExists(movie.id);
      if (isFavourite) {
        await movieDatabase.deleteFavouriteMovie(movie.id);
      } else {
        await movieDatabase.insertFavouriteMovie(movie);
      }

      // Reload favourite movies to reflect changes
      await loadFavouriteMovies();
    } catch (e) {
      throw Exception('Failed to update favourite status.');
    }
  }
}
