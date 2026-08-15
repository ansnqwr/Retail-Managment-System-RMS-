import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DropDownListWidget extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;
  final bool isExpanded = true;
  const DropDownListWidget({
    super.key,
    this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return buildDropdownField(
      value: value,
      hint: hint.tr(),
      items: items,
      onChanged: onChanged,
      isExpanded: isExpanded,
    );
  }

  static Widget buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
    bool isExpanded = true,
  }) {
    return DropdownButtonFormField<String>(
      value: value!,
      hint: Text(hint.tr()),
      isExpanded: isExpanded,
      items:
          items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item.tr()));
          }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
