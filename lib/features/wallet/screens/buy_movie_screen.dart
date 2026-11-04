import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/movie_card.dart';
import '../../movies/data/sample_movies.dart';
import '../providers/wallet_provider.dart';

class BuyMovieScreen extends StatelessWidget {
  final String movieId;

  const BuyMovieScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final movie = SampleMovies.byId(movieId);
    final wallet = context.watch<WalletProvider>();

    void buy() {
      if (wallet.buy(movie)) {
        context.pushReplacement('/purchase-success/${movie.id}');
      } else {
        context.push('/not-enough-coins/${movie.id}');
      }
    }

    return Scaffold(
      backgroundColor: p.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: movie.backdropUrl,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            color: Colors.black.withValues(alpha: 0.35),
            colorBlendMode: BlendMode.darken,
            errorWidget: (_, _, _) => const SizedBox.shrink(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: AppBackButton(filled: true),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: p.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                24,
                20,
                12 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 90,
                          height: 135,
                          color: p.card,
                          child: CachedNetworkImage(
                            imageUrl: movie.posterUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${movie.year} · ${movie.duration}',
                              style: TextStyle(
                                color: p.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const CoinIcon(size: 26),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    '${movie.price} coins',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: p.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Your balance',
                            style: TextStyle(color: p.textSecondary),
                          ),
                        ),
                        Text(
                          '${wallet.balance}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        const CoinIcon(size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(label: 'Buy with coins', onPressed: buy),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Top up coins',
                    onPressed: () => context.push('/wallet'),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: p.textSecondary, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
