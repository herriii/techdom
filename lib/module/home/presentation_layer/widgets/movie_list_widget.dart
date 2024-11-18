import 'package:flutter/material.dart';

import '../../data_layer/model/movie_model.dart';
import 'movie_item_widget.dart';

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;

  const MovieListWidget({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieItemWidget(movie: movies[index]);
      },
    );
  }
}
