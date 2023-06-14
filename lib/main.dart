import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import './screens/splash_screen.dart';
import './screens/home_screen.dart';
import './screens/camera_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({required this.cameras, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motor Desk',
      theme: ThemeData(
        primaryColor: const Color(0xff8CBBF1),
        canvasColor: const Color(0xffFDFDFF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xffFCEECB),
        ),
        fontFamily: 'Poppins',
      ),
      // home: SplashScreen(cameras: cameras),
      routes: {
        '/': (ctx) => const SplashScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        CameraScreen.routeName: (ctx) => CameraScreen(cameras: cameras)
      },
    );
  }
}
