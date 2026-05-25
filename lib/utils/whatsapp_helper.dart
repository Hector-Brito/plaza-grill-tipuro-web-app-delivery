import 'package:plaza_grill_tipuro/models/cart_item.dart';
import 'package:plaza_grill_tipuro/models/delivery_zone.dart';

class WhatsAppHelper {
  static String buildWhatsAppMessage({
    required List<CartItem> cartItems,
    required DeliveryZone? selectedZone,
    required String referencePoint,
    required double subtotalUsd,
    required double subtotalVes,
    required double deliveryCostUsd,
    required double deliveryCostVes,
    required double totalUsd,
    required double totalVes,
    bool isPaid = false,
    String? reference,
  }) {
    final buffer = StringBuffer();
    if (isPaid) {
      buffer.writeln('✅ ¡PAGO VERIFICADO EXITOSAMENTE! ✅');
      buffer.writeln('Referencia: $reference');
      buffer.writeln('');
    }

    buffer.writeln('🍔 *PEDIDO PLAZA GRILL TIPURO*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('');

    // Products
    buffer.writeln('*📋 PRODUCTOS:*');
    for (final item in cartItems) {
      final lineTotal = item.totalPrice.toStringAsFixed(2);
      buffer.writeln('🛒 ${item.quantity}x ${item.menuItem.name} (\$$lineTotal)');
      
      if (item.selectedProtein != null) {
        buffer.writeln('   * Proteína: ${item.selectedProtein!.name}');
      }
      
      if (item.removedIngredients.isNotEmpty) {
        final removedNames = item.removedIngredients.map((e) => e.name).join(', ');
        buffer.writeln('   * Sin: $removedNames');
      }
      
      if (item.selectedExtras.isNotEmpty) {
        for (final extra in item.selectedExtras) {
          buffer.writeln('   * Extra: ${extra.name} (+\$${extra.price.toStringAsFixed(2)})');
        }
      }

      if (item.specialNote.trim().isNotEmpty) {
        buffer.writeln('   📝 _Nota: ${item.specialNote.trim()}_');
      }
    }
    buffer.writeln('');

    // Delivery
    buffer.writeln('*🚗 DELIVERY:*');
    if (selectedZone != null) {
      buffer.writeln(
        '• Zona: ${selectedZone.name} (\$${selectedZone.price.toStringAsFixed(2)})',
      );
    } else {
      buffer.writeln('• Zona: No seleccionada');
    }
    if (referencePoint.isNotEmpty) {
      buffer.writeln('• Referencia: $referencePoint');
    }
    buffer.writeln('');

    // Totals
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln(
      '*SUBTOTAL:* \$${subtotalUsd.toStringAsFixed(2)} / ${subtotalVes.toStringAsFixed(2)} Bs',
    );
    if (deliveryCostUsd > 0) {
      buffer.writeln(
        '*DELIVERY:* \$${deliveryCostUsd.toStringAsFixed(2)} / ${deliveryCostVes.toStringAsFixed(2)} Bs',
      );
    }
    buffer.writeln(
      '*💰 TOTAL: \$${totalUsd.toStringAsFixed(2)} / ${totalVes.toStringAsFixed(2)} Bs*',
    );
    buffer.writeln('');
    if (!isPaid) {
      buffer.writeln('📌 _Por favor adjunta tu ubicación y capture de pago._');
    } else {
      buffer.writeln('📌 _Por favor adjunta tu ubicación._');
    }

    return buffer.toString();
  }
}
