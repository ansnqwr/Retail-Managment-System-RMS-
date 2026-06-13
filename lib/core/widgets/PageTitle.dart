import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;

  final Color color;
  const PageTitle({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return _buildPageTitle(title, color);
  }

  Widget _buildPageTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
