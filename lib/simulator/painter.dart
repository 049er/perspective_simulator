import 'package:flutter/material.dart';

import '../classes/sqaure.dart';

///Painter
class Painter extends CustomPainter {
  Painter({
    required this.sqaures,
    required this.imageHeight,
    required this.imageWidth,
  });

  List<Square> sqaures;
  double imageWidth;
  double imageHeight;

  final textStyle = const TextStyle(
    color: Colors.redAccent,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.visible,
  );

  List<String> names = ['TL', 'TR', 'BR', 'BL'];

  @override
  paint(Canvas canvas, Size size) async {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    double scaleFactor = 2.5; //bigger is smaller

    paintImageEdges(
        scaleFactor, centerX, centerY, canvas, imageWidth, imageHeight);

    for (var sqaure in sqaures) {
      List<Offset> offsets = sqaure.displayPoints(
          centerX, centerY, scaleFactor, imageWidth, imageHeight);
      Path path = Path();
      path.addPolygon(offsets, true);
      canvas.drawPath(
        path,
        paintEasy(Colors.greenAccent.withOpacity(0.5), 1, PaintingStyle.fill),
      );

      for (var i = 0; i < 4; i++) {
        final textSpan = TextSpan(
          text:
              '${sqaure.points[i].x.toInt()}, ${sqaure.points[i].y.toInt()} (${names[i]})',
          style: textStyle,
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(
          minWidth: 0,
          maxWidth: 100,
        );

        if (i == 0 || i == 1) {
          textPainter.paint(canvas, offsets[i] + const Offset(-20, -10));
        } else {
          textPainter.paint(canvas, offsets[i] + const Offset(-20, 0));
        }
      }
    }
  }

  //Paints the edges of a 1280x720 photo
  void paintImageEdges(double scaleFactor, double centerX, double centerY,
      Canvas canvas, double w, double h) {
    double px = (w / 2) / scaleFactor;
    double py = (h / 2) / scaleFactor;

    List<Offset> photoEdges = [
      Offset(centerX - px, centerY - py),
      Offset(centerX + px, centerY - py),
      Offset(centerX + px, centerY + py),
      Offset(centerX - px, centerY + py),
    ];

    Path path1 = Path();
    path1.addPolygon(photoEdges, true);
    canvas.drawPath(
        path1, paintEasy(Colors.deepOrange, 2, PaintingStyle.stroke));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Paint paintEasy(
  Color color,
  double strokeWidth,
  PaintingStyle paintingStyle,
) {
  var paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth
    ..style = paintingStyle;
  return paint;
}
