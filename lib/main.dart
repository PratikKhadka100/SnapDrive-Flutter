import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

import './screens/splash_screen.dart';
import './screens/home_screen.dart';
import './screens/camera_screen.dart';
// import './screens/orientation_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
      title: 'SnapDrive',
      theme: ThemeData(
        primaryColor: const Color(0xff8CBBF1),
        canvasColor: const Color(0xffFDFDFF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xffFCEECB),
        ),
        fontFamily: 'Poppins',
      ),
      routes: {
        '/': (ctx) => const SplashScreen(),
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        RegisterScreen.routeName: (ctx) => const RegisterScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        CameraScreen.routeName: (ctx) => CameraScreen(cameras: cameras),
        // OrientationScreen.routeName: (ctx) =>
        //     OrientationScreen(cameras: cameras)
      },
    );
  }
}
