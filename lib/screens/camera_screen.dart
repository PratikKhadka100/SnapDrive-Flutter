import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import './orientation_screen.dart';
// import '../widgets/prediction_item_widget.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/prediction_box_widget.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera-screen';

  final List<CameraDescription> cameras;

  const CameraScreen({required this.cameras, super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  CameraImage? cameraImage;
  var predictedLabel = '';
  var predictedConfidence = '';
  Rect? detectedObjectRect;

  List<dynamic> predictionList = [];

  var isCar = false;

  var isModalRunning = false;

  @override
  void initState() {
    super.initState();

    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    Tflite.close();
  }

  void loadCamera() {
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
      // imageFormatGroup: ImageFormatGroup.yuv420,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {
        controller.startImageStream(
          (imageStream) {
            cameraImage = imageStream;
            runModel();
          },
        );
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Camera Access Denied'),
                content: const Text(
                  'Please allow camera access in the device settings.',
                ),
                actions: [
                  MaterialButton(
                    color: Theme.of(ctx).primaryColor,
                    onPressed: () => Navigator.of(ctx).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => const HomeScreen(),
                      ),
                    ),
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
            break;
          default:
            // Handle other errors here.
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Error!'),
                content: const Text(
                  'An error occurred while initializing the camera.',
                ),
                actions: [
                  MaterialButton(
                    color: Theme.of(ctx).primaryColor,
                    onPressed: () => Navigator.of(ctx).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => const SplashScreen(),
                      ),
                    ),
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
            break;
        }
      }
    });
  }

  void runModel() {
    if (isModalRunning) {
      return;
    }

    isModalRunning = true;

    if (cameraImage != null) {
      // Tflite.runModelOnFrame(
      Tflite.detectObjectOnFrame(
        bytesList: cameraImage!.planes
            .map(
              (e) => e.bytes,
            )
            .toList(),
        model: 'SSDMobileNet',
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        // imageMean: 0.0,
        // imageStd: 255.0,
        // rotation: 90,
        // numResults: 2,
        threshold: 0.5,
        // asynch: true,
      ).then((prediction) {
        print('-------------------------');
        print(prediction);
        print('-------------------------');
        // for (var predict in prediction!) {
        setState(() {
          // predictedResult = predict['label'];
          if (prediction!.isEmpty) {
            predictedLabel = '';
            predictedConfidence = '';

            return;
          }

          predictionList = prediction;

          predictedLabel = prediction[0]['detectedClass'];

          if (predictedLabel == 'car') {
            setState(() {
              isCar = true;
            });
          } else {
            setState(() {
              isCar = false;
            });
          }
          // predictedConfidence =
          //     ((prediction[0]['confidenceInClass'] * 100 as double)
          //         .toStringAsFixed(0)
          //         .toString());
          // detectedObjectRect = Rect.fromLTRB(
          //   prediction[0]['rect']['x'] * controller.value.previewSize!.width,
          //   prediction[0]['rect']['y'] * controller.value.previewSize!.height,
          //   (prediction[0]['rect']['x'] + prediction[0]['rect']['w']) *
          //       controller.value.previewSize!.width,
          //   (prediction[0]['rect']['y'] + prediction[0]['rect']['h']) *
          //       controller.value.previewSize!.height,
          // );
        });
        // }
        isModalRunning = false;
      });
    }
  }

  void loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
        // model: 'assets/orientation.tflite',
        // labels: 'assets/orientation.txt',
        model: 'assets/ssd_mobilenet.tflite',
        labels: 'assets/ssd_mobilenet.txt',
      );
    } on PlatformException {
      showDialog(
        context: context,
        builder: (ctx) => const AlertDialog(
          title: Text('Error Occurred!'),
          content: Text('Failed to load the model'),
        ),
      );
    }
  }

  void stopModel() {
    isModalRunning = true;
    controller.stopImageStream();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (context) {
              return const ProgressIndicatorWidget();
            });
        stopModel();
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        });
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: !controller.value.isInitialized
              ? const ProgressIndicatorWidget()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: CameraPreview(
                            controller,
                            child: PredictionBoxWidget(
                              results: predictionList,
                              previewH: math.max(
                                controller.value.previewSize!.height,
                                controller.value.previewSize!.width,
                              ),
                              previewW: math.min(
                                controller.value.previewSize!.height,
                                controller.value.previewSize!.width,
                              ),
                              screenH: screen.height * 0.75,
                              screenW: screen.width,
                            ),
                            // child: PredictionItemWidget(
                            //   predictedLabel: predictedLabel,
                            //   predictedConfidence: predictedConfidence,
                            //   detectedObjectRect: detectedObjectRect,
                            // ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Colors.black,
                        child: isCar
                            ? IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const ProgressIndicatorWidget();
                                      });
                                  stopModel();
                                  Future.delayed(const Duration(seconds: 5),
                                      () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrientationScreen(
                                          cameras: widget.cameras,
                                          controller: controller,
                                          cameraImage: cameraImage,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_circle_right_rounded,
                                  color: Colors.white,
                                  size: 55,
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
