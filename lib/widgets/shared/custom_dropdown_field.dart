import 'package:flutter/material.dart';
import 'package:plaza_grill_tipuro/config/theme.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String? hintText;
  final String? labelText;
  final Widget Function(T) itemBuilder;
  final void Function(T?) onChanged;
  final bool isExpanded;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.hintText,
    this.labelText,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final dropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.darkText),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: isExpanded,
          hint: hintText != null ? Text(hintText!, style: const TextStyle(color: AppTheme.hintText, fontSize: 14)) : null,
          value: value,
          items: items.map((item) => 
            DropdownMenuItem<T>(
              value: item,
              child: itemBuilder(item),
            )
          ).toList(),
          onChanged: onChanged,
        ),
      ),
    );

    if (labelText == null) {
      return dropdown;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            labelText!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkText,
              letterSpacing: 0.5,
            ),
          ),
        ),
        dropdown,
      ],
    );
  }
}
