import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/menu_item.dart';
import '../models/sauce_option.dart';
import '../models/delivery_zone.dart';

class OrderProvider extends ChangeNotifier {
  static const double exchangeRate = 474.06;
  String get whatsappNumber => dotenv.env['WHATSAPP_NUMBER'] ?? '584148783374';
  String get pagoMovilTelefonoForm =>
      dotenv.env['PAGO_MOVIL_TELEFONO_FORM'] ?? '04148783374';

  // --- Menu Items ---
  final List<MenuItem> _menuItems = [
    MenuItem(
      name: 'SUPER KRISPY',
      description: 'Pollo crujiente, queso cheddar, tocino, lechuga, tomate.',
      price: 10.0,
      category: 'HAMBURGUESAS',
    ),
    MenuItem(
      name: 'DOBLE CARNE',
      description: '200g carne de res, queso, cebolla caramelizada.',
      price: 12.0,
      category: 'HAMBURGUESAS',
    ),
    MenuItem(
      name: 'JUMBO POLACO',
      description: 'Salchicha jumbo, ensalada repollo, papitas, salsas.',
      price: 6.0,
      category: 'PERROS CALIENTES',
    ),
    MenuItem(
      name: 'REFRESCO 600ML',
      description: 'Coca-Cola, Sprite, Chinotto.',
      price: 2.0,
      category: 'BEBIDAS',
    ),
  ];

  // --- Sauces ---
  final List<SauceOption> _sauces = [
    SauceOption(
      name: 'Todas las salsas (Ajo, Maíz, Ketchup, Mayonesa, Mostaza)',
    ),
    SauceOption(name: 'Sin salsas'),
    SauceOption(name: 'Extra Ajo', price: 0.50),
    SauceOption(name: 'Extra Queso', price: 1.00),
  ];

  // --- Delivery Zones ---
  final List<DeliveryZone> _deliveryZones = const [
    DeliveryZone(name: 'Retiro en local', price: 0),
    DeliveryZone(name: 'Tipuro', price: 2),
    DeliveryZone(name: 'Viboral', price: 4.5),
  ];

  DeliveryZone? _selectedZone;
  String _referencePoint = '';

  // --- Getters ---
  List<MenuItem> get menuItems => _menuItems;
  List<SauceOption> get sauces => _sauces;
  List<DeliveryZone> get deliveryZones => _deliveryZones;
  DeliveryZone? get selectedZone => _selectedZone;
  String get referencePoint => _referencePoint;

  List<MenuItem> getItemsByCategory(String category) =>
      _menuItems.where((item) => item.category == category).toList();

  List<String> get categories =>
      _menuItems.map((e) => e.category).toSet().toList();

  // --- Calculations ---
  double get subtotalUsd {
    double total = 0;
    for (final item in _menuItems) {
      total += item.totalPrice;
    }
    return total;
  }

  double get saucesExtraUsd {
    double total = 0;
    for (final sauce in _sauces) {
      if (sauce.selected) total += sauce.price;
    }
    return total;
  }

  double get deliveryCostUsd => _selectedZone?.price ?? 0;

  double get totalUsd => subtotalUsd + saucesExtraUsd + deliveryCostUsd;
  double get totalVes => totalUsd * exchangeRate;
  double get subtotalVes => subtotalUsd * exchangeRate;
  double get deliveryCostVes => deliveryCostUsd * exchangeRate;

  bool get hasItems => _menuItems.any((item) => item.quantity > 0);

