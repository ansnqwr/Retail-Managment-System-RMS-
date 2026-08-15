import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CategorySliderItem extends StatelessWidget {
  final String label;
  final int categoryId;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategorySliderItem({
    super.key,
    required this.label,
    required this.categoryId,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6B2D5C);
    final bg = isSelected ? primaryColor : Colors.grey.shade200;
    final border = isSelected ? primaryColor : Colors.grey.shade300;
    final textColor = isSelected ? Colors.white : primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
          color: bg,
        ),
        child: Text(
          label.tr(),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
