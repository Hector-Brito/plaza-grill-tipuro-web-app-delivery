import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class CheckoutTotalBox extends StatelessWidget {
  final double totalUsd;
  final double totalVes;

  const CheckoutTotalBox({
    super.key,
    required this.totalUsd,
    required this.totalVes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.darkText, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'TOTAL A PAGAR',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${totalUsd.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryRed,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${totalVes.toStringAsFixed(2)} Bs',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
