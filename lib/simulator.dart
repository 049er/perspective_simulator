import 'dart:io';
import 'dart:math';
import 'dart:developer' as d;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perspective_simulator/painter.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

class Simulator extends StatefulWidget {
  const Simulator({Key? key}) : super(key: key);

  @override
  State<Simulator> createState() => _SimulatorState();
}

class _SimulatorState extends State<Simulator> {
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _perspectiveController = TextEditingController();

  final TextEditingController _angleStartController = TextEditingController();
  final TextEditingController _angleEndController = TextEditingController();
  final TextEditingController _angleStepController = TextEditingController();

  List<Offset> offsetsToDraw = [];

  @override
  void initState() {
    _fileNameController.text = 'tensor_data_p0_0001';
    _perspectiveController.text = '0.0001';
    _angleStartController.text = '-85';
    _angleEndController.text = '85';
    _angleStepController.text = '5';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Simulator',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _textWidget('File name:  ', _fileNameController),
          _textWidget('Perspective value:  ', _perspectiveController),
          _angleSelector(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _simualte(
                    start: double.parse(_angleStartController.text),
                    end: double.parse(_angleEndController.text),
                    step: double.parse(_angleStepController.text),
                    perspectiveValue:
                        double.parse(_perspectiveController.text));
              },
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
              child: const Text(
                'Simulate',
              ),
            ),
          ),
          _viewer(),
        ],
      ),
    );
  }

  Widget _angleSelector() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87.withOpacity(0.5),
        border: Border.all(color: Colors.deepOrange, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Text(
              'Start: ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Flexible(
              child: TextField(
                controller: _angleStartController,
              ),
            ),
            Text(
              '°',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'End: ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Flexible(
              child: TextField(
                controller: _angleEndController,
              ),
            ),
            Text(
              '°',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const VerticalDivider(
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.white,
            ),
            Text(
              'Step: ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Flexible(
              child: TextField(
                controller: _angleStepController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textWidget(
      String label, TextEditingController textEditingController) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87.withOpacity(0.5),
        border: Border.all(color: Colors.deepOrange, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Flexible(
            child: TextField(
              controller: textEditingController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewer() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87.withOpacity(0.5),
        border: Border.all(color: Colors.deepOrange, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2,
      child: CustomPaint(
        painter: Painter(offsets: offsetsToDraw),
      ),
    );
  }

  void _simualte(
      {required double start,
      required double end,
      required double step,
      required double perspectiveValue}) async {
    //File properties.
    String documentsPath = (await getApplicationDocumentsDirectory()).path;
    String fileName = _fileNameController.text;
    File file = File('$documentsPath/$fileName.csv');

    //Create file.
    if (!(await file.exists())) {
      //If the file does not exisit yet then append the csv labels
      await file.writeAsString(
        'cp1x,cp1y,cp2x,cp2y,cp3x,cp3y,cp4x,cp4y,angleX,angleY,angleZ\n',
        mode: FileMode.append,
      );
    }

    setState(() {
      offsetsToDraw = [];
    });

    List<double> angles = [
      for (double i = start; i <= end; i += step) i,
    ];

    List<double> perspectives = [
      0.0001,
      0.0002,
    ];

    for (List<vm.Vector3> size in squareSizes) {
      for (vm.Vector3 position in positions) {
        //X//
        for (double angle in angles) {
          List<Offset> offsets = [];
          for (vm.Vector3 corner in size) {
            vm.Vector3 newVector = corner.clone() + position;

            Offset offset = applyMatrices(
                x: angle,
                y: 0,
                z: 0,
                p: double.parse(_perspectiveController.text),
                vector3: newVector.clone());
            offsets.add(offset);
          }

          String result =
              cornerPointsString(offsets: offsets, angle: angle, axis: 'x');

          writeToFile(file, result);

          setState(() {
            offsetsToDraw = offsets;
          });
          await Future.delayed(const Duration(milliseconds: 50));
        }

        //Y
        for (double angle in angles) {
          List<Offset> offsets = [];
          for (vm.Vector3 corner in size) {
            vm.Vector3 newVector = corner.clone() + position;

            Offset offset = applyMatrices(
                x: 0,
                y: angle,
                z: 0,
                p: double.parse(_perspectiveController.text),
                vector3: newVector.clone());
            offsets.add(offset);
          }

          String result =
              cornerPointsString(offsets: offsets, angle: angle, axis: 'y');

          writeToFile(file, result);

          setState(() {
            offsetsToDraw = offsets;
          });
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }
    }
  }

  List<vm.Vector3> positions = [
    vm.Vector3(0, 0, 0),

    ///
    vm.Vector3(0, 100, 0),
    vm.Vector3(100, 0, 0),
    vm.Vector3(100, 100, 0),
    vm.Vector3(-100, 100, 0),
    vm.Vector3(100, -100, 0),
    vm.Vector3(-100, -100, 0),

    ///
    vm.Vector3(0, 200, 0),
    vm.Vector3(200, 0, 0),
    vm.Vector3(200, 200, 0),
    vm.Vector3(-200, 200, 0),
    vm.Vector3(200, -200, 0),
    vm.Vector3(-200, -200, 0),

    ///
    vm.Vector3(0, 300, 0),
    vm.Vector3(300, 0, 0),
    vm.Vector3(300, 300, 0),
    vm.Vector3(-300, 300, 0),
    vm.Vector3(300, -300, 0),
    vm.Vector3(-300, -300, 0),

    ///
    vm.Vector3(0, 400, 0),
    vm.Vector3(400, 0, 0),
    vm.Vector3(400, 400, 0),
    vm.Vector3(-400, 400, 0),
    vm.Vector3(400, -400, 0),
    vm.Vector3(-400, -400, 0),

    ///
    vm.Vector3(0, 500, 0),
    vm.Vector3(500, 0, 0),
    vm.Vector3(500, 500, 0),
    vm.Vector3(-500, 500, 0),
    vm.Vector3(500, -500, 0),
    vm.Vector3(-500, -500, 0),

    ///
    vm.Vector3(0, 500, 0),
    vm.Vector3(500, 0, 0),
    vm.Vector3(500, 500, 0),
    vm.Vector3(-500, 500, 0),
    vm.Vector3(500, -500, 0),
    vm.Vector3(-500, -500, 0),

    ///
    vm.Vector3(0, 500, 0),
    vm.Vector3(500, 0, 0),
    vm.Vector3(500, 500, 0),
    vm.Vector3(-500, 500, 0),
    vm.Vector3(500, -500, 0),
    vm.Vector3(-500, -500, 0),
  ];

  ///List of square Sizes
  List<List<vm.Vector3>> squareSizes = [
    // [
    //   vm.Vector3(-100, -100, 0),
    //   vm.Vector3(100, -100, 0),
    //   vm.Vector3(100, 100, 0),
    //   vm.Vector3(-100, 100, 0),
    // ],
    // [
    //   vm.Vector3(-150, -150, 0),
    //   vm.Vector3(150, -150, 0),
    //   vm.Vector3(150, 150, 0),
    //   vm.Vector3(-150, 150, 0),
    // ],
    // [
    //   vm.Vector3(-200, -200, 0),
    //   vm.Vector3(200, -200, 0),
    //   vm.Vector3(200, 200, 0),
    //   vm.Vector3(-200, 200, 0),
    // ],
    [
      vm.Vector3(-250, -250, 0),
      vm.Vector3(250, -250, 0),
      vm.Vector3(250, 250, 0),
      vm.Vector3(-250, 250, 0),
    ],
    // [
    //   vm.Vector3(-300, -300, 0),
    //   vm.Vector3(300, -300, 0),
    //   vm.Vector3(300, 300, 0),
    //   vm.Vector3(-300, 300, 0),
    // ]
  ];

  ///Supply
  /// x rotation in degrees
  /// y rotation in degrees
  /// z rotation in degrees
  /// p this does the perspective ?
  Offset applyMatrices(
      {required double x,
      required double y,
      required double z,
      required double p,
      required vm.Vector3 vector3}) {
    double xRad = x * pi / 180;
    double yRad = y * pi / 180;
    double zRad = z * pi / 180;

    Matrix4 projection =
        Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, p, 0, 0, 0, 1);

    Matrix4 xRotation = Matrix4(1, 0, 0, 0, 0, cos(xRad), sin(xRad), 0, 0,
        -sin(xRad), cos(xRad), 0, 0, 0, 0, 1);

    Matrix4 yRotation = Matrix4(cos(yRad), 0, -sin(yRad), 0, 0, 1, 0, 0,
        sin(yRad), 0, cos(yRad), 0, 0, 0, 0, 1);

    Matrix4 zRotation = Matrix4(cos(zRad), sin(zRad), 0, 0, -sin(zRad),
        cos(zRad), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);

    vector3.applyMatrix4(xRotation);
    vector3.applyMatrix4(yRotation);
    vector3.applyMatrix4(zRotation);
    vector3.applyProjection(projection);

    return Offset(vector3.x, vector3.y);
  }

  String cornerPointsString({
    required List<Offset> offsets,
    required double angle,
    required String axis,
  }) {
    List<Offset> cp = [
      Offset(offsets[0].dx - offsets[0].dx, offsets[0].dy - offsets[0].dy),
      Offset(offsets[1].dx - offsets[0].dx, offsets[1].dy - offsets[0].dy),
      Offset(offsets[2].dx - offsets[0].dx, offsets[2].dy - offsets[0].dy),
      Offset(offsets[3].dx - offsets[0].dx, offsets[3].dy - offsets[0].dy),
    ];

    if (axis == 'x') {
      return '${cp[0].dx.round()},${cp[0].dy.round()},${cp[1].dx.round()},${cp[1].dy.round()},${cp[2].dx.round()},${cp[2].dy.round()},${cp[3].dx.round()},${cp[3].dy.round()},$angle,0,0\n';
    } else if (axis == 'y') {
      return '${cp[0].dx.round()},${cp[0].dy.round()},${cp[1].dx.round()},${cp[1].dy.round()},${cp[2].dx.round()},${cp[2].dy.round()},${cp[3].dx.round()},${cp[3].dy.round()},0,$angle,0\n';
    } else {
      return '${cp[0].dx.round()},${cp[0].dy.round()},${cp[1].dx.round()},${cp[1].dy.round()},${cp[2].dx.round()},${cp[2].dy.round()},${cp[3].dx.round()},${cp[3].dy.round()},0,0,$angle\n';
    }
  }

  void writeToFile(File data, String result) async {
    d.log(result);
    await data.writeAsString(
      result,
      mode: FileMode.append,
    );
  }
}
