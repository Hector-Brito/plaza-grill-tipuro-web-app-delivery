import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/order_provider.dart';
import '../screens/payment_screen.dart';

class CheckoutSection extends StatelessWidget {
  const CheckoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Container(height: 1.5, color: const Color(0xFF1B1B1B)),
          const SizedBox(height: 20),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SUBTOTAL',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1B1B),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '\$${provider.subtotalUsd.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B1B1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Delivery Zone
          const Text(
            'ZONA DE DELIVERY',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B1B1B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1B1B1B), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                hint: const Text(
                  'Selecciona una zona...',
                  style: TextStyle(fontSize: 14, color: Color(0xFF906F70)),
                ),
                value: provider.selectedZone,
                items: provider.deliveryZones.map((zone) {
                  return DropdownMenuItem(
                    value: zone,
                    child: Text(
                      '${zone.name} (${zone.price})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (zone) => provider.setDeliveryZone(zone),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Reference point
          const Text(
            'PUNTO DE REFERENCIA',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B1B1B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1B1B1B), width: 1),
            ),
            child: TextField(
              onChanged: provider.setReferencePoint,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
              decoration: const InputDecoration(
                hintText: 'Ej: Casa blanca al lado del mercado...',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF906F70)),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Total Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1B1B1B), width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  'TOTAL A PAGAR',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1B1B),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${provider.totalUsd.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB80035),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${provider.totalVes.toStringAsFixed(2)} Bs',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5C3F40),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // WhatsApp button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: provider.hasItems
                  ? () async {
                      final url = Uri.parse(provider.whatsappUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                disabledBackgroundColor: const Color(0xFFCCCCCC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF1B1B1B), width: 2),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // WhatsApp icon using a simple circle with phone
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone,
                      size: 16,
                      color: Color(0xFF25D366),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'ENVIAR PEDIDO POR WHATSAPP',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Pago Movil button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: provider.hasItems
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen(),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBBF24),
                disabledBackgroundColor: const Color(0xFFCCCCCC),
                foregroundColor: const Color(0xFF1B1B1B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF1B1B1B), width: 2),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, size: 20, color: Color(0xFF1B1B1B)),
                  SizedBox(width: 10),
                  Text(
                    'PAGAR POR PAGOMOVIL EN LINEA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B1B1B),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
