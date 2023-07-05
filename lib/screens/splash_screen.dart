import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './login_screen.dart';
import './home_screen.dart';
import '../utils/snackbar_utils.dart';
import '../utils/custom_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userEmail;
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then(
      (value) {
        userEmail = value.getString('user') ?? '';

        if (userEmail!.isNotEmpty) {
          Future.delayed(const Duration(seconds: 3), () {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarUtils(
                context,
                'Logged in as $userEmail',
                Icons.check_circle_rounded,
                CustomColors.success,
              ),
            );
            Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,
            );
          });
        } else {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacementNamed(
              LoginScreen.routeName,
            );
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: LinearProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          ],
        )),
      ),
    );
  }
}
