import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/movie_provider.dart';
import '../widgets/movie_list_widget.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            final favouriteMovies = movieProvider.favoriteMovies;

            if (favouriteMovies.isEmpty) {
              return const Center(child: Text('No favourites added yet.'));
            }

            return MovieListWidget(movies: favouriteMovies);
          },
        ),
      ),
    );
  }
}
