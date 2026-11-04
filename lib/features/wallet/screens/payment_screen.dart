import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/section_title.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_widgets.dart';

class PaymentScreen extends StatefulWidget {
  final String packId;

  const PaymentScreen({super.key, required this.packId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _method = 0;
  bool _paying = false;

  CoinPack get _pack => WalletProvider.packs.firstWhere(
    (p) => p.id == widget.packId,
    orElse: () => WalletProvider.packs.first,
  );

  Future<void> _pay() async {
    setState(() => _paying = true);
    await context.read<WalletProvider>().topUp(
      _pack,
      WalletProvider.paymentMethods[_method],
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_pack.total} coins added to your wallet')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final pack = _pack;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Payment'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: [
                  SummaryCard(
                    children: [
                      SummaryRow(
                        label: 'Coin pack',
                        value: '${pack.coins} coins',
                        coin: true,
                      ),
                      SummaryRow(label: 'Bonus', value: '+${pack.bonus} coins'),
                      const Divider(height: 16),
                      SummaryRow(label: 'Total', value: pack.price),
                    ],
                  ),
                  const SectionTitle(
                    title: 'Payment method',
                    padding: EdgeInsets.fromLTRB(0, 28, 0, 14),
                  ),
                  for (final (i, method)
                      in WalletProvider.paymentMethods.indexed) ...[
                    _MethodTile(
                      label: method,
                      selected: i == _method,
                      onTap: () => setState(() => _method = i),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: PrimaryButton(
                label: 'Pay ${pack.price}',
                loading: _paying,
                onPressed: _pay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? AppColors.brand : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppColors.brand : p.textMuted,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: selected
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.brand,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 15)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
