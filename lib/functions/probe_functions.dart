import 'package:perspective_simulator/classes/matrix_3x4.dart';
import 'package:perspective_simulator/extentions/vector3_extention.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

import '../constants/opencv_matrix.dart';

double probeY({
  required List<vm.Vector4> worldPoints,
  required double imageHeight,
  required double xRotation,
  required double yRotation,
  required double zRotation,
  required double zTranslation,
}) {
  double yMax = 0;
  //4. Probe for the Y range start.
  for (var i = 0; i < 10000; i++) {
    //5. Calculate the current position.
    double value = i * 1;

    //6. Calculate the screen points.
    List<vm.Vector3> w = worldPoints.map((e) {
      //i. Dot the extrinsic mList<vm.Vector4> worldPointsatrix (R|T) with worldPoint.
      vm.Vector3 point = Matrix3x4(
              xRotation: xRotation,
              yRotation: yRotation,
              zRotation: zRotation,
              xTranslation: 0,
              yTranslation: value,
              zTranslation: zTranslation)
          .dot(e);
      //ii. Dot the product with the camera matrix (K).
      return point.dotOpenCV(cameraMatrix);
    }).toList();

    if (w[0].y > imageHeight ||
        w[1].y > imageHeight ||
        w[2].y > imageHeight ||
        w[3].y > imageHeight) {
      yMax = value;
      break;
    }
  }
  return yMax;
}

double probeX({
  required List<vm.Vector4> worldPoints,
  required double imageHeight,
  required double xRotation,
  required double yRotation,
  required double zRotation,
  required double zTranslation,
}) {
  double xMax = 0;
  //4. Probe for the Y range start.
  for (var i = 0; i < 100; i++) {
    //5. Calculate the current position.
    double value = i * 1;

    //6. Calculate the screen points.
    List<vm.Vector3> w = worldPoints.map((e) {
      //i. Dot the extrinsic mList<vm.Vector4> worldPointsatrix (R|T) with worldPoint.
      vm.Vector3 point = Matrix3x4(
              xRotation: xRotation,
              yRotation: yRotation,
              zRotation: zRotation,
              xTranslation: value,
              yTranslation: 0,
              zTranslation: zTranslation)
          .dot(e);
      //ii. Dot the product with the camera matrix (K).
      return point.dotOpenCV(cameraMatrix);
    }).toList();

    if (w[0].x > imageHeight ||
        w[1].x > imageHeight ||
        w[2].x > imageHeight ||
        w[3].x > imageHeight) {
      xMax = value;
      break;
    }
  }
  return xMax;
}
