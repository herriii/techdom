import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techdome/module/home/presentation_layer/widgets/movie_item_widget.dart';

import '../provider/movie_provider.dart';
import '../widgets/movie_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load movies on screen initialization
    Provider.of<MovieProvider>(context, listen: false).loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Movies"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              String? query = await showSearch<String?>(
                  context: context, delegate: MovieSearchDelegate());
              if (query != null) {
                Provider.of<MovieProvider>(context, listen: false)
                    .searchMovies(query);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favourites');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            if (movieProvider.allMovies.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return MovieListWidget(movies: movieProvider.allMovies);
          },
        ),
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Clear button to reset the search query
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          // Clear search results when query is cleared
          Provider.of<MovieProvider>(context, listen: false).searchMovies('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Back button to close the search
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Only trigger a search if the query changes
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    if (movieProvider.favoriteMovies.isEmpty) {
      // Perform the search and update state only if needed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        movieProvider.searchMovies(query);
      });
    }

    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        final filteredMovies = movieProvider.favoriteMovies;
        if (filteredMovies.isNotEmpty) {
          return ListView.builder(
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];
              return MovieItemWidget(movie: movie);
            },
          );
        } else {
          return Center(
            child: Text(
              'No movies found matching "$query".',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Update suggestions only when query changes
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    if (query.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        movieProvider.searchMovies(query);
      });
    }

    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        final suggestions = movieProvider.favoriteMovies;

        if (suggestions.isEmpty && query.isEmpty) {
          return const Center(
            child: Text(
              'Start typing to search movies...',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final movie = suggestions[index];
            return MovieItemWidget(movie: movie);
          },
        );
      },
    );
  }
}
