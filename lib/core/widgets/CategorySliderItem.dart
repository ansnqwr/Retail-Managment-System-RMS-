import 'package:flutter/material.dart';

class CategorySliderItem extends StatelessWidget {
  final String label;
  // final String image;
  const CategorySliderItem({
    super.key,
    required this.label,
    // required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return _categorySliderItem(
      label,
      // ,image
    );
  }
}

Widget _categorySliderItem(
  String label,
  //  ,String image
) {
  final primaryColor = const Color(0xFF6B2D5C);

  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade500),
      color: Colors.grey.shade300,
    ),
    child: Row(
      children: [
        // Expanded(flex: 4, child: Image.asset(image)),
        // Expanded(
        // flex: 3,
        // child:
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        // ),
      ],
    ),
  );
}
