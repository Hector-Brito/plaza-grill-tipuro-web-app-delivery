import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class PaymentAmountDisplay extends StatelessWidget {
  final double totalVes;
  final double totalUsd;

  const PaymentAmountDisplay({
    super.key,
    required this.totalVes,
    required this.totalUsd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryYellow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.darkText, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'MONTO A PAGAR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkText,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${totalVes.toStringAsFixed(2)} Bs',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkText,
            ),
          ),
          Text(
            '(\$${totalUsd.toStringAsFixed(2)})',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
