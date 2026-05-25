import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/models/customization_option.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class IngredientRemover extends StatelessWidget {
  final List<CustomizationOption> ingredients;
  final void Function(CustomizationOption option, bool isRemoved) onChanged;

  const IngredientRemover({
    super.key,
    required this.ingredients,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          title: const Text(
            'QUITAR INGREDIENTES',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: AppTheme.darkText,
              letterSpacing: 0.5,
            ),
          ),
          children: ingredients
              .map(
                (ing) => CheckboxListTile(
                  activeColor: AppTheme.primaryRed,
                  title: Text(
                    'Sin ${ing.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                  value: ing.isRemoved,
                  onChanged: (val) => onChanged(ing, val ?? false),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
