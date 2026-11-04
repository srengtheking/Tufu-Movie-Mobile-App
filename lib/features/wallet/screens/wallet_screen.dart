import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/movie_card.dart';
import '../../../widgets/section_title.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Wallet'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CoinIcon(size: 48),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available coins',
                        style: TextStyle(color: p.textSecondary, fontSize: 13),
                      ),
                      Text(
                        '${wallet.balance}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SectionTitle(
            title: 'Buy coins',
            padding: EdgeInsets.fromLTRB(0, 28, 0, 14),
          ),
          for (final pack in WalletProvider.packs) ...[
            _PackTile(pack: pack),
            const SizedBox(height: 12),
          ],
          const SectionTitle(
            title: 'History',
            padding: EdgeInsets.fromLTRB(0, 18, 0, 4),
          ),
          if (wallet.history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No transactions yet.',
                style: TextStyle(color: p.textMuted),
              ),
            )
          else
            for (final tx in wallet.history)
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: p.divider)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          tx.title,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Text(
                        tx.amount > 0 ? '+${tx.amount}' : '${tx.amount}',
                        style: TextStyle(
                          color: tx.amount > 0
                              ? const Color(0xFF3DBE6C)
                              : p.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const CoinIcon(size: 18),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _PackTile extends StatelessWidget {
  final CoinPack pack;

  const _PackTile({required this.pack});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CoinIcon(size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pack.coins} coins',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  pack.bonus > 0 ? '+${pack.bonus} bonus coins' : 'No bonus',
                  style: TextStyle(color: p.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          PrimaryButton(
            label: pack.price,
            expand: false,
            height: 40,
            fontSize: 15,
            onPressed: () => context.push('/payment/${pack.id}'),
          ),
        ],
      ),
    );
  }
}
