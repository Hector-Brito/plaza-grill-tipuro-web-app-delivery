import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plaza_grill_tipuro/models/cart_item.dart';
import 'package:plaza_grill_tipuro/models/delivery_zone.dart';
import 'package:plaza_grill_tipuro/utils/whatsapp_helper.dart';

class CartProvider extends ChangeNotifier {
  static const double exchangeRate = 474.06;
  String get whatsappNumber => dotenv.env['WHATSAPP_NUMBER'] ?? '584148783374';
  String get pagoMovilTelefonoForm =>
      dotenv.env['PAGO_MOVIL_TELEFONO_FORM'] ?? '04148783374';

  // --- Cart ---
  final List<CartItem> _cartItems = [];

  // --- Delivery Zones ---
  final List<DeliveryZone> _deliveryZones = const [
    DeliveryZone(id: 'z1', name: 'Retiro en local', price: 0),
    DeliveryZone(id: 'z2', name: 'Tipuro', price: 2),
    DeliveryZone(id: 'z3', name: 'Viboral', price: 4.5),
  ];

  DeliveryZone? _selectedZone;
  String _referencePoint = '';

  // --- Getters ---
  List<CartItem> get cartItems => _cartItems;
  List<DeliveryZone> get deliveryZones => _deliveryZones;
  DeliveryZone? get selectedZone => _selectedZone;
  String get referencePoint => _referencePoint;

  // --- Calculations ---
  double get subtotalUsd {
    double total = 0;
    for (final item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  double get deliveryCostUsd => _selectedZone?.price ?? 0;

  double get totalUsd => subtotalUsd + deliveryCostUsd;
  double get totalVes => totalUsd * exchangeRate;
  double get subtotalVes => subtotalUsd * exchangeRate;
  double get deliveryCostVes => deliveryCostUsd * exchangeRate;

  bool get hasItems => _cartItems.isNotEmpty;

  // --- Cart Actions ---
  void addToCart(CartItem item) {
    final index = _cartItems.indexWhere((existing) => existing.isSameAs(item));
    if (index != -1) {
      _cartItems[index].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.cartItemId == cartItemId);
    notifyListeners();
  }

  void updateCartItemQuantity(String cartItemId, int delta) {
    final idx = _cartItems.indexWhere((item) => item.cartItemId == cartItemId);
    if (idx != -1) {
      _cartItems[idx].quantity += delta;
      if (_cartItems[idx].quantity <= 0) {
        _cartItems.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void setDeliveryZone(DeliveryZone? zone) {
    _selectedZone = zone;
    notifyListeners();
  }

  void setReferencePoint(String value) {
    _referencePoint = value;
  }

  String get whatsappUrl {
    final message = Uri.encodeComponent(WhatsAppHelper.buildWhatsAppMessage(
      cartItems: _cartItems,
      selectedZone: _selectedZone,
      referencePoint: _referencePoint,
      subtotalUsd: subtotalUsd,
      subtotalVes: subtotalVes,
      deliveryCostUsd: deliveryCostUsd,
      deliveryCostVes: deliveryCostVes,
      totalUsd: totalUsd,
      totalVes: totalVes,
    ));
    return 'https://wa.me/$whatsappNumber?text=$message';
  }

  String getWhatsappUrlPaid(String reference) {
    final message = Uri.encodeComponent(
      WhatsAppHelper.buildWhatsAppMessage(
        cartItems: _cartItems,
        selectedZone: _selectedZone,
        referencePoint: _referencePoint,
        subtotalUsd: subtotalUsd,
        subtotalVes: subtotalVes,
        deliveryCostUsd: deliveryCostUsd,
        deliveryCostVes: deliveryCostVes,
        totalUsd: totalUsd,
        totalVes: totalVes,
        isPaid: true,
        reference: reference,
      ),
    );
    return 'https://wa.me/$whatsappNumber?text=$message';
  }
}
