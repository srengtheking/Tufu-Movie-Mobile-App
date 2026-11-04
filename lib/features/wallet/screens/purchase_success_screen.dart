import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/fill_scroll_view.dart';
import '../../../widgets/movie_card.dart';
import '../../movies/data/sample_movies.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_widgets.dart';

class PurchaseSuccessScreen extends StatelessWidget {
  final String movieId;

  const PurchaseSuccessScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final movie = SampleMovies.byId(movieId);
    final balance = context.watch<WalletProvider>().balance;

    return Scaffold(
      body: SafeArea(
        child: FillScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              const Center(
                child: StatusBadge(icon: Icons.check_rounded, success: true),
              ),
              const SizedBox(height: 28),
              const Text(
                'Purchase complete',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                '${movie.title} is now in your library.',
                textAlign: TextAlign.center,
                style: TextStyle(color: p.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Balance', style: TextStyle(color: p.textSecondary)),
                  const SizedBox(width: 10),
                  const CoinIcon(size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '$balance',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Spacer(flex: 4),
              PrimaryButton(
                label: 'Watch now',
                onPressed: () => context.pushReplacement('/watch/${movie.id}'),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Back to wallet',
                onPressed: () => context.pushReplacement('/wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
