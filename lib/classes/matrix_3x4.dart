// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;
import 'dart:math' as m;

///Constructs a 3x4 matrix, used to rotate and translate the camera
///
///Rotation (deg)
///
///Translation (mm)
///
class Matrix3x4 {
  Matrix3x4({
    required this.xRotation,
    required this.yRotation,
    required this.zRotation,
    required this.xTranslation,
    required this.yTranslation,
    required this.zTranslation,
  });

  double xRotation;
  double yRotation;
  double zRotation;
  double xTranslation;
  double yTranslation;
  double zTranslation;

  vm.Matrix3 _rotationMatrix() {
    double x = xRotation * (m.pi / 180);
    double y = yRotation * (m.pi / 180);
    double z = zRotation * (m.pi / 180);

    return vm.Matrix3(
      m.cos(z) * m.cos(y),
      m.cos(z) * m.sin(y) * m.sin(x) - m.sin(z) * m.cos(x),
      m.cos(z) * m.sin(y) * m.cos(x) + m.sin(z) * m.sin(x),
      m.sin(z) * m.cos(y),
      m.sin(z) * m.sin(y) * m.sin(x) + m.cos(z) * m.cos(x),
      m.sin(z) * m.sin(y) * m.cos(x) - m.cos(z) * m.sin(x),
      -m.sin(y),
      m.cos(y) * m.sin(x),
      m.cos(y) * m.cos(x),
    );
  }

  vm.Vector3 dot(vm.Vector4 wp) {
    vm.Matrix3 rm = _rotationMatrix();
    return vm.Vector3(
      wp.x * rm[0] + wp.y * rm[1] + wp.z * rm[2] + wp.w * xTranslation,
      wp.x * rm[3] + wp.y * rm[4] + wp.z * rm[5] + wp.w * yTranslation,
      wp.x * rm[6] + wp.y * rm[7] + wp.z * rm[8] + wp.w * zTranslation,
    );
  }
}
