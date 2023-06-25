import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import './register_screen.dart';
import './home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailValidate =
      ValidationBuilder().required('Required').email('Invalid Email').build();
  final passwordValidate = ValidationBuilder()
      .minLength(8, 'Password must be at least 8 characters')
      .required('Required')
      .build();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );

    final fillColor = Theme.of(context).colorScheme.secondary.withOpacity(0.7);

    const textFieldPadding = EdgeInsets.symmetric(horizontal: 26.0);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                    padding: textFieldPadding,
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: outlineInputBorder,
                        fillColor: fillColor,
                        filled: true,
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: Colors.black,
                        hintText: 'Email',
                      ),
                      controller: emailController,
                      validator: emailValidate,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: textFieldPadding,
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: outlineInputBorder,
                        fillColor: fillColor,
                        filled: true,
                        prefixIcon: const Icon(Icons.lock_rounded),
                        prefixIconColor: Colors.black,
                        hintText: 'Password',
                      ),
                      controller: passwordController,
                      validator: passwordValidate,
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
      ),
    );
  }
}
