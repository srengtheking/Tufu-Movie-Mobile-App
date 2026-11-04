import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../features/movies/data/movie.dart';

/// Poster tile with the title overlaid on the bottom-left, as in the designs.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final double? width;

  const MovieCard({super.key, required this.movie, this.width});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: p.card,
          child: InkWell(
            onTap: () => context.push('/movie/${movie.id}'),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: movie.posterUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 200),
                  placeholder: (_, _) => const SizedBox.shrink(),
                  errorWidget: (_, _, _) => const SizedBox.shrink(),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xCC000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
                if (!movie.isFree)
                  const Positioned(top: 8, right: 8, child: CoinIcon(size: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal rail of posters used on Home / Detail.
class MovieRail extends StatelessWidget {
  final List<Movie> movies;
  final double itemWidth;
  final double height;

  const MovieRail({
    super.key,
    required this.movies,
    this.itemWidth = 120,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => MovieCard(movie: movies[i], width: itemWidth),
      ),
    );
  }
}

/// Red "T" coin.
class CoinIcon extends StatelessWidget {
  final double size;

  const CoinIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.brand,
        shape: BoxShape.circle,
      ),
      child: Text(
        'T',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.6,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}
