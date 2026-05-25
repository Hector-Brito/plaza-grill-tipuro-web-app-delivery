import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/order_provider.dart';

class SuccessScreen extends StatelessWidget {
  final String reference;
  final String amount;

  const SuccessScreen({
    super.key,
    required this.reference,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OrderProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Green Checkmark Circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1B1B1B), width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Success text
                  const Text(
                    'PAGO EXITOSO',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1B1B1B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tu transacción ha sido validada por el banco. Ya estamos listos para preparar tu orden.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5C3F40),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Info Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1B1B1B), width: 2),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Referencia', '#$reference'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Color(0xFFE5BDBE), thickness: 1),
                        ),
                        _buildInfoRow('Monto', '$amount Bs'),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // WhatsApp Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = Uri.parse(provider.getWhatsappUrlPaid(reference));
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
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
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.phone, size: 14, color: Color(0xFF25D366)),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'ENVIAR ORDEN PAGADA A WHATSAPP',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF906F70),
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1B1B1B),
          ),
        ),
      ],
    );
  }
}
