import 'package:flutter/material.dart';

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 30);
    path.quadraticBezierTo(0, 20, 30, 20);
    path.lineTo(size.width * 0.35, 20);
    path.quadraticBezierTo(size.width * 0.40, 20, size.width * 0.42, 40);
    path.arcToPoint(Offset(size.width * 0.58, 40),
        radius: Radius.circular(33), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 20, size.width * 0.65, 20);
    path.lineTo(size.width - 30, 20);
    path.quadraticBezierTo(size.width, 20, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
