import 'package:plaza_grill_tipuro/models/customization_option.dart';
import 'package:plaza_grill_tipuro/models/add_on_option.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final bool isAvailable;
  final bool isCustomizable;
  final bool requiresProtein;
  final List<CustomizationOption> removableIngredients;
  final List<AddOnOption> availableExtras;
  final List<AddOnOption> availableProteins;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.isAvailable = true,
    this.isCustomizable = false,
    this.requiresProtein = false,
    this.removableIngredients = const [],
    this.availableExtras = const [],
    this.availableProteins = const [],
  });

  String get subcategory {
    if (categoryId == '46d3742f') return 'Bebidas';
    if (categoryId == 'f68d4417') return 'Kiosko';

    final lowerName = name.toLowerCase();
    if (lowerName.contains('adicional')) return 'Adicionales';
    if (lowerName.contains('ración') || lowerName.contains('racion') || lowerName.contains('tequeño') || lowerName.contains('r.')) return 'Raciones';
    if (lowerName.contains('hamburguesa') || lowerName.contains('super')) return 'Hamburguesas';
    if (lowerName.contains('perro') || lowerName.contains('polaco') || lowerName.contains('choripan') || lowerName.contains('parripan')) return 'Perros Calientes';
    if (lowerName.contains('enrollado') || lowerName.contains('pepito')) return 'Enrollados';
    if (lowerName.contains('papa')) return 'Papas';
    if (lowerName.contains('parrilla')) return 'Parrillas';

    return 'Otros';
  }
}
