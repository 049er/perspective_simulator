// ignore_for_file: unnecessary_import, depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perspective_simulator/classes/matrix_3x4.dart';
import 'package:perspective_simulator/classes/sqaure.dart';
import 'package:perspective_simulator/constants/opencv_matrix.dart';
import 'package:perspective_simulator/extentions/vector3_extention.dart';
import 'package:perspective_simulator/functions/export.dart';
import 'package:perspective_simulator/functions/probe_functions.dart';
import 'package:perspective_simulator/simulator/painter.dart';
import 'package:perspective_simulator/widgets/custom_container.dart';
import 'package:perspective_simulator/widgets/custom_icon_button.dart';
import 'package:perspective_simulator/widgets/custom_text_button.dart';
import 'package:perspective_simulator/widgets/custom_text_field.dart';
import 'package:perspective_simulator/widgets/custom_triple_text_field.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class SimulatorV5 extends StatefulWidget {
  const SimulatorV5({Key? key}) : super(key: key);

  @override
  State<SimulatorV5> createState() => _SimulatorV5State();
}

class _SimulatorV5State extends State<SimulatorV5> {
  //Image Setup
  double imageHeight = 1280;
  double imageWidth = 720;

  //Controller
  final TextEditingController _sizeController = TextEditingController();
  double sizeUser = 80;
  double deltaStepUser = 5;
  double angleStepUser = 5;
  //Position
  double xTranslationUser = 0;
  double yTranslationUser = 0;
  double zTranslationUser = 100;
  //Angle
  double xRotationUser = 0;
  double yRotationUser = 0;
  double zRotationUser = 0;

  List<Square> sqauresToDraw = [];

  //Simulation
  final TextEditingController _fileName = TextEditingController();
  final TextEditingController _sSize = TextEditingController();
  final TextEditingController _sTranslationScale = TextEditingController();

  final TextEditingController _sZStart = TextEditingController();
  final TextEditingController _sZEnd = TextEditingController();
  final TextEditingController _szStep = TextEditingController();

  final TextEditingController _sRotationStart = TextEditingController();
  final TextEditingController _sRotationEnd = TextEditingController();
  final TextEditingController _sRotationStep = TextEditingController();

  final TextEditingController _sSpeed = TextEditingController();

  String fileName = 'training_data';
  double sSize = 80;
  double zStart = 150;
  double zEnd = 500;
  double zStep = 50;
  double rotStart = -75;
  double rotEnd = 75;
  double rotStep = 5;
  int sSpeed = 20;
  double sTranslationScale = 20;

  bool stopSimulation = false;
  double currentZTranslation = 0;
  double currentXRotation = 0;

  @override
  void initState() {
    _sizeController.text = sizeUser.toString();
    _fileName.text = fileName;
    _sSize.text = sSize.toString();
    _sSpeed.text = sSpeed.toString();
    _sZStart.text = zStart.toString();
    _sZEnd.text = zEnd.toString();
    _sRotationStart.text = rotStart.toString();
    _sRotationEnd.text = rotEnd.toString();
    _sTranslationScale.text = sTranslationScale.toString();
    _sRotationStep.text = rotStep.toString();
    _szStep.text = zStep.toString();
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
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _body() {
    return Row(
      children: [
        _leftPane(),
        _rightPane(),
      ],
    );
  }

  Widget _leftPane() {
    return CustomContainer(
      width: MediaQuery.of(context).size.width / 3,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Image Pane'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: CustomPaint(
              painter: Painter(
                sqaures: sqauresToDraw,
                imageHeight: imageHeight,
                imageWidth: imageWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightPane() {
    return CustomContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _display(),
            _controller(),
            _simulationController(),
          ],
        ),
      ),
    );
  }

