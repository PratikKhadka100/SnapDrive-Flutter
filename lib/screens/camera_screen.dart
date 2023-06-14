import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
  var output = '';

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void loadCamera() {
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        // controller.startImageStream(
        //   (imageStream) {
        //     cameraImage = imageStream;
        //     // runModel();
        //   },
        // );
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
                    'Please allow camera access in the device settings.'),
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
                    'An error occurred while initializing the camera.'),
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

  // void runModel() async {
  //   if (cameraImage != null) {
  //     var predictions = await Tflite.runModelOnFrame(
  //       bytesList: cameraImage!.planes
  //           .map(
  //             (e) => e.bytes,
  //           )
  //           .toList(),
  //       imageHeight: cameraImage!.height,
  //       imageWidth: cameraImage!.width,
  //       imageMean: 0.0,
  //       imageStd: 255.0,
  //       rotation: 90,
  //       numResults: 2,
  //       threshold: 0.2,
  //       asynch: true,
  //     );
  //     print('-------------------------');
  //     print(predictions);
  //     print('-------------------------');
  //     // for (var element in predictions!) {
  //     //   setState(() {
  //     //     output = element['label'];
  //     //   });
  //     // }
  //   }
  // }

  void runModel(String imagePath) async {
    print('------------------------------');
    print('runModel()');
    print('------------------------------');
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 5,
      imageMean: 0.0,
      imageStd: 255.0,
      threshold: 0.2,
      asynch: true,
    );
    print('---------------');
    print(recognitions);
    print('---------------');
  }

  void loadModel() async {
    await Tflite.loadModel(
      model: "assets/detect.tflite",
      labels: "assets/labelmap.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: !controller.value.isInitialized
          ? const ProgressIndicatorWidget()
          : SizedBox(
              width: double.infinity,
              child: CameraPreview(controller),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          final image = await controller.takePicture();
          runModel(image.path);
          // print(image.path);
        },
        child: Icon(
          Icons.camera,
          color: Theme.of(context).colorScheme.secondary,
          size: 50,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
