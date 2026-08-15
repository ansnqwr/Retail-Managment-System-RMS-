import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NavigationDestinationWidget extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  const NavigationDestinationWidget({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(
        selectedIndex == index ? selectedIcon : icon,
        size: selectedIndex == index ? 30.0 : 24.0,
        color: selectedIndex == index ? const Color(0xFF6B2D5C) : Colors.grey,
      ),
      label: label.tr(),
    );
  }
}
