// lib/core/widgets/login_background_painter.dart
import 'package:flutter/material.dart';

class LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // 1. التموج الخوخي السفلي الخلفي
    paint.color = const Color(0xFFF2A488);
    var pathPeachBottom = Path();
    pathPeachBottom.moveTo(0, size.height * 0.75);
    pathPeachBottom.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.88,
      size.width,
      size.height * 0.72,
    );
    pathPeachBottom.lineTo(size.width, size.height);
    pathPeachBottom.lineTo(0, size.height);
    pathPeachBottom.close();
    canvas.drawPath(pathPeachBottom, paint);

    // 2. التموج الخوخي العلوي الخلفي
    paint.color = const Color(0xFFF2A488);
    var pathPeachTop = Path();
    pathPeachTop.moveTo(0, 0);
    pathPeachTop.lineTo(size.width, 0);
    pathPeachTop.lineTo(size.width, size.height * 0.22);
    pathPeachTop.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.32,
      0,
      size.height * 0.20,
    );
    pathPeachTop.close();
    canvas.drawPath(pathPeachTop, paint);

    // 3. التموج البنفسجي العلوي الأمامي
    paint.color = const Color(0xFF6B2D5C);
    var pathPurpleTop = Path();
    pathPurpleTop.moveTo(0, 0);
    pathPurpleTop.lineTo(size.width, 0);
    pathPurpleTop.lineTo(size.width, size.height * 0.12);
    pathPurpleTop.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.26,
      0,
      size.height * 0.10,
    );
    pathPurpleTop.close();
    canvas.drawPath(pathPurpleTop, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
