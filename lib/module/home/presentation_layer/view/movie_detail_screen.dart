import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_layer/model/movie_model.dart';
import '../provider/movie_provider.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              movie.posterURL,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text("Failed to load image."));
              },
            ),
            const SizedBox(height: 16),
            Text(
              'IMDb ID: ${movie.imdbId}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                final isFavourite = movieProvider.favoriteMovies.any(
                  (element) => element.id == movie.id,
                );

                return ElevatedButton(
                  onPressed: () {
                    // Toggle the favourite status of the movie
                    movieProvider.toggleFavourite(movie);
                  },
                  child: Text(
                    isFavourite
                        ? 'Remove from Favourites'
                        : 'Add to Favourites',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
