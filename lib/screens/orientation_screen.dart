// import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
// import '../widgets/prediction_item_widget.dart';
import '../widgets/progress_indicator_widget.dart';
// import '../widgets/prediction_box_widget.dart';

class OrientationScreen extends StatefulWidget {
  static const routeName = '/orientation-screen';

  final List<CameraDescription> cameras;
  late CameraController controller;
  CameraImage? cameraImage;

  OrientationScreen({
    required this.cameras,
    required this.controller,
    required this.cameraImage,
    super.key,
  });

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  // late CameraController controller;
  // CameraImage? cameraImage;
  var predictedLabel = '';
  var predictedConfidence = '';
  Rect? detectedObjectRect;

  List<dynamic> predictionList = [];

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
    widget.controller.dispose();
    Tflite.close();
  }

  void loadCamera() {
    widget.controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
      // imageFormatGroup: ImageFormatGroup.yuv420,
    );
    widget.controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {
        widget.controller.startImageStream(
          (imageStream) {
            widget.cameraImage = imageStream;
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

    if (widget.cameraImage != null) {
      Tflite.runModelOnFrame(
        // Tflite.detectObjectOnFrame(
        bytesList: widget.cameraImage!.planes
            .map(
              (e) => e.bytes,
            )
            .toList(),
        // model: 'SSDMobileNet',
        imageHeight: widget.cameraImage!.height,
        imageWidth: widget.cameraImage!.width,
        // imageMean: 0.0,
        // imageStd: 255.0,
        // rotation: 90,
        numResults: 2,
        threshold: 0.2,
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

          // predictionList = prediction;

          predictedLabel = prediction[0]['label'];

          predictedConfidence = ((prediction[0]['confidence'] * 100 as double)
              .toStringAsFixed(0)
              .toString());
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
        model: 'assets/orientation.tflite',
        labels: 'assets/orientation.txt',
        // model: 'assets/ssd_mobilenet.tflite',
        // labels: 'assets/ssd_mobilenet.txt',
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
    widget.controller.stopImageStream();
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
          body: !widget.controller.value.isInitialized
              ? const ProgressIndicatorWidget()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: widget.controller.value.aspectRatio,
                          child: CameraPreview(
                            widget.controller,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'View: $predictedLabel',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Confidence: $predictedConfidence%',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            // child: PredictionBoxWidget(
                            //   results: predictionList,
                            //   previewH: math.max(
                            //     controller.value.previewSize!.height,
                            //     controller.value.previewSize!.width,
                            //   ),
                            //   previewW: math.min(
                            //     controller.value.previewSize!.height,
                            //     controller.value.previewSize!.width,
                            //   ),
                            //   screenH: screen.height * 0.75,
                            //   screenW: screen.width,
                            // ),
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
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 65,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
