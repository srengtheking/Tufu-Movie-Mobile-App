import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/movie_card.dart';
import '../auth/providers/auth_provider.dart';
import '../wallet/providers/wallet_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _comingSoon(BuildContext context, String what) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$what is coming soon.')));
  }

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.palette.surface,
        title: const Text('Sign out?'),
        content: const Text('You will need to sign in again to watch.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: ctx.palette.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Sign out', style: TextStyle(color: ctx.palette.link)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    // The router guard returns to Sign in once the session is cleared.
    await context.read<AuthProvider>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final balance = context.watch<WalletProvider>().balance;
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
          children: [
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: p.card,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 36,
                    color: p.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name.isNotEmpty == true
                            ? user!.name
                            : 'Tufu member',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: p.textMuted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ProfileTile(
              title: 'Wallet',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CoinIcon(size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '$balance',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              onTap: () => context.push('/wallet'),
            ),
            _ProfileTile(
              title: 'My List',
              onTap: () => _comingSoon(context, 'My List'),
            ),
            _ProfileTile(
              title: 'Downloads',
              onTap: () => context.go('/downloads'),
            ),
            _ProfileTile(
              title: 'Subscription',
              onTap: () => _comingSoon(context, 'Subscription'),
            ),
            _ProfileTile(
              title: 'Settings',
              onTap: () => _comingSoon(context, 'Settings'),
            ),
            _ProfileTile(
              title: 'Help',
              onTap: () => _comingSoon(context, 'Help'),
            ),
            _ProfileTile(
              title: 'Sign out',
              color: p.link,
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final Widget? trailing;

  const _ProfileTile({
    required this.title,
    required this.onTap,
    this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: p.divider)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, color: color ?? p.textPrimary),
                ),
              ),
              ?trailing,
              Icon(Icons.chevron_right_rounded, color: color ?? p.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
