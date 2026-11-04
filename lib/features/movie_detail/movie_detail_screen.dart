import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: ListView(
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w780/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 300,
              color: AppColors.card,
              child: const Icon(Icons.movie, size: 60),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The Dark Knight',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  '2008 • Action • Crime • 2h 32m',
                  style: TextStyle(color: AppColors.secondary),
                ),
                const SizedBox(height: 15),
                const Text(
                  'When the menace known as the Joker wreaks havoc, '
                  'Batman must accept one of the greatest tests of his '
                  'ability to fight injustice.',
                  style: TextStyle(color: AppColors.secondary, height: 1.6),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Video player will be connected next.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Watch Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Episodes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...List.generate(
                  5,
                  (index) => ListTile(
                    leading: const Icon(Icons.play_circle_outline),
                    title: Text('Episode ${index + 1}'),
                    subtitle: const Text('Available to watch'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