  // --- Actions ---
  void incrementItem(MenuItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrementItem(MenuItem item) {
    if (item.quantity > 0) {
      item.quantity--;
      if (item.quantity == 0) item.note = '';
      notifyListeners();
    }
  }

  void setItemNote(MenuItem item, String note) {
    item.note = note;
    // No notifyListeners — avoids keyboard dismissal while typing
  }

  void toggleSauce(int index) {
    // "Todas las salsas" and "Sin salsas" are mutually exclusive
    if (index == 0 && !_sauces[0].selected) {
      _sauces[1].selected = false;
    } else if (index == 1 && !_sauces[1].selected) {
      _sauces[0].selected = false;
    }
    _sauces[index].selected = !_sauces[index].selected;
    notifyListeners();
  }

  void setDeliveryZone(DeliveryZone? zone) {
    _selectedZone = zone;
    notifyListeners();
  }

  void setReferencePoint(String value) {
    _referencePoint = value;
    // No notifyListeners needed for text input
  }

  // --- WhatsApp Message ---
  String buildWhatsAppMessage({bool isPaid = false, String? reference}) {
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
    for (final item in _menuItems) {
      if (item.quantity > 0) {
        final lineTotal = item.totalPrice.toStringAsFixed(2);
        buffer.writeln('• ${item.name} x${item.quantity} — \$$lineTotal');
        if (item.note.trim().isNotEmpty) {
          buffer.writeln('   📝 _${item.note.trim()}_');
        }
      }
    }
    buffer.writeln('');

    // Sauces
    final selectedSauces = _sauces.where((s) => s.selected).toList();
    if (selectedSauces.isNotEmpty) {
      buffer.writeln('*🥫 SALSAS:*');
      for (final sauce in selectedSauces) {
        buffer.writeln('• ${sauce.name} (${sauce.price})');
      }
      buffer.writeln('');
    }

    // Delivery
    buffer.writeln('*🚗 DELIVERY:*');
    if (_selectedZone != null) {
      buffer.writeln(
        '• Zona: ${_selectedZone!.name} (${_selectedZone!.price})',
      );
    } else {
      buffer.writeln('• Zona: No seleccionada');
    }
    if (_referencePoint.isNotEmpty) {
      buffer.writeln('• Referencia: $_referencePoint');
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
    if (saucesExtraUsd > 0) {
      buffer.writeln(
        '*EXTRAS SALSAS:* \$${saucesExtraUsd.toStringAsFixed(2)} / ${(saucesExtraUsd * exchangeRate).toStringAsFixed(2)} Bs',
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

  String get whatsappUrl {
    final message = Uri.encodeComponent(buildWhatsAppMessage());
    return 'https://wa.me/$whatsappNumber?text=$message';
  }

  String getWhatsappUrlPaid(String reference) {
    final message = Uri.encodeComponent(
      buildWhatsAppMessage(isPaid: true, reference: reference),
    );
    return 'https://wa.me/$whatsappNumber?text=$message';
  }

  // Real API Call to BDV
  Future<String?> verifyPayment(Map<String, dynamic> requestData) async {
    try {
      final dio = Dio();

      // Override requirements from .env
      requestData['telefonoDestino'] =
          dotenv.env['TELEFONO_DESTINO'] ?? '04128798008';
      requestData['importe'] = '1.00';
      // Adding these just in case the API needs them, as requested by user
      requestData['cedulaDestino'] =
          dotenv.env['CEDULA_DESTINO'] ?? 'J506736853';
      requestData['bancoDestino'] = dotenv.env['BANCO_DESTINO'] ?? '0102';

      final originBankCode = requestData['bancoOrigen'] as String;
      final bool requiresIDValidation = originBankCode == "0102";
      requestData['reqCed'] = requiresIDValidation.toString();

      await dio.post(
        'https://bdvconciliacion.banvenez.com/getMovement',
        data: requestData,
        options: Options(
          headers: {
            "X-Api-Key":
                dotenv.env['BDV_API_KEY'] ?? "9576945A28CC7EA4F67FF8179CC77ED1",
            "Content-Type": "application/json",
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      // If we reach here, it implies status 200 or successful parsing in Dio.
      return null; // Null means success
    } on DioException catch (err) {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return "El servidor tardó demasiado en responder. Revisa tu conexión.";
        case DioExceptionType.connectionError:
          return "Parece que no tienes conexión a internet. Revisa tu señal e inténtalo de nuevo.";
        case DioExceptionType.badResponse:
          final data = err.response?.data;
          if (data is Map<String, dynamic>) {
            return data["message"]?.toString() ??
                "Error de validacion en el banco";
          }
          return "Error de validación en el banco (${err.response?.statusCode})";
        case DioExceptionType.cancel:
          return "Petición cancelada";
        default:
          return "Error de red: \$err";
      }
    } catch (err) {
      return "Error inesperado al procesar los datos: \$err";
    }
  }
}
