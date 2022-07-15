import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

///Sqaure is passed to a painter for drawing
class Square {
  List<vm.Vector3> points;
  Square(this.points);

  List<Offset> displayPoints(double centerX, double centerY, double scaleF,
      double imageWidth, double imageHeight) {
    List<Offset> offsetPoints = [];
    for (var e in points) {
      Offset centerImage = Offset(imageWidth / 2, imageHeight / 2) / scaleF;
      offsetPoints.add(
          Offset(e.x / scaleF + centerX, e.y / scaleF + centerY) - centerImage);
    }

    offsetPoints.add(offsetPoints[0]);
    return offsetPoints;
  }
}
