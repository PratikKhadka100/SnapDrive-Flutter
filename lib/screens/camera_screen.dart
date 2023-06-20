import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../widgets/progress_indicator_widget.dart';

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
  var predictedResult = '';
  var predictedConfidence = '';

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
            Future.delayed(const Duration(seconds: 2), () {
              runModel();
            });
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
    // print('runModel()');
    // print(isModalRunning);
    if (isModalRunning) {
      // print('Modal already running');
      return;
    }
    // print('Modal starts running');
    isModalRunning = true;

    if (cameraImage != null) {
      // Tflite.runModelOnFrame(
      Tflite.detectObjectOnFrame(
        bytesList: cameraImage!.planes
            .map(
              (e) => e.bytes,
            )
            .toList(),
        model: 'YOLO',
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        // imageMean: 0.0,
        // imageStd: 255.0,
        // rotation: 90,
        // numResults: 2,
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
            predictedResult = '';
            predictedConfidence = '';

            return;
          }
          predictedResult = prediction[0]['detectedClass'];
          predictedConfidence = ((prediction[0]['confidenceInClass'] as double)
              .toStringAsFixed(2)
              .toString());
        });
        // }
        isModalRunning = false;
      });
    }
    // print('Run modal stopped');
  }

  // void runModel(String imagePath) async {
  //   print('------------------------------');
  //   print(imagePath);
  //   print('runModel()');
  //   print('------------------------------');
  //   var recognitions = await Tflite.runModelOnImage(
  //     path: imagePath,
  //     numResults: 2,
  //     imageMean: 0.0,
  //     imageStd: 255.0,
  //     threshold: 0.2,
  //     asynch: true,
  //   );
  //   print('---------------');
  //   print(recognitions);
  //   print('---------------');
  // }

  void loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
        // model: 'assets/ssd_mobilenet.tflite',
        // labels: 'assets/ssd_mobilenet.txt',
        model: 'assets/yolov2_tiny.tflite',
        labels: 'assets/yolov2_tiny.txt',
      );
    } on PlatformException {
      // print('---------------Failed to load the model----------------');
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: !controller.value.isInitialized
            ? const ProgressIndicatorWidget()
            : Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: double.infinity,
                    child: CameraPreview(
                      controller,
                      child: Column(
                        children: [
                          Text(
                            'Object: $predictedResult',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Confidence: $predictedConfidence',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
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
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.black,
        //   onPressed: () {},
        //   // onPressed: () async {
        //   //   final image = await controller.takePicture();
        //   //   runModel(image.path);
        //   //   // print(image.path);
        //   // },
        //   child: Icon(
        //     Icons.camera,
        //     size: MediaQuery.of(context).size.width * 0.15,
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
