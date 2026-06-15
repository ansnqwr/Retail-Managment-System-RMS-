import 'package:flutter/material.dart';

class ColorCircleWidget extends StatelessWidget {
  final Map<String, dynamic> color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorCircleWidget({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return buildColorCircle(color: color, isSelected: isSelected, onTap: onTap);
  }

  static Widget buildColorCircle({
    required Map<String, dynamic> color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color['value'],
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child:
            isSelected
                ? Icon(
                  Icons.check,
                  color:
                      color['name'] == 'White' || color['name'] == 'Yellow'
                          ? Colors.black
                          : Colors.white,
                  size: 20,
                )
                : null,
      ),
    );
  }
}
