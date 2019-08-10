import 'package:flutter/material.dart';

class GraphLine extends CustomPainter {
  GraphLine(this.length, this.color);

  double length;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    RRect rRect;
    if (length >= 0) {
      rRect = RRect.fromLTRBR(0, 0, size.width, length, Radius.circular(30));
    } else {
      rRect = RRect.fromLTRBR(0, size.height / 2, size.width,
          length.abs() + size.height / 2, Radius.circular(30));
    }
    final Paint paint = Paint()..color = color;
    canvas.save();
    canvas.drawRRect(rRect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
