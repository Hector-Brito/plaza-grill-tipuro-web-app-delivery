import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/models/menu_item.dart';
import 'package:plaza_grill_tipuro/widgets/menu/product_card.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class CategoryAccordion extends StatelessWidget {
  final String category;
  final List<MenuItem> items;

  const CategoryAccordion({super.key, required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    String categoryName = category.toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: AppTheme.darkText, width: 1.5),
          ),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: AppTheme.darkText, width: 1.5),
          ),
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: AppTheme.primaryYellow,
          iconColor: AppTheme.darkText,
          collapsedIconColor: AppTheme.darkText,
          title: Text(
            categoryName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryRed,
              letterSpacing: 0.5,
            ),
          ),
          children: items.map((item) => ProductCard(item: item)).toList(),
        ),
      ),
    );
  }
}
