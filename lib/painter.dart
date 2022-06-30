import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  Painter({required this.offsets});

  List<Offset> offsets;

  @override
  paint(Canvas canvas, Size size) async {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    List<Offset> centeredOffsets = [];

    for (var offset in offsets) {
      centeredOffsets
          .add(Offset((offset.dx / 10) + centerX, (offset.dy / 10) + centerY));
    }

    Path path = Path();
    path.addPolygon(centeredOffsets, true);
    canvas.drawPath(path, paintEasy(Colors.greenAccent, 1));

    canvas.drawPoints(
        PointMode.points, centeredOffsets, paintEasy(Colors.redAccent, 2.5));

    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY),
        paintEasy(Colors.redAccent, 0.5));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Paint paintEasy(
  Color color,
  double strokeWidth,
) {
  var paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth
    ..style = PaintingStyle.fill;
  return paint;
}
