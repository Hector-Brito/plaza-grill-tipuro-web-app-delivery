import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plaza_grill_tipuro/providers/menu_provider.dart';
import 'package:plaza_grill_tipuro/widgets/menu/category_accordion.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class MenuCategorySection extends StatelessWidget {
  const MenuCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    // Categories are static — use read() to avoid unnecessary rebuilds
    final provider = context.read<MenuProvider>();
    final categories = provider.categories;

    return Column(
      children: categories.map((category) {
        final items = provider.getItemsByCategory(category);
        if (items.isEmpty) return const SizedBox.shrink();
        return CategoryAccordion(category: category, items: items);
      }).toList(),
    );
  }
}

class KioskoSection extends StatelessWidget {
  const KioskoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MenuProvider>();
    final items = provider.getItemsByCategory('Kiosko');
    
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            "OTROS PRODUCTOS (KIOSKO)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
        ),
        CategoryAccordion(category: 'Kiosko', items: items),
      ],
    );
  }
}
