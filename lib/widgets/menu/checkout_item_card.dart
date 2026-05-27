import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/models/cart_item.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

import 'package:plaza_grill_tipuro/widgets/menu/customization_bottom_sheet.dart';

class CheckoutItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDelete;

  const CheckoutItemCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CustomizationBottomSheet.show(context, item.menuItem, cartItem: item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.menuItem.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        '${item.quantity}x',
                        style: const TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ],
                ),
                if (item.selectedProtein != null)
                  Text(
                    'Proteína: ${item.selectedProtein!.name}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                if (item.removedIngredients.isNotEmpty)
                  Text(
                    'Sin: ${item.removedIngredients.map((e) => e.name).join(', ')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                if (item.selectedExtras.isNotEmpty)
                  ...item.selectedExtras.map(
                    (e) => Text(
                      '+ Extra: ${e.name} (+\$${e.price.toStringAsFixed(2)})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                if (item.specialNote.trim().isNotEmpty)
                  Text(
                    'Nota: ${item.specialNote}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Delete button
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppTheme.primaryRed,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onDelete,
          ),
        ],
      ),
    ),
  );
}
}
