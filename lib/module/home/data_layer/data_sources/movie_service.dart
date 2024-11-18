import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/movie_model.dart';

class MovieApiService {
  MovieApiService();

  // Fetch movies from the API
  Future<List<Movie>> fetchMovies() async {
    print("object");
    final response = await http
        .get(Uri.parse('https://api.sampleapis.com/movies/animation'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Filter movies locally for search functionality
  Future<List<Movie>> searchMovies(String query, List<Movie> allMovies) async {
    return allMovies
        .where(
            (movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
