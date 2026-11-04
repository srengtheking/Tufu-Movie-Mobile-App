import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/fill_scroll_view.dart';
import '../../movies/data/sample_movies.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_widgets.dart';

class NotEnoughCoinsScreen extends StatelessWidget {
  final String movieId;

  const NotEnoughCoinsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final movie = SampleMovies.byId(movieId);
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: SafeArea(
        top: false,
        child: FillScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const Center(
                child: StatusBadge(
                  icon: Icons.error_outline_rounded,
                  success: false,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Not enough coins',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Top up your wallet to buy ${movie.title}.',
                textAlign: TextAlign.center,
                style: TextStyle(color: p.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 24),
              SummaryCard(
                children: [
                  SummaryRow(
                    label: 'Price',
                    value: '${movie.price} coins',
                    coin: true,
                  ),
                  SummaryRow(
                    label: 'Your balance',
                    value: '${wallet.balance}',
                    coin: true,
                  ),
                  const Divider(height: 16),
                  SummaryRow(
                    label: 'Coins needed',
                    value: '${wallet.missingFor(movie)}',
                    coin: true,
                    valueColor: p.link,
                  ),
                ],
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Top up coins',
                onPressed: () => context.pushReplacement('/wallet'),
              ),
              const SizedBox(height: 12),
              SecondaryButton(label: 'Cancel', onPressed: () => context.pop()),
            ],
          ),
        ),
      ),
    );
  }
}
