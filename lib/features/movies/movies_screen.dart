import 'package:flutter/material.dart';

import '../../widgets/app_buttons.dart';
import '../../widgets/movie_card.dart';
import 'data/sample_movies.dart';

/// "Movies" filter from Home: the full catalogue as a grid.
class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = SampleMovies.all;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Movies'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, i) => MovieCard(movie: movies[i]),
      ),
    );
  }
}
