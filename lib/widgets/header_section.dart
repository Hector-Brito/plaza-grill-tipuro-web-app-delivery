import 'package:flutter/material.dart';
import '../providers/order_provider.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        border: Border(bottom: BorderSide(color: Color(0xFF1B1B1B), width: 2)),
      ),
      child: Column(
        children: [
          // Top bar: Logo + Rate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hamburger icon placeholder
              const Icon(
                Icons.fastfood_rounded,
                color: Color(0xFF1B1B1B),
                size: 28,
              ),
              // Brand name
              const Expanded(
                child: Text(
                  'PLAZA GRILL TIPURO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB80035),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              // Rate badge inline
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '\$1 = ${OrderProvider.exchangeRate.toStringAsFixed(2)} Bs',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1B1B),
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
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1B1B1B), width: 1),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: Color(0xFF1B1B1B),
                ),
                SizedBox(width: 8),
                Text(
                  'Horario: 5:00pm a 11:30pm',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Daily rate badge
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFBBF24),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFF1B1B1B), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.currency_exchange,
                    size: 14,
                    color: Color(0xFF1B1B1B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'TASA DEL DÍA: ${OrderProvider.exchangeRate.toStringAsFixed(2)} BS',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B1B1B),
                      letterSpacing: 0.5,
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
