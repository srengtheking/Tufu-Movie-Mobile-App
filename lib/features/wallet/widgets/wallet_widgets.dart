import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/movie_card.dart';

/// Rounded summary card with label/value rows (Payment, Not enough coins).
class SummaryCard extends StatelessWidget {
  final List<Widget> children;

  const SummaryCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool coin;
  final Color? valueColor;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.coin = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: p.textSecondary, fontSize: 14),
            ),
          ),
          if (coin) ...[const CoinIcon(size: 18), const SizedBox(width: 8)],
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: valueColor ?? p.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Big circular badge at the top of the result screens.
class StatusBadge extends StatelessWidget {
  final IconData icon;
  final bool success;

  const StatusBadge({super.key, required this.icon, required this.success});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: success ? AppColors.brand : p.surface,
      ),
      child: Icon(
        icon,
        size: success ? 46 : 50,
        color: success ? Colors.white : p.link,
      ),
    );
  }
}
