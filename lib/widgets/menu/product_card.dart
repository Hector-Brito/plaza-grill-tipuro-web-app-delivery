import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:plaza_grill_tipuro/models/menu_item.dart';
import 'package:plaza_grill_tipuro/models/cart_item.dart';
import 'package:plaza_grill_tipuro/providers/cart_provider.dart';
import 'package:plaza_grill_tipuro/widgets/menu/customization_bottom_sheet.dart';
import 'package:plaza_grill_tipuro/widgets/shared/custom_snackbar.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class ProductCard extends StatelessWidget {
  final MenuItem item;

  const ProductCard({super.key, required this.item});

  void _handleAddToCart(BuildContext context) {
    if (item.isCustomizable || item.requiresProtein) {
      CustomizationBottomSheet.show(context, item);
    } else {
      // Add directly
      final cartItem = CartItem(
        cartItemId: const Uuid().v4(),
        menuItem: item,
        quantity: 1,
      );
      context.read<CartProvider>().addToCart(cartItem);
      CustomSnackBar.showSuccess(context, '${item.name} agregado al carrito');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.darkText, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '\$${item.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _handleAddToCart(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Agregar',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
                foregroundColor: AppTheme.darkText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppTheme.darkText, width: 1.5),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
