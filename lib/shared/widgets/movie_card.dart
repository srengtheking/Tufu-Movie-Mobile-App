import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class MovieCard extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  final String year;
  final double rating;

  const MovieCard({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    required this.year,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/$id'),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.card,
                    child: const Icon(
                      Icons.movie,
                      size: 40,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(color: AppColors.secondary),
                ),
                const SizedBox(width: 8),
                Text(year, style: const TextStyle(color: AppColors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
