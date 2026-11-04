import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/pill_chip.dart';
import '../../widgets/section_title.dart';
import '../movies/data/movie.dart';
import '../movies/data/sample_movies.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _filters = ['All', 'Movies', 'Series', 'Genres'];
  int _filter = 0;

  void _onFilter(int i) {
    if (i == 1) {
      context.push('/movies');
      return;
    }
    setState(() => _filter = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
                child: Row(
                  children: [
                    const AppLogo(height: 22),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Search',
                      onPressed: () => context.go('/search'),
                      icon: const Icon(Icons.search_rounded, size: 28),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: PillChipRow(
                labels: _filters,
                selected: _filter,
                onSelected: _onFilter,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _FeaturedBanner(movie: SampleMovies.featured),
            ),
            const SliverToBoxAdapter(
              child: SectionTitle(title: 'Trending now'),
            ),
            SliverToBoxAdapter(
              child: MovieRail(
                movies: SampleMovies.trending,
                itemWidth: 120,
                height: 180,
              ),
            ),
            const SliverToBoxAdapter(
              child: SectionTitle(title: 'New releases'),
            ),
            SliverToBoxAdapter(
              child: MovieRail(
                movies: SampleMovies.newReleases,
                itemWidth: 120,
                height: 180,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  final Movie movie;

  const _FeaturedBanner({required this.movie});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AspectRatio(
        aspectRatio: 0.74,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: p.surface,
            child: InkWell(
              onTap: () => context.push('/movie/${movie.id}'),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: movie.posterUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => const SizedBox.shrink(),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.35, 1],
                        colors: [Colors.transparent, Color(0xE6000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${movie.year}  ·  ${movie.genre}  ·  ${movie.duration}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            PrimaryButton(
                              label: 'Play',
                              expand: false,
                              height: 46,
                              onPressed: () =>
                                  context.push('/movie/${movie.id}'),
                            ),
                            SecondaryButton(
                              label: 'My List',
                              expand: false,
                              height: 46,
                              background: const Color(0xCC2A2A2A),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${movie.title} added to My List',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
