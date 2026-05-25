import 'package:plaza_grill_tipuro/models/menu_item.dart';
import 'package:plaza_grill_tipuro/models/customization_option.dart';
import 'package:plaza_grill_tipuro/models/add_on_option.dart';

class CartItem {
  final String cartItemId;
  final MenuItem menuItem;
  int quantity;
  String specialNote;
  List<CustomizationOption> removedIngredients;
  List<AddOnOption> selectedExtras;
  AddOnOption? selectedProtein;

  CartItem({
    required this.cartItemId,
    required this.menuItem,
    this.quantity = 1,
    this.specialNote = '',
    this.removedIngredients = const [],
    this.selectedExtras = const [],
    this.selectedProtein,
  });

  double get unitPrice {
    double extras = selectedExtras.fold(0, (sum, e) => sum + e.price);
    double protein = selectedProtein?.price ?? 0;
    return menuItem.price + extras + protein;
  }

  double get totalPrice => unitPrice * quantity;

  bool isSameAs(CartItem other) {
    if (menuItem.id != other.menuItem.id) return false;
    if (specialNote != other.specialNote) return false;
    if (selectedProtein?.id != other.selectedProtein?.id) return false;

    if (removedIngredients.length != other.removedIngredients.length) return false;
    for (var ing in removedIngredients) {
      if (!other.removedIngredients.any((e) => e.id == ing.id)) return false;
    }

    if (selectedExtras.length != other.selectedExtras.length) return false;
    for (var extra in selectedExtras) {
      if (!other.selectedExtras.any((e) => e.id == extra.id)) return false;
    }

    return true;
  }
}
