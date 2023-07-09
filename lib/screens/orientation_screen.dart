import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img_lib;

import './home_screen.dart';
import './splash_screen.dart';
import './add_vehicle_screen.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/orientation_prediction_widget.dart';
import '../utils/dialog_utils.dart';
import '../utils/snackbar_utils.dart';
import '../utils/custom_colors.dart';

class OrientationScreen extends StatefulWidget {
  static const routeName = '/orientation-screen';

  final List<CameraDescription> cameras;

  const OrientationScreen({
    required this.cameras,
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
  List<String> base64ImgList = [];

  var isModalRunning = false;

  final orientationLabels = [
    'front',
    'front-right',
    'right',
    'back-right',
    'back',
    'back-left',
    'left',
    'front-left',
    'driverseat',
    'dashboard'
  ];

  var count = 8;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    _loadCamera();
    _loadModel();
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    controller.dispose();
    Tflite.close();
  }

  void _loadCamera() {
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
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
      ).then((prediction) {
        print('-------------------------');
        print(prediction);
        print('-------------------------');

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

        isModalRunning = false;
      });
    }
  }

  void _loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
        model: 'assets/model_unquant1.tflite',
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
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    isModalRunning = true;
    controller.stopImageStream();
  }

  void _takeCarPicture() {
    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }
    try {
      controller.takePicture().then((file) {
        // print(file.path);
        XFile rawImage = file;
        File imageFile = File(rawImage.path);

        imageFile.readAsBytes().then(
          (bytes) {
            // Uint8List imageBytes = bytes;
            img_lib.Image? decodedJpgImg = img_lib.decodeJpg(bytes);
            img_lib.Image resizedJpgImg = img_lib.copyResize(
              decodedJpgImg!,
              width: decodedJpgImg.width,
              height: (decodedJpgImg.width * 0.75).toInt(),
            );
            Uint8List imageBytes =
                Uint8List.fromList(img_lib.encodeJpg(resizedJpgImg));
            var base64EncodedImg = base64Encode(imageBytes);
            base64ImgList.add(base64EncodedImg);
            // var base64EncodedImg = base64Encode(imageBytes);
            // // log(base64EncodedImg);
            // base64ImgList.add(base64EncodedImg);
          },
        ).then((_) {
          setState(() {
            controller.startImageStream(
              (imageStream) {
                cameraImage = imageStream;
                _runModel();
              },
            );
          });
        });

        // GallerySaver.saveImage(
        //   rawImage.path,
        //   albumName: 'Cars',
        // );
      });
    } on CameraException catch (e) {
      print('Error occured while capturing image $e');
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtils(
          context,
          e.description,
          Icons.close_outlined,
          CustomColors.danger,
        ),
      );
    }
  }

  void _clickImageHandler() {
    isModalRunning = true;
    controller.stopImageStream();

    if (count < orientationLabels.length - 1) {
      setState(() {
        count = count + 1;
      });
    } else {
      _stopModel();

      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtils(
          context,
          'Snap-tastic! You\'ve captured it all!',
          Icons.check_circle_rounded,
          CustomColors.success,
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacementNamed(
          AddVehicleScreen.routeName,
          arguments: base64ImgList,
        );
      });
    }
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
            title: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      'Capture ${orientationLabels[count].toUpperCase()} View',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.camera_alt_outlined),
                ],
              ),
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
                            onPressed:
                                orientationLabels[count] == predictedLabel
                                    ? () {
                                        _clickImageHandler();
                                        _takeCarPicture();
                                      }
                                    : null,
                            icon: Icon(
                              Icons.camera,
                              color: orientationLabels[count] == predictedLabel
                                  ? CustomColors.success
                                  : CustomColors.danger,
                              size: 65,
                            ),
                          )),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
