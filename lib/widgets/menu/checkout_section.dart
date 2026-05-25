import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plaza_grill_tipuro/providers/cart_provider.dart';
import 'package:plaza_grill_tipuro/screens/payment_screen.dart';
import 'package:plaza_grill_tipuro/models/delivery_zone.dart';
import 'package:plaza_grill_tipuro/widgets/shared/custom_text_field.dart';
import 'package:plaza_grill_tipuro/widgets/shared/custom_dropdown_field.dart';
import 'package:plaza_grill_tipuro/widgets/menu/checkout_item_card.dart';
import 'package:plaza_grill_tipuro/widgets/menu/checkout_total_box.dart';
import 'package:plaza_grill_tipuro/widgets/menu/checkout_action_buttons.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class CheckoutSection extends StatefulWidget {
  const CheckoutSection({super.key});

  @override
  State<CheckoutSection> createState() => _CheckoutSectionState();
}

class _CheckoutSectionState extends State<CheckoutSection> {
  late final TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CartProvider>(context, listen: false);
    _referenceController = TextEditingController(text: provider.referencePoint);
    _referenceController.addListener(() {
      provider.setReferencePoint(_referenceController.text);
    });
  }

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();

    // Sincronizar controlador si cambia externamente (ej: al vaciar carrito)
    if (_referenceController.text != provider.referencePoint) {
      _referenceController.value = TextEditingValue(
        text: provider.referencePoint,
        selection: TextSelection.collapsed(offset: provider.referencePoint.length),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Container(height: 1.5, color: AppTheme.darkText),
          const SizedBox(height: 20),

          if (provider.cartItems.isNotEmpty) ...[
            const Text(
              'RESUMEN DEL PEDIDO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkText,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...provider.cartItems.map((item) {
              return CheckoutItemCard(
                item: item,
                onDelete: () => provider.removeFromCart(item.cartItemId),
              );
            }),
            const SizedBox(height: 20),
          ],

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SUBTOTAL',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '\$${provider.subtotalUsd.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Delivery Zone
          CustomDropdownField<DeliveryZone>(
            labelText: 'ZONA DE DELIVERY',
            hintText: 'Selecciona una zona...',
            value: provider.selectedZone,
            items: provider.deliveryZones,
            itemBuilder: (zone) => Text(
              '${zone.name} (${zone.price})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkText,
              ),
            ),
            onChanged: (zone) => provider.setDeliveryZone(zone),
          ),
          const SizedBox(height: 20),

          // Reference point
          CustomTextField(
            controller: _referenceController,
            labelText: 'PUNTO DE REFERENCIA',
            hintText: 'Ej: Casa blanca al lado del mercado...',
          ),
          const SizedBox(height: 24),

          // Total Box
          CheckoutTotalBox(
            totalUsd: provider.totalUsd,
            totalVes: provider.totalVes,
          ),
          const SizedBox(height: 20),

          // Action Buttons
          CheckoutActionButtons(
            hasItems: provider.hasItems,
            onSendWhatsApp: () async {
              final url = Uri.parse(provider.whatsappUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            onPayOnline: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
