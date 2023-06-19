import 'package:flutter/material.dart';

import './register_screen.dart';
import './home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      borderRadius: BorderRadius.circular(8),
    );

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Image.asset('assets/images/key.png'),
                ),
                const SizedBox(height: 30),
                Column(
                  children: const [
                    Text(
                      'SnapDrive',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Login to accelerate your experience',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: boxDecoration,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_rounded),
                        prefixIconColor: Colors.black,
                        hintText: 'Email',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: boxDecoration,
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_rounded),
                        prefixIconColor: Colors.black,
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                        HomeScreen.routeName,
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    overlayColor: MaterialStateProperty.all(Colors.blue),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(240),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Don\'t have an account ?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          RegisterScreen.routeName,
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
