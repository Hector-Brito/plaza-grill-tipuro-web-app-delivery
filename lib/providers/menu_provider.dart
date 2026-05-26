import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/models/menu_item.dart';
import 'package:plaza_grill_tipuro/models/customization_option.dart';
import 'package:plaza_grill_tipuro/models/add_on_option.dart';
import 'package:plaza_grill_tipuro/services/appsheet_service.dart';

class MenuProvider extends ChangeNotifier {
  // --- Menu Items (Fetched dynamically) ---
  List<MenuItem> _menuItems = [];
  bool isLoadingMenu = false;
  bool hasMenuError = false;

  List<MenuItem> get menuItems => _menuItems;

  List<String> get categories {
    final allSubcategories = _menuItems
        .where(
          (e) => e.subcategory != 'Adicionales',
        ) // Hide Adicionales from main menu loop
        .map((e) => e.subcategory)
        .toSet()
        .toList();

    // Define the desired order of subcategories
    final desiredOrder = [
      'Hamburguesas',
      'Perros Calientes',
      'Enrollados',
      'Papas',
      'Raciones',
      'Parrillas',
      'Bebidas',
      'Kiosko',
    ];

    allSubcategories.sort((a, b) {
      final indexA = desiredOrder.indexOf(a);
      final indexB = desiredOrder.indexOf(b);

      if (indexA == -1 && indexB == -1) {
        return a.compareTo(
          b,
        ); // Sort alphabetically if neither is in the predefined list
      }
      if (indexA == -1) return 1; // Put a at the end if not in list
      if (indexB == -1) return -1; // Put b at the end if not in list

      return indexA.compareTo(indexB);
    });

    return allSubcategories;
  }

  Future<void> loadMenuFromAppSheet() async {
    if (isLoadingMenu) return;
    isLoadingMenu = true;
    hasMenuError = false;
    notifyListeners();

    try {
      final service = AppSheetService();

      final menuData = await service.getMenu();
      final personalizacionData = await service.getCustomizations();
      final adicionalData = await service.getExtras();
      final proteinasData = await service.getProteins();
      final bebidasSaboresData = await service.getBeverageFlavors();

      List<MenuItem> newItems = [];
      for (var row in menuData) {
        final id = row["ID"]?.toString() ?? "";
        if (id.isEmpty) continue;

        final name = row["Producto"]?.toString() ?? "";
        final categoryId = row["Categoria"]?.toString() ?? "";
        final price =
            double.tryParse(row["Precio unitario"]?.toString() ?? "0") ?? 0.0;
        final isAvailable = row["Disponible"]?.toString() == "Y";
        final isCustomizableRaw = row["Personalizable"]?.toString() == "Y";

        // Personalizaciones (Removable ingredients)
        List<CustomizationOption> removableIngredients = [];
        for (var p in personalizacionData) {
          if (p["ID Menu"] == id) {
            removableIngredients.add(
              CustomizationOption(
                id: p["ID"]?.toString() ?? "",
                name: p["Personalizacion"]?.toString() ?? "",
              ),
            );
          }
        }

        // Extras (Adicionales)
        List<AddOnOption> availableExtras = [];
        for (var a in adicionalData) {
          if (a["ID Menu"] == id) {
            final extraPrice =
                double.tryParse(a["Precio"]?.toString() ?? "0") ?? 0.0;
            availableExtras.add(
              AddOnOption(
                id: a["ID"]?.toString() ?? "",
                name: a["Adicional"]?.toString() ?? "",
                price: extraPrice,
              ),
            );
          }
        }

        // Proteinas
        List<AddOnOption> availableProteins = [];
        bool requiresProtein = false;
        for (var p in proteinasData) {
          if (p["ID Menu"] == id) {
            requiresProtein = true;
            availableProteins.add(
              AddOnOption(
                id: p["ID"]?.toString() ?? "",
                name: p["Proteina"]?.toString() ?? "",
                price: 0,
              ),
            );
          }
        }

        // Bebidas Sabores (also treated as proteins for selection)
        for (var s in bebidasSaboresData) {
          if (s["ID Menu"] == id) {
            requiresProtein = true;
            availableProteins.add(
              AddOnOption(
                id: s["ID"]?.toString() ?? "",
                name: s["Sabor"]?.toString() ?? "",
                price: 0,
              ),
            );
          }
        }

        newItems.add(
          MenuItem(
            id: id,
            categoryId: categoryId,
            name: name,
            description: row["Descripcion"]?.toString() ?? "",
            price: price,
            isAvailable: isAvailable,
            isCustomizable: isCustomizableRaw,
            requiresProtein: requiresProtein,
            removableIngredients: removableIngredients,
            availableExtras: availableExtras,
            availableProteins: availableProteins,
          ),
        );
      }

      _menuItems = newItems;
      isLoadingMenu = false;
      notifyListeners();
    } catch (e) {
      hasMenuError = true;
      isLoadingMenu = false;
      notifyListeners();
    }
  }

  List<MenuItem> getItemsByCategory(String subcategory) =>
      _menuItems.where((item) => item.subcategory == subcategory).toList();
}
