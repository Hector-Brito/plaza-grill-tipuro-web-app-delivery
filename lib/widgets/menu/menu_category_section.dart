import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plaza_grill_tipuro/providers/menu_provider.dart';
import 'package:plaza_grill_tipuro/widgets/menu/category_carousel.dart';
import 'package:plaza_grill_tipuro/widgets/menu/product_card.dart';

class MenuCategorySection extends StatefulWidget {
  const MenuCategorySection({super.key});

  @override
  State<MenuCategorySection> createState() => _MenuCategorySectionState();
}

class _MenuCategorySectionState extends State<MenuCategorySection> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MenuProvider>();
    final categories = provider.categories;

    if (categories.isEmpty) return const SizedBox.shrink();

    // Default to first category
    final selected = _selectedCategory ?? categories.first;
    final items = provider.getItemsByCategory(selected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryCarousel(
          categories: categories,
          selectedCategory: selected,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
        ),
        const SizedBox(height: 16),
        // Filtered product list
        ...items.map((item) => ProductCard(item: item)),
        const SizedBox(height: 8),
      ],
    );
  }
}

