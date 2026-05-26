import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class CategoryCarousel extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryCarousel({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primaryYellow : AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isActive ? AppTheme.darkText : const Color(0xFFD1D1D1),
                  width: isActive ? 1.5 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                    color: AppTheme.darkText,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
