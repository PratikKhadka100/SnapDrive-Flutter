import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './login_screen.dart';
import './camera_screen.dart';
import './orientation_screen.dart';
import '../utils/snackbar_utils.dart';
import '../utils/custom_colors.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  void _removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(11.0),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      DateFormat.yMMMEd().format(DateTime.now()),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  content:
                                      const Text('Logout of your account?'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        MaterialButton(
                                          color: Theme.of(ctx)
                                              .colorScheme
                                              .secondary,
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('No'),
                                        ),
                                        const SizedBox(width: 12),
                                        MaterialButton(
                                          color: Theme.of(ctx).primaryColor,
                                          onPressed: () {
                                            _removeUser();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              snackBarUtils(
                                                context,
                                                'Logout successfull',
                                                Icons.check_circle_rounded,
                                                CustomColors.success,
                                              ),
                                            );
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                              LoginScreen.routeName,
                                            );
                                          },
                                          child: const Text(
                                            'Yes',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ));
                        ;
                      },
                      icon: Icon(
                        Icons.logout_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                  width: mediaQuery.size.width * 0.6,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome to SnapDrive',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Capture your car image with proper orientation with the help of Artificial Intelligence.',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tap on the camera icon below to get started',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          height: mediaQuery.size.height * 0.1,
          width: mediaQuery.size.width * 0.2,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(OrientationScreen.routeName);
            },
            child: Icon(
              Icons.camera_enhance_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 40,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
