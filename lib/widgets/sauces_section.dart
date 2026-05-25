import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class SaucesSection extends StatelessWidget {
  const SaucesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SALSAS Y EXTRAS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB80035),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(height: 1, color: const Color(0xFFE5BDBE)),
              ],
            ),
          ),
          // Sauces list
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1B1B1B), width: 1),
            ),
            child: Column(
              children: List.generate(provider.sauces.length, (index) {
                final sauce = provider.sauces[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < provider.sauces.length - 1 ? 4 : 0,
                  ),
                  child: InkWell(
                    onTap: () => provider.toggleSauce(index),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: sauce.selected,
                            onChanged: (_) => provider.toggleSauce(index),
                            activeColor: const Color(0xFFB80035),
                            side: const BorderSide(
                              color: Color(0xFF1B1B1B),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            sauce.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF1B1B1B),
                            ),
                          ),
                        ),
                        if (sauce.price > 0)
                          Text(
                            '+\$${sauce.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFB80035),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
