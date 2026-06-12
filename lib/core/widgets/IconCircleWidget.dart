import 'package:flutter/material.dart';

class IconCircleWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  const IconCircleWidget({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return _iconCircle(icon, color);
  }
}

Widget _iconCircle(IconData icon, Color color) {
  return Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey.shade300,
    ),
    child: Icon(icon, size: 24, color: color),
  );
}
