// import 'dart:math';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
// import 'package:matrix2d/matrix2d.dart';
// import 'package:image/image.dart' as img;

import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/orientation_prediction_widget.dart';
import '../utils/dialog_utils.dart';

class OrientationScreen extends StatefulWidget {
  static const routeName = '/orientation-screen';

  final List<CameraDescription> cameras;
  // late CameraController controller;
  // CameraImage? cameraImage;

  const OrientationScreen({
    required this.cameras,
    // required this.controller,
    // required this.cameraImage,
    super.key,
  });

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  late CameraController controller;
  CameraImage? cameraImage;

  var predictedLabel = '';
  var predictedConfidence = '';
  Rect? detectedObjectRect;

  List<dynamic> predictionList = [];
  List<Uint8List> imgList = [];

  var isModalRunning = false;

  final shift = (0xFF << 24);

  @override
  void initState() {
    super.initState();

    _loadCamera();
    _loadModel();
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
    Tflite.close();
  }

  // Future<List<Uint8List>?> convertYUV420toImageColor(CameraImage image) async {
  //   try {
  //     final int width = image.width;
  //     final int height = image.height;
  //     final int uvRowStride = image.planes[1].bytesPerRow;
  //     final int? uvPixelStride = image.planes[1].bytesPerPixel;

  //     var img = imglib.Image(height, width); // Create Image buffer

  //     // Fill image buffer with plane[0] from YUV420_888
  //     for (int x = 0; x < width; x++) {
  //       for (int y = 0; y < height; y++) {
  //         final int uvIndex =
  //             uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
  //         final int index = y * width + x;

  //         final yp = image.planes[0].bytes[index];
  //         final up = image.planes[1].bytes[uvIndex];
  //         final vp = image.planes[2].bytes[uvIndex];
  //         // Calculate pixel color
  //         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
  //         int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
  //             .round()
  //             .clamp(0, 255);
  //         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
  //         // color: 0x FF  FF  FF  FF
  //         //           A   B   G   R
  //         if (img.isBoundsSafe(height - y, x)) {
  //           img.setPixelRgba(height - y, x, r, g, b, shift);
  //         }
  //       }
  //     }

  //     // var png = imglib.encodePng(img);
  //     // var decodedPng = imglib.decodePng(png);

  //     var resizedPng = imglib.copyResize(img, width: 192, height: 192);
  //     var encodedPng = imglib.encodePng(resizedPng);

  //     imgList.add(encodedPng);

  //     return imgList;

  //     // imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
  //     // List<int> png = pngEncoder.encodeImage(img);
  //     // muteYUVProcessing = false;
  //     // return Image.memory(png);
  //   } catch (e) {
  //     print(">>>>>>>>>>>> ERROR:" + e.toString());
  //   }

  //   return null;
  // }

  void _loadCamera() {
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
      // imageFormatGroup: ImageFormatGroup.jpeg,
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
            _runModel();
          },
        );
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            DialogUtils.showDialogHandler(
              context,
              const Text('Camera Access Denied'),
              const Text('Please allow camera access in the device settings.'),
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              ),
            );
            break;
          default:
            DialogUtils.showDialogHandler(
              context,
              const Text('Error!'),
              const Text(
                'An error occurred while initializing the camera.',
              ),
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
              ),
            );
            break;
        }
      }
    });
  }

  void _runModel() async {
    if (isModalRunning) {
      return;
    }

    isModalRunning = true;

    if (cameraImage != null) {
      // var imgByteList = cameraImage!.planes
      //     .map(
      //       (e) => e.bytes,
      //     )
      //     .toList();

      // print(imgByteList[0].shape);
      // print(imgByteList.length);
      // ImageFormat format = cameraImage!.format;
      // print(format.group.toString());

      // print('xxxxxxxxxxx-top-xxxxxxxxxxxx');
      // var imgColor = await convertYUV420toImageColor(cameraImage!);
      // print(imgColor);
      // print('xxxxxxxxxxxx-bottom-xxxxxxxxxxx');

      // for (var i = 0; i < imgByteList.length; i++) {
      //   var png = img.decodeJpg(imgByteList[i]);
      //   print(png);
      //   var resizedPng = img.copyResize(png!, width: 192, height: 192);
      //   var encodedPng = img.encodeJpg(resizedPng);

      //   imgList.add(encodedPng);
      // }
      // print(imgList.shape);
      // print('Image List[0]: ${imgList[0].shape}');
      Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes
            .map(
              (e) => e.bytes,
            )
            .toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        numResults: 2,
        threshold: 0.2,
      )
          // Tflite.runModelOnBinary(
          //   binary: imgList[0],
          //   numResults: 2,
          //   threshold: 0.2,
          // )
          .then((prediction) {
        print('-------------------------');
        print(prediction);
        print('-------------------------');

        // for (var predict in prediction!) {
        setState(() {
          if (prediction!.isEmpty) {
            predictedLabel = '';
            predictedConfidence = '';

            return;
          }

          predictionList = prediction;

          predictedLabel = prediction[0]['label'];

          predictedConfidence = ((prediction[0]['confidence'] * 100 as double)
              .toStringAsFixed(0)
              .toString());
        });
        // }
        isModalRunning = false;
      });
    }
  }

  void _loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/orientation.txt',
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

  void _stopModel() {
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
        _stopModel();
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
            title: Row(
              children: const <Widget>[
                Text('Capture Front View'),
                SizedBox(width: 6),
                Icon(Icons.camera_alt_outlined),
              ],
            ),
            centerTitle: true,
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
                          aspectRatio: 1 / controller.value.aspectRatio,
                          child: CameraPreview(
                            controller,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (predictionList.isNotEmpty)
                                    OrientationPredictionWidget(
                                      predictedLabel,
                                      predictedConfidence,
                                    ),
                                ],
                              ),
                            ),
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
                            color: Color.fromARGB(255, 105, 105, 105),
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