  ///Display of the Position and angle + step size
  Widget _display() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              'Position: $xTranslationUser, $yTranslationUser, $zTranslationUser',
              style: const TextStyle(fontSize: 16),
            ),
            Text('Step: $deltaStepUser'),
          ],
        ),
        const SizedBox(
          width: 100,
        ),
        Column(
          children: [
            Text(
              'angle: $xRotationUser, $yRotationUser, $zRotationUser',
              style: const TextStyle(fontSize: 16),
            ),
            Text('Step: $angleStepUser'),
          ],
        ),
      ],
    );
  }

  ///User Inputs.
  Widget _controller() {
    return CustomContainer(
      width: MediaQuery.of(context).size.width / 1.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Buttons for changing position and angle + step size.
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Position
                  CustomIconButton(
                    icon: Icons.keyboard_arrow_left_rounded,
                    onPressed: () {
                      setState(() {
                        xTranslationUser = xTranslationUser - deltaStepUser;
                        _userInput();
                      });
                    },
                  ),
                  Column(
                    children: [
                      CustomIconButton(
                        icon: Icons.keyboard_arrow_up_rounded,
                        onPressed: () {
                          setState(() {
                            yTranslationUser = yTranslationUser - deltaStepUser;
                            _userInput();
                          });
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomIconButton(
                        icon: Icons.keyboard_arrow_down_rounded,
                        onPressed: () {
                          setState(() {
                            yTranslationUser = yTranslationUser + deltaStepUser;
                            _userInput();
                          });
                        },
                      ),
                    ],
                  ),
                  CustomIconButton(
                    icon: Icons.keyboard_arrow_right_rounded,
                    onPressed: () {
                      setState(() {
                        xTranslationUser = xTranslationUser + deltaStepUser;
                        _userInput();
                      });
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      CustomTextButton(
                        label: 'forward',
                        onPressed: () {
                          setState(() {
                            zTranslationUser = zTranslationUser - deltaStepUser;
                            _userInput();
                          });
                        },
                      ),
                      CustomTextButton(
                        label: 'backwards',
                        onPressed: () {
                          setState(() {
                            zTranslationUser = zTranslationUser + deltaStepUser;
                            _userInput();
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomTextButton(
                        label: '+Step',
                        onPressed: () {
                          setState(() {
                            deltaStepUser = deltaStepUser + 5;
                            _userInput();
                          });
                        },
                      ),
                      CustomTextButton(
                        label: '-Step',
                        onPressed: () {
                          setState(() {
                            deltaStepUser = deltaStepUser - 5;
                            _userInput();
                          });
                        },
                      ),
                    ],
                  ),
                  const VerticalDivider(),

                  Column(
                    children: [
                      Row(
                        children: [
                          //Angle
                          Column(
                            children: [
                              CustomTextButton(
                                label: '+X',
                                onPressed: () {
                                  setState(() {
                                    xRotationUser =
                                        xRotationUser + angleStepUser;
                                    _userInput();
                                  });
                                },
                              ),
                              CustomTextButton(
                                label: '-X',
                                onPressed: () {
                                  setState(() {
                                    xRotationUser =
                                        xRotationUser - angleStepUser;
                                    _userInput();
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              CustomTextButton(
                                label: '+Y',
                                onPressed: () {
                                  setState(() {
                                    yRotationUser =
                                        yRotationUser + angleStepUser;
                                    _userInput();
                                  });
                                },
                              ),
                              CustomTextButton(
                                label: '-Y',
                                onPressed: () {
                                  setState(() {
                                    yRotationUser =
                                        yRotationUser - angleStepUser;
                                    _userInput();
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              CustomTextButton(
                                label: '+Z',
                                onPressed: () {
                                  setState(() {
                                    zRotationUser =
                                        zRotationUser + angleStepUser;
                                    _userInput();
                                  });
                                },
                              ),
                              CustomTextButton(
                                label: '-Z',
                                onPressed: () {
                                  setState(() {
                                    zRotationUser =
                                        zRotationUser - angleStepUser;
                                    _userInput();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomTextButton(
                            label: '+Step',
                            onPressed: () {
                              setState(() {
                                angleStepUser = angleStepUser + 5;
                                _userInput();
                              });
                            },
                          ),
                          CustomTextButton(
                            label: '-Step',
                            onPressed: () {
                              setState(() {
                                angleStepUser = angleStepUser - 5;
                                _userInput();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            //Text Input for square size.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Size'),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextField(
                      controller: _sizeController,
                      onChanged: (value) {
                        sizeUser = double.tryParse(value) ?? 80;
                      },
                    ),
                  ),
                  const Text('mm'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Simulation Inputs.
  Widget _simulationController() {
    return CustomContainer(
      width: MediaQuery.of(context).size.width / 1.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Simulation',
              style: TextStyle(fontSize: 16),
            ),
            Text('Z: $currentZTranslation,   Rot: $currentXRotation'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _runSimulation();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                  child: const Text('Run'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      stopSimulation = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                  child: const Text('Stop'),
                ),
              ],
            ),
            const Divider(),
            CustomTextField(
              label: 'Square Size: ',
              suffix: 'mm',
              controller: _sSize,
              onChanged: (val) {
                setState(() {
                  sSize = double.tryParse(val) ?? 80;
                  log(sSize.toString());
                });
              },
            ),
            CustomTextField(
              label: 'Tanslation Scale: ',
              suffix: '(Bigger is smaller steps)',
              controller: _sTranslationScale,
              onChanged: (val) {
                setState(() {
                  sTranslationScale = double.tryParse(val) ?? 20;
                  log(sTranslationScale.toString());
                });
              },
            ),
            CustomTripleTextField(
              controller1: _sZStart,
              onChanged1: (val) {
                setState(() {
                  zStart = double.tryParse(val) ?? 150;
                  log(zStart.toString());
                });
              },
              label1: 'Z Start: ',
              suffix1: 'mm',
              controller2: _sZEnd,
              onChanged2: (val) {
                setState(() {
                  zEnd = double.tryParse(val) ?? 500;
                  log(zEnd.toString());
                });
              },
              label2: 'Z End: ',
              suffix2: 'mm',
              controller3: _szStep,
              onChanged3: (val) {
                setState(() {
                  zStep = double.tryParse(val) ?? 150;
                  log(zStep.toString());
                });
              },
              label3: 'Z Step: ',
              suffix3: 'mm',
            ),
            CustomTripleTextField(
              controller1: _sRotationStart,
              onChanged1: (val) {
                setState(() {
                  rotStart = double.tryParse(val) ?? -75;
                  log(rotStart.toString());
                });
              },
              label1: 'Rotation Start: ',
              suffix1: 'Deg',
              controller2: _sRotationEnd,
              onChanged2: (val) {
                setState(() {
                  rotStart = double.tryParse(val) ?? 75;
                  log(rotStart.toString());
                });
              },
              label2: 'Rotation End: ',
              suffix2: 'Deg',
              controller3: _sRotationStep,
              onChanged3: (val) {
                setState(() {
                  rotStep = double.tryParse(val) ?? 75;
                  log(rotStep.toString());
                });
              },
              label3: 'Rotation Step: ',
              suffix3: 'Deg',
            ),
            CustomTextField(
              label: 'Simulation Speed: ',
              suffix: 'millis',
              controller: _sSpeed,
              onChanged: (val) {
                setState(() {
                  sSpeed = int.tryParse(val) ?? 20;
                  log(sSpeed.toString());
                });
              },
            ),
            CustomTextField(
              label: 'File name: ',
              suffix: '.csv',
              controller: _fileName,
              onChanged: (val) {
                setState(() {
                  fileName = val;
                });
                log(fileName);
              },
            ),
          ],
        ),
      ),
    );
  }

  ///Calculate the screen points from the user inputs.
  void _userInput() {
    //1. Clear sqauresToDraw
    _clearSqaures();

    //2. Generate world points
    List<vm.Vector4> worldPoints = generateWorldPoints(sizeUser / 2, 0, 0, 0);

    //3. Calculate the screen points
    List<vm.Vector3> w = worldPoints.map((e) {
      //i. Dot the extrinsic matrix (R|T) with worldPoint.
      vm.Vector3 point = Matrix3x4(
              xRotation: xRotationUser,
              yRotation: yRotationUser,
              zRotation: zRotationUser,
              xTranslation: xTranslationUser,
              yTranslation: yTranslationUser,
              zTranslation: zTranslationUser)
          .dot(e);

      //ii. Dot the product with the camera matrix (K).
      return point.dotOpenCV(cameraMatrix);
    }).toList();

    //4. Add the sqaure to the
    _addSqaure(Square(w));
  }

  void _runSimulation() async {
    log('running');

    //1. Distances to test for.
    List<double> zTranslations = [
      for (double i = zStart; i <= zEnd; i += zStep) i
    ];

    //2. All the x-rotations.
    List<double> xRotations = [
      for (double i = rotStart; i <= rotEnd; i += rotStep) i
    ];

    //2. All the y-rotations.
    List<double> yRotations = [
      for (double i = rotStart; i <= rotEnd; i += rotStep) i
    ];

    //3. Get the world points
    List<vm.Vector4> worldPoints = generateWorldPoints(sSize / 2, 0, 0, 0);

    //4. Loop through all zTranslations
    for (double zTranslation in zTranslations) {
      //5. Calculate the step to be used for this zTranslation.
      double translationStep = zTranslation / sTranslationScale;

      //6. Update UI
      setState(() {
        currentZTranslation = zTranslation;
      });

      //6. Loop through all the X angles to be simulated.
      for (double xRotation in xRotations) {
        setState(() {
          currentXRotation = xRotation;
        });

        //i. Probe the x and y ranges.
        double yMax = probeY(
            worldPoints: worldPoints,
            imageHeight: imageHeight,
            xRotation: xRotation,
            yRotation: 0,
            zRotation: 0,
            zTranslation: zTranslation);

        double xMax = probeX(
            worldPoints: worldPoints,
            imageHeight: imageWidth,
            xRotation: xRotation,
            yRotation: 0,
            zRotation: 0,
            zTranslation: zTranslation);

        double xMin = -xMax;
        double yMin = -yMax;

        //ii. Generate X and Y ranges
        List<double> xRange = [
          for (double i = xMin; i <= xMax; i += translationStep) i
        ];

        List<double> yRange = [
          for (double i = yMin; i <= yMax; i += translationStep) i
        ];

        for (var xTranslation in xRange) {
          for (var yTranslation in yRange) {
            //iii. Clone world points
            List<vm.Vector4> clones = [
              worldPoints[0].clone(),
              worldPoints[1].clone(),
              worldPoints[2].clone(),
              worldPoints[3].clone(),
            ];

            //iv. Calcualte screen points.
            List<vm.Vector3> w = clones.map((e) {
              //v. Dot the extrinsic matrix (R|T) with worldPoint.
              vm.Vector3 point = Matrix3x4(
                      xRotation: xRotation,
                      yRotation: 0,
                      zRotation: 0,
                      xTranslation: xTranslation,
                      yTranslation: yTranslation,
                      zTranslation: zTranslation)
                  .dot(e);

              //vi. Dot the product with the camera matrix (K).
              return point.dotOpenCV(cameraMatrix);
            }).toList();

            vm.Vector3 leftV = w[1] - w[2];
            vm.Vector3 rightV = w[0] - w[3];

            double top = (w[0] - w[1]).length;
            double right = (w[1] - w[2]).length;
            double bot = (w[2] - w[3]).length;
            double left = (w[3] - w[0]).length;

            double aveX = (top + bot) / 2;
            double aveY = (left + right) / 2;

            double aspect = aveX / aveY;

            if (leftV.y < 0 || rightV.y < 0) {
              if (aspect >= 0.25 || aspect <= 3) {
                //vii. Chack that the results fall within image frame.
                if (w[0].x > 0 &&
                    w[0].x < imageWidth &&
                    w[1].x > 0 &&
                    w[1].x < imageWidth &&
                    w[2].x > 0 &&
                    w[2].x < imageWidth &&
                    w[3].x > 0 &&
                    w[3].x < imageWidth &&
                    w[0].y < imageHeight &&
                    w[0].y > 0 &&
                    w[1].y < imageHeight &&
                    w[1].y > 0 &&
                    w[2].y < imageHeight &&
                    w[2].y > 0 &&
                    w[3].y < imageHeight &&
                    w[3].y > 0) {
                  //viii. Write results to file.
                  String results =
                      '${w[0].x.toStringAsFixed(2)}, ${w[0].y.toStringAsFixed(2)},${w[1].x.toStringAsFixed(2)}, ${w[1].y.toStringAsFixed(2)},${w[2].x.toStringAsFixed(2)}, ${w[2].y.toStringAsFixed(2)},${w[3].x.toStringAsFixed(2)}, ${w[3].y.toStringAsFixed(2)},$xRotation,0,0\n';
                  writeToFile(results);

                  //ix. Add the sqaure so it can be drawn.
                  _addSqaure(Square(w));

                  //x. Wait a little bit.
                  await Future.delayed(Duration(milliseconds: sSpeed));

                  //xi. Clear canvas.
                  _clearSqaures();
                }
              }
            }

            if (stopSimulation == true) {
              break;
            }
          }
          if (stopSimulation == true) {
            break;
          }
        }
        if (stopSimulation == true) {
          break;
        }
      }

      //6. Loop through all the Y angles to be simulated.
      for (double yRotation in yRotations) {
        setState(() {
          currentXRotation = yRotation;
        });

        //7. Probe the x and y ranges.
        double yMax = probeY(
            worldPoints: worldPoints,
            imageHeight: imageHeight,
            xRotation: 0,
            yRotation: yRotation,
            zRotation: 0,
            zTranslation: zTranslation);

        double xMax = probeX(
            worldPoints: worldPoints,
            imageHeight: imageWidth,
            xRotation: 0,
            yRotation: yRotation,
            zRotation: 0,
            zTranslation: zTranslation);

        double xMin = -xMax;
        double yMin = -yMax;

        //8. Generate X and Y ranges
        List<double> xRange = [
          for (double i = xMin; i <= xMax; i += translationStep) i
        ];

        List<double> yRange = [
          for (double i = yMin; i <= yMax; i += translationStep) i
        ];

        for (var xTranslation in xRange) {
          for (var yTranslation in yRange) {
            //9. Clone world points
            List<vm.Vector4> clones = [
              worldPoints[0].clone(),
              worldPoints[1].clone(),
              worldPoints[2].clone(),
              worldPoints[3].clone(),
            ];

            //10. Calcualte screen points.
            List<vm.Vector3> w = clones.map((e) {
              //11. Dot the extrinsic matrix (R|T) with worldPoint.
              vm.Vector3 point = Matrix3x4(
                      xRotation: 0,
                      yRotation: yRotation,
                      zRotation: 0,
                      xTranslation: xTranslation,
                      yTranslation: yTranslation,
                      zTranslation: zTranslation)
                  .dot(e);

              //12. Dot the product with the camera matrix (K).
              return point.dotOpenCV(cameraMatrix);
            }).toList();

            // 'TL', 'TR', 'BR', 'BL'
            vm.Vector3 topV = w[0] - w[1];
            vm.Vector3 botV = w[3] - w[2];

            double top = (w[0] - w[1]).length;
            double right = (w[1] - w[2]).length;
            double bot = (w[2] - w[3]).length;
            double left = (w[3] - w[0]).length;

            double aveX = (top + bot) / 2;
            double aveY = (left + right) / 2;

            double aspect = aveX / aveY;

            if (topV.x < 0 || botV.x < 0) {
              if (aspect >= 0.25 || aspect <= 3) {
                //13. Chack that the results fall within image frame.
                if (w[0].x > 0 &&
                    w[0].x < imageWidth &&
                    w[1].x > 0 &&
                    w[1].x < imageWidth &&
                    w[2].x > 0 &&
                    w[2].x < imageWidth &&
                    w[3].x > 0 &&
                    w[3].x < imageWidth &&
                    w[0].y < imageHeight &&
                    w[0].y > 0 &&
                    w[1].y < imageHeight &&
                    w[1].y > 0 &&
                    w[2].y < imageHeight &&
                    w[2].y > 0 &&
                    w[3].y < imageHeight &&
                    w[3].y > 0) {
                  //14. Write results to file.
                  String results =
                      '${w[0].x.toStringAsFixed(2)}, ${w[0].y.toStringAsFixed(2)},${w[1].x.toStringAsFixed(2)}, ${w[1].y.toStringAsFixed(2)},${w[2].x.toStringAsFixed(2)}, ${w[2].y.toStringAsFixed(2)},${w[3].x.toStringAsFixed(2)}, ${w[3].y.toStringAsFixed(2)},0,$yRotation,0\n';
                  writeToFile(results);

                  //15. Add the sqaure so it can be drawn.
                  _addSqaure(Square(w));

                  //16. Wait a little bit.
                  await Future.delayed(Duration(milliseconds: sSpeed));

                  //17. Clear canvas.
                  _clearSqaures();
                }
              }
            }

            if (stopSimulation == true) {
              break;
            }
          }
          if (stopSimulation == true) {
            break;
          }
        }
        if (stopSimulation == true) {
          break;
        }
      }

      if (stopSimulation == true) {
        setState(() {
          stopSimulation = false;
        });
        break;
      }
    }
  }

  ///Add the square to the list.
  void _addSqaure(Square square) {
    setState(() {
      sqauresToDraw.add(square);
    });
  }

  ///Clear the list.
  void _clearSqaures() {
    setState(() {
      sqauresToDraw.clear();
    });
  }

  ///Write to csv
  void writeToFile(String result) async {
    String documentsPath = (await getApplicationDocumentsDirectory()).path;
    String fileName = _fileName.text;
    File file = File('$documentsPath/$fileName.csv');

    //Create file.
    if (!(await file.exists())) {
      //If the file does not exisit yet then append the csv labels
      await file.writeAsString(
        'cp1x,cp1y,cp2x,cp2y,cp3x,cp3y,cp4x,cp4y,angleX,angleY,angleZ\n',
        mode: FileMode.append,
      );
    }

    await file.writeAsString(
      result,
      mode: FileMode.append,
    );
  }
}
