import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class CheckoutActionButtons extends StatelessWidget {
  final bool hasItems;
  final VoidCallback? onSendWhatsApp;
  final VoidCallback? onPayOnline;

  const CheckoutActionButtons({
    super.key,
    required this.hasItems,
    required this.onSendWhatsApp,
    required this.onPayOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // WhatsApp button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: hasItems ? onSendWhatsApp : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
              disabledBackgroundColor: Colors.grey[300],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppTheme.darkText, width: 2),
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
                    color: AppTheme.successGreen,
                  ),
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    'ENVIAR PEDIDO POR WHATSAPP',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
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
            onPressed: hasItems ? onPayOnline : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              disabledBackgroundColor: Colors.grey[300],
              foregroundColor: AppTheme.darkText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppTheme.darkText, width: 2),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment, size: 20, color: AppTheme.darkText),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'PAGAR POR PAGOMOVIL EN LINEA',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
