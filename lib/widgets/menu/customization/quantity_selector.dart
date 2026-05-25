import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onTapQuantity;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTapQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.darkText),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove,
                  color: AppTheme.primaryRed,
                ),
                onPressed: onDecrement,
              ),
              GestureDetector(
                onTap: onTapQuantity,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: AppTheme.darkText,
                ),
                onPressed: onIncrement,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
