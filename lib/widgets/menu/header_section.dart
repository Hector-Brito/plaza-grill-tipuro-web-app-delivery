import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/providers/cart_provider.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(bottom: BorderSide(color: AppTheme.darkText, width: 2)),
      ),
      child: Column(
        children: [
          // Top bar: Logo + Rate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hamburger icon placeholder
              // const Icon(
              //   Icons.fastfood_rounded,
              //   color: AppTheme.darkText,
              //   size: 28,
              // ),
              // Brand name
              const Expanded(
                child: Text(
                  'PLAZA GRILL TIPURO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryRed,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              // Rate badge inline
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryYellow,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppTheme.darkText, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.currency_exchange,
                        size: 14,
                        color: AppTheme.darkText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'TASA DEL DÍA: ${CartProvider.exchangeRate.toStringAsFixed(2)} BS',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Hours badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.darkText, width: 1),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppTheme.darkText,
                ),
                SizedBox(width: 8),
                Text(
                  'Horario: 5:00pm a 11:30pm',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
