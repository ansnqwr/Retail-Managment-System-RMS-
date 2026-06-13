import 'package:flutter/material.dart';

class SubCategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final double width;
  const SubCategoryCard({
    super.key,
    required this.title,
    this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6B2D5C);
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color(0xFFF2A488)),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
