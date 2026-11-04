import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/section_title.dart';
import '../movies/data/movie.dart';
import '../movies/data/sample_movies.dart';
import '../wallet/providers/wallet_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  /// Owned / free titles play straight away; paid ones open the buy sheet.
  static void play(BuildContext context, Movie movie) {
    final owns = context.read<WalletProvider>().owns(movie);
    context.push(owns ? '/watch/${movie.id}' : '/buy/${movie.id}');
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final movie = SampleMovies.byId(movieId);
    final owns = context.watch<WalletProvider>().owns(movie);
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: p.surface),
                CachedNetworkImage(
                  imageUrl: movie.backdropUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const SizedBox.shrink(),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.55, 1],
                      colors: [Colors.transparent, p.background],
                    ),
                  ),
                ),
                Center(child: _PlayCircle(onTap: () => play(context, movie))),
                Positioned(
                  top: topInset + 12,
                  left: 12,
                  child: const AppBackButton(filled: true),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 14,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final meta in [
                      movie.year,
                      '★ ${movie.rating}',
                      movie.duration,
                      movie.genre,
                    ])
                      Text(
                        meta,
                        style: TextStyle(color: p.textSecondary, fontSize: 14),
                      ),
                    if (!movie.isFree && !owns)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CoinIcon(size: 16),
                          const SizedBox(width: 5),
                          Text(
                            '${movie.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: owns ? 'Play' : 'Buy & play',
                        height: 48,
                        onPressed: () => play(context, movie),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Download',
                        height: 48,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Downloads are coming soon.'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  movie.description,
                  style: TextStyle(
                    color: p.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SectionTitle(title: 'More like this'),
          MovieRail(
            movies: SampleMovies.moreLike(movie),
            itemWidth: 104,
            height: 156,
          ),
          SizedBox(height: 28 + MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}

class _PlayCircle extends StatelessWidget {
  final VoidCallback onTap;

  const _PlayCircle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      elevation: 6,
      shadowColor: Colors.black54,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 64,
          height: 64,
          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 38),
        ),
      ),
    );
  }
}
