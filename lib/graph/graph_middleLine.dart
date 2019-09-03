import 'package:flutter/material.dart';

class GraphMiddleLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    RRect rRect = RRect.fromLTRBR(0, size.height / 2 - 2, size.width,
        size.height / 2 + 2, Radius.circular(30));
    final Paint paint = Paint();
    canvas.save();
    canvas.drawRRect(rRect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
