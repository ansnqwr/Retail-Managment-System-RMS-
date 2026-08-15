import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/core/widgets/IconCircleWidget.dart';

class BadgeIconWidget extends StatelessWidget {
  final BuildContext context;
  final String label;
  final IconData icon;
  final Color color;

  const BadgeIconWidget({
    super.key,
    required this.context,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _badgeIcon(context, label, icon, color);
  }
}

Widget _badgeIcon(
  BuildContext context,
  String label,
  IconData icon,
  Color color,
) {
  return Stack(
    alignment: Alignment.topRight,
    children: [
      IconCircleWidget(icon: icon, color: color),
      Positioned(
        right: 0,
        top: 0,
        child: CircleAvatar(
          radius: 9,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            label.tr(),
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
