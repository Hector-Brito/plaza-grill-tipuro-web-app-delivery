import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/models/add_on_option.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class ProteinSelector extends StatelessWidget {
  final String title;
  final List<AddOnOption> options;
  final AddOnOption? selectedOption;
  final ValueChanged<AddOnOption?> onChanged;

  const ProteinSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
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
          child: RadioGroup<AddOnOption>(
            groupValue: selectedOption,
            onChanged: onChanged,
            child: Column(
              children: options
                  .map(
                    (protein) => RadioListTile<AddOnOption>(
                      activeColor: AppTheme.primaryRed,
                      title: Text(
                        '${protein.name} ${protein.price > 0 ? '(+\$${protein.price.toStringAsFixed(2)})' : ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkText,
                        ),
                      ),
                      value: protein,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
