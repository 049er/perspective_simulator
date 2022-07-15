// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

///Calculate the world points
///Size = sqaure size (mm)
///
///dX = x offset.
///
///dY = y offset.
///
///dZ = z offset.
List<vm.Vector4> generateWorldPoints(
    double size, double dX, double dY, double dZ) {
  vm.Vector4 bottomLeft = vm.Vector4(-size + dX, -size - dY, dZ, 1);
  vm.Vector4 bottomRight = vm.Vector4(size + dX, -size - dY, dZ, 1);
  vm.Vector4 topRight = vm.Vector4(size + dX, size - dY, dZ, 1);
  vm.Vector4 topLeft = vm.Vector4(-size + dX, size - dY, dZ, 1);
  return [bottomLeft, bottomRight, topRight, topLeft];
}
