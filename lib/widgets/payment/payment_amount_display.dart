import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plaza_grill_tipuro/enums/venezuelan_bank.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class PaymentAmountDisplay extends StatelessWidget {
  final double totalVes;
  final double totalUsd;

  const PaymentAmountDisplay({
    super.key,
    required this.totalVes,
    required this.totalUsd,
  });

  String _getBankNameWithCode(String code) {
    try {
      final bank = VenezuelanBank.values.firstWhere((b) => b.code == code);
      return '${bank.name} (${bank.code})';
    } catch (_) {
      if (code == '0102') return 'Banco de Venezuela (0102)';
      if (code == '0115') return 'Banco Exterior (0115)';
      return 'Banco ($code)';
    }
  }

  String _formatPhone(String phone) {
    var cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('58') && cleaned.length > 10) {
      cleaned = '0${cleaned.substring(2)}';
    }
    if (cleaned.length == 11) {
      return '${cleaned.substring(0, 4)}-${cleaned.substring(4)}';
    }
    return phone;
  }

  String _formatDoc(String doc) {
    if (doc.isEmpty) return '';
    final cleaned = doc.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (cleaned.isEmpty) return '';

    final prefix = cleaned[0].toUpperCase();
    final numberStr = cleaned.substring(1);

    if ((prefix == 'J' || prefix == 'G') && numberStr.length == 9) {
      return '$prefix-${numberStr.substring(0, 8)}-${numberStr.substring(8)}';
    } else {
      final buffer = StringBuffer();
      int count = 0;
      for (int i = numberStr.length - 1; i >= 0; i--) {
        if (count > 0 && count % 3 == 0) {
          buffer.write('.');
        }
        buffer.write(numberStr[i]);
        count++;
      }
      final reversedNumber = buffer.toString().split('').reversed.join('');
      return '$prefix-$reversedNumber';
    }
  }

  String _formatAmountVes(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    final buffer = StringBuffer();
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(intPart[i]);
      count++;
    }
    final reversedInt = buffer.toString().split('').reversed.join('');
    return '$reversedInt,$decPart';
  }

  @override
  Widget build(BuildContext context) {
    final bankCode = dotenv.env['BANCO_DESTINO'] ?? '0102';
    final rawPhone = dotenv.env['TELEFONO_DESTINO'] ?? '04128798008';
    final rawDoc = dotenv.env['CEDULA_DESTINO'] ?? 'J506736853';

    final bankName = _getBankNameWithCode(bankCode);
    final phone = _formatPhone(rawPhone);
    final doc = _formatDoc(rawDoc);
    final amountText = _formatAmountVes(totalVes);

    // Warm sticky-note yellow color
    const stickyYellow = Color(0xFFFFF0C4);
    // Dark brown/gold color for labels to make it look premium
    const labelColor = Color(0xFF7A5C29);

    const labelStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w800,
      color: labelColor,
      letterSpacing: 0.5,
    );

    const valueStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: AppTheme.darkText,
      height: 1.2,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: stickyYellow,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('BANCO DESTINO', style: labelStyle),
                    const SizedBox(height: 2),
                    Text(bankName, style: valueStyle),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: labelColor, size: 18),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                tooltip: 'Copiar código de banco',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: bankCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Código de banco copiado: $bankCode'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TELÉFONO', style: labelStyle),
                    const SizedBox(height: 2),
                    Text(phone, style: valueStyle),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: labelColor, size: 18),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                tooltip: 'Copiar número de teléfono',
                onPressed: () {
                  var rawPhoneCopy = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
                  if (rawPhoneCopy.startsWith('58') &&
                      rawPhoneCopy.length > 10) {
                    rawPhoneCopy = '0${rawPhoneCopy.substring(2)}';
                  }
                  Clipboard.setData(ClipboardData(text: rawPhoneCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Teléfono copiado: $rawPhoneCopy'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('C.I / RIF', style: labelStyle),
                    const SizedBox(height: 2),
                    Text(doc, style: valueStyle),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: labelColor, size: 18),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                tooltip: 'Copiar C.I o RIF',
                onPressed: () {
                  final rawDocCopy = rawDoc
                      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                      .toUpperCase();
                  Clipboard.setData(ClipboardData(text: rawDocCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Documento copiado: $rawDocCopy'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE2C48D), thickness: 1, height: 1),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('MONTO A PAGAR', style: labelStyle),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$amountText Bs',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryRed,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(\$${totalUsd.toStringAsFixed(2)})',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: labelColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: labelColor, size: 22),
                tooltip: 'Copiar datos de pago',
                onPressed: () {
                  // Raw phone for clipboard (no dashes/spaces/letters)
                  var rawPhoneCopy = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
                  if (rawPhoneCopy.startsWith('58') &&
                      rawPhoneCopy.length > 10) {
                    rawPhoneCopy = '0${rawPhoneCopy.substring(2)}';
                  }

                  // Raw doc for clipboard (no dashes/spaces)
                  final rawDocCopy = rawDoc
                      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                      .toUpperCase();

                  // Amount for clipboard (no thousand dots, keep decimal comma)
                  final amountCopy = totalVes
                      .toStringAsFixed(2)
                      .replaceAll('.', ',');

                  final String paymentData =
                      '$bankCode\n'
                      '$rawPhoneCopy\n'
                      '$rawDocCopy\n'
                      '$amountCopy';

                  Clipboard.setData(ClipboardData(text: paymentData));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Datos de pago copiados al portapapeles'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
