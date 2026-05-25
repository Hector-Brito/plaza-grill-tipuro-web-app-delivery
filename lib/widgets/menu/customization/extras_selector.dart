import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/models/add_on_option.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class ExtrasSelector extends StatelessWidget {
  final List<AddOnOption> extras;
  final void Function(AddOnOption option, bool isSelected) onChanged;

  const ExtrasSelector({
    super.key,
    required this.extras,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EXTRAS',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: AppTheme.darkText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: extras
                .map(
                  (extra) => CheckboxListTile(
                    activeColor: AppTheme.primaryRed,
                    title: Text(
                      '${extra.name} (+\$${extra.price.toStringAsFixed(2)})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkText,
                      ),
                    ),
                    value: extra.isSelected,
                    onChanged: (val) => onChanged(extra, val ?? false),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
