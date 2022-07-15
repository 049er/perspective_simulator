// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

extension VectorExtention on vm.Vector3 {
  vm.Vector3 dotOpenCV(vm.Matrix3 m) {
    final v = this;
    vm.Vector3 result = vm.Vector3(
      v.x * m[0] + v.y * m[1] + v.z * m[2],
      v.x * m[3] + v.y * m[4] + v.z * m[5],
      v.x * m[6] + v.y * m[7] + v.z * m[8],
    );
    return result / result[2];
  }
}
